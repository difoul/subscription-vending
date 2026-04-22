# Sandbox Subscription — Composition and Lifecycle

## Overview

Each sandbox subscription is a self-contained Azure subscription provisioned by the vending
pipeline. It is fully isolated (no shared networking), governed by a set of Azure resources
deployed at creation time, and subject to automatic lifecycle checks that disable it when it
expires or goes inactive.

---

## Composition

### 1. Azure Subscription (alias)

Created via `Microsoft.Subscription/aliases@2021-10-01`. The alias call is tenant-scoped, so
no existing subscription context is required.

| Property | Value |
|---|---|
| Naming convention | Must start with `sandbox-` |
| Billing | Charged to the configured EA enrollment account or MCA invoice section |
| Management Group | Placed inline at creation via `additionalProperties.managementGroupId` |
| Workload type | `DevTest` by default (lower cost); `Production` only on explicit request |

The real subscription GUID is extracted from the ARM API response in the same apply pass
(`response_export_values = { subscription_id = "properties.subscriptionId" }`), so **a
single Terraform apply is sufficient** — no two-pass workaround.

---

### 2. Lifecycle Tags

Applied to both the subscription resource and the governance resource group at creation.
Timestamps are fixed by `time_static` (not `timestamp()`) so values never drift on
subsequent plans.

| Tag | Example value | Purpose |
|---|---|---|
| `sandbox-owner` | `jdoe@company.com` | UPN of the requester |
| `sandbox-owner-email` | `jdoe@company.com` | Email for notifications |
| `sandbox-created` | `2026-04-22` | Date of first apply |
| `sandbox-expiry` | `2026-07-21` | Created + 90 days (2 160 h) |
| `sandbox-budget` | `500` | Monthly cap in USD |
| `sandbox-status` | `active` / `disabled` | Updated by lifecycle automation |
| `environment` | `sandbox` | Used for policy and cost queries |

---

### 3. Governance Resource Group (`rg-sandbox-governance`)

A dedicated resource group that holds all lifecycle control-plane resources. Users have
**Contributor** access at subscription scope, which does not include
`Microsoft.Authorization/locks/delete` — so they cannot tamper with the resources below.

**Contents:**

| Resource | Type | Purpose |
|---|---|---|
| `lock-governance-cannotdelete` | `Microsoft.Authorization/locks` | `CanNotDelete` lock — prevents accidental removal of the governance RG |
| `ag-sandbox-budget-alerts` | `Microsoft.Insights/actionGroups` | Email action group targeting the owner and ops |
| `budget-sandbox` | `azurerm_consumption_budget_subscription` | Monthly budget cap with alerts at 80% and 100% |

The lock must be removed by the pipeline service principal (Owner role) before any destroy
can succeed. This is handled automatically by the decommission pipeline.

---

### 4. Budget and Alerts

| Threshold | Recipients | Trigger |
|---|---|---|
| 80% of monthly cap | Owner + Ops | Actual spend |
| 100% of monthly cap | Owner + Ops | Actual spend |

Budget start date is the first day of the month of creation. End date aligns with the
subscription expiry date.

---

### 5. RBAC

The subscription owner is granted **Contributor** at subscription scope. This gives full
resource management rights while explicitly excluding RBAC management and lock operations.

> Note: the RBAC assignment (`rbac.tf`) is currently commented out pending UPN lookup
> verification. Until it is re-enabled, access must be granted manually after provisioning.

---

## Lifecycle

### States

```
active ──► (expiry reached or 30-day inactivity) ──► disabled
```

A subscription is created in `active` state. The `sandbox-status` tag is the authoritative
state indicator. The lifecycle automation targets only subscriptions tagged `sandbox-status=active`.

---

### Daily Automation (Azure Automation Account)

The `lifecycle_check.py` runbook executes daily at **02:00 UTC** from an Azure Automation
Account using a system-assigned Managed Identity. No packages beyond the Python 3.10
standard library are required.

**Check order per subscription:**

1. **Expiry check** — reads `sandbox-expiry` tag.
   - If today ≥ expiry → **disable** (see below) + notify owner and ops.
   - If today is within 14 days of expiry → **warn** owner only (no disable).

2. **Inactivity check** (skipped if already disabled in step 1) — queries the Activity Log
   for write or delete operations in the last 30 days.
   - If count = 0 → **disable** + notify owner and ops.

---

### Disable Sequence

When a subscription is disabled (by automation or ops), the following steps execute in order:

```
1. DELETE  /subscriptions/{id}/resourceGroups/rg-sandbox-governance
           /providers/Microsoft.Authorization/locks/lock-governance-cannotdelete

2. POST    /subscriptions/{id}/providers/Microsoft.Subscription/cancel

3. PATCH   /subscriptions/{id}/providers/Microsoft.Resources/tags/default
           → sandbox-status = disabled
```

Step 1 is 404-safe — if the lock is already gone the sequence continues.

After cancellation, **Azure preserves all resources for 90 days** before permanent deletion.
The subscription can be inspected and data exported during that window.

---

### Extension

Run the `extend:reset-expiry` pipeline with `SUB_ID`. This replaces the `time_static`
resource in the Terraform state, recalculates `sandbox-expiry` to today + 90 days, and
re-applies the tags.

---

### Permanent Decommission (ops-initiated)

Ops workflow before removing an entry from `subscriptions.auto.tfvars`:

```
1. Run  decommission:prepare  (pipeline variable: SUB_NAME + SUB_ID)
        → removes the CanNotDelete lock
        → cancels the subscription

2. Remove the map entry from subscriptions.auto.tfvars

3. Open MR → CI shows a destroy plan → merge → trigger provision:apply
        → Terraform removes all managed resources from state
```

**Do not skip step 1.** Removing the map entry without running `decommission:prepare` will
cause `terraform destroy` to fail because the locked governance RG cannot be deleted.

---

## Key Invariants

- `time_static.created` must never be tainted — it controls the expiry date permanently.
- `rg-sandbox-governance` is hardcoded in `disable-subscription.sh` — do not rename it.
- All subscription map keys must start with `sandbox-` (enforced by Terraform validation).
- `ARM_SUBSCRIPTION_ID` in CI is a platform/management subscription, not a sandbox — it is
  only the authentication context for the `azurerm` provider.
