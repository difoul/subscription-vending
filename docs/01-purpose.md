# Sandbox Subscriptions — Purpose and Constraints

## What is a Sandbox Subscription?

A sandbox subscription is a dedicated, isolated Azure subscription provisioned for experimentation, prototyping, and testing. It gives you a clean Azure environment where you can explore services, validate architectures, and run tests without any risk of interfering with production systems.

Sandbox subscriptions are **fully autonomous**: no shared networking, no peering to production hubs, no inherited governance constraints beyond the basics described here.

---

## When to Use a Sandbox Subscription

| Good use cases | Not suitable for |
|---|---|
| Exploring a new Azure service | Hosting production or pre-production workloads |
| Prototyping an architecture | Processing real customer or sensitive data |
| Learning and certification preparation | Long-running services (use a project subscription instead) |
| Running isolated integration tests | Workloads requiring production SLAs |
| Reproducing an issue in a clean environment | Storing regulated data (GDPR, PCI, HIPAA) |

---

## What You Get

When your sandbox subscription is provisioned, the following resources are deployed automatically:

| Resource | Details |
|---|---|
| **Azure Subscription** | DevTest offer by default (lower cost). Placed in the Sandbox Management Group. |
| **Governance Resource Group** (`rg-sandbox-governance`) | Contains managed resources. **Cannot be deleted by you.** |
| **Budget** | $500/month by default (configurable). Scoped to the entire subscription. |
| **Budget Alerts** | Email notifications at 80% and 100% of budget — sent to you and the ops team. |
| **RBAC** | You receive the **Contributor** role on the subscription. |

---

## Constraints and Limits

| Constraint | Value |
|---|---|
| **Lifetime** | 3 months from creation date |
| **Monthly budget** | $500 (can be increased — request in your ticket) |
| **Inactivity policy** | Subscription is disabled if no resource changes are detected for 30 days |
| **Your role** | Contributor (you cannot manage RBAC, locks, or subscriptions) |
| **Governance resources** | The `rg-sandbox-governance` resource group and its contents are protected and cannot be deleted |
| **Networking** | No VNet is pre-deployed; no peering to shared networks |
| **Azure Policies** | Managed separately by the platform team — not covered here |

---

## Lifecycle

```
Created → Active (3 months) → Expiry warning (2 weeks before) → Disabled → Cleaned up
                     ↓
           Inactive for 30 days → Disabled → Cleaned up
```

1. **Active**: You have full Contributor access. Budget alerts fire at 80% and 100%.
2. **Expiry warning**: You receive an email 14 days before expiry. Request an extension if needed.
3. **Disabled**: The subscription is cancelled (soft). Resources are preserved for 7 days so you can export configurations.
4. **Cleaned up**: After 7 days, all resources are permanently deleted.

Extensions can be requested — see [How to Request a Subscription](./02-how-to-request.md).
