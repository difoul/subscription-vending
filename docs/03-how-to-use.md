# How to Use Your Sandbox Subscription

## Accessing Your Subscription

After provisioning you will receive a confirmation email with your subscription ID. Access it via:

- **Azure Portal**: [portal.azure.com](https://portal.azure.com) → filter the subscription selector to your subscription name.
- **Azure CLI**: `az account set --subscription "<your-subscription-name-or-id>"`
- **Terraform**: set `subscription_id` in your provider block or use `ARM_SUBSCRIPTION_ID` environment variable.

You have the **Contributor** role, which lets you create, modify, and delete resources — but not manage RBAC or resource locks.

---

## What is Pre-Deployed

| Resource | Name | Purpose |
|---|---|---|
| Resource Group | `rg-sandbox-governance` | Contains protected governance resources. Do not try to delete it. |
| Budget | `budget-sandbox` | Tracks your monthly spend. |
| Action Group | `ag-sandbox-budget-alerts` | Sends email alerts at 80% and 100% of budget. |

These resources are protected with a `CanNotDelete` lock — any attempt to delete them will be denied.

---

## Budget Alerts

You will receive email notifications when your subscription spend reaches:

- **80% of budget** — early warning. Review your running resources.
- **100% of budget** — budget reached. Consider cleaning up resources to avoid overage. Note: Azure does not automatically stop resources when a budget is reached; you must act.

The budget resets monthly. The total lifetime cap aligns with your 3-month expiry date.

If your experiment requires more budget, open a ticket — see [How to Request](./02-how-to-request.md).

---

## Subscription Limits and Tips

- Deploy resources in any Azure region (no restrictions are enforced at the subscription level).
- You can create multiple resource groups. They are not protected — you can create and delete them freely.
- No VNet is pre-deployed. Create one if your workload requires it.
- DevTest-offer subscriptions have the same service availability as Production but come with lower rates for certain services (e.g., Windows VMs). Check the [DevTest offer terms](https://azure.microsoft.com/offers/ms-azr-0148p/) if pricing matters for your test.

---

## Inactivity Policy

If no resource create/update/delete operations are detected for **30 consecutive days**, your subscription will be automatically disabled and you will be notified by email.

To keep your subscription active:
- Make any resource change (creating a resource, updating a tag, running a deployment).
- Even a minimal change (e.g., updating a tag on a resource group) counts.

---

## Before Expiry — Exporting Your Configuration

You will receive an expiry warning email **14 days before** your subscription is disabled. Use this window to export anything you want to keep.

### Export ARM templates
```bash
# Export a resource group as an ARM template
az group export --name <resource-group-name> --subscription <sub-id> > my-rg-export.json
```

### Export Terraform state
If you used Terraform within your sandbox, run:
```bash
terraform show -json > terraform-state-export.json
```

### Capture configuration screenshots or notes
For resources that don't export cleanly (App Service configs, API Management policies, etc.), capture the configuration from the Azure portal before expiry.

---

## After Expiry or Inactivity Disable

When your subscription is disabled:
- Resources are **preserved for 7 days** in read-only state. You can still read configuration and export data.
- After 7 days, the ops team runs the decommission pipeline which permanently deletes all resources.
- The subscription is then cancelled.

To access a disabled subscription for export, contact the ops team via ticket.

---

## Requesting an Extension

Open a ticket before your expiry date — see [How to Request](./02-how-to-request.md#requesting-an-extension). Extensions are approved on a case-by-case basis and reset the clock by 90 days.
