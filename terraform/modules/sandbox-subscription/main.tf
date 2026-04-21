# ---------------------------------------------------------------------------
# 1. Subscription alias (EA programmatic creation via azapi)
#
# azapi targets the tenant root (parent_id = "/") and calls the ARM API
# directly — no provider alias, no subscription context required.
# response_export_values captures the real subscription GUID from the API
# response in the same apply, making it available to all dependent resources
# without a second plan/apply pass.
#
# lifecycle.ignore_changes prevents re-creation on subsequent plans when
# Terraform re-evaluates the body; the alias is idempotent once created.
# ---------------------------------------------------------------------------
resource "azapi_resource" "subscription" {
  name      = var.subscription_display_name
  parent_id = "/"
  type      = "Microsoft.Subscription/aliases@2021-10-01"

  body = {
    properties = {
      displayName  = var.subscription_display_name
      workload     = var.workload_type
      billingScope = var.billing_scope
    }
  }

  response_export_values = ["properties.subscriptionId"]

  lifecycle {
    ignore_changes = [body, name]
  }
}

# ---------------------------------------------------------------------------
# 2. Propagation delay
#
# Subscription creation is eventually consistent. A short sleep ensures the
# new subscription ID is resolvable by ARM before dependent operations run.
# ---------------------------------------------------------------------------
resource "time_sleep" "wait_for_subscription" {
  create_duration = "30s"
  depends_on      = [azapi_resource.subscription]
}

# ---------------------------------------------------------------------------
# 3. Management Group placement
#
# azapi_resource_action issues a PUT to the MG/subscriptions child resource,
# which is the canonical way to associate a subscription with a MG. This does
# not require a subscription-scoped provider alias.
# ---------------------------------------------------------------------------
resource "azapi_resource_action" "mg_association" {
  method      = "PUT"
  resource_id = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}/subscriptions/${local.subscription_id}"
  type        = "Microsoft.Management/managementGroups/subscriptions@2021-04-01"

  depends_on = [time_sleep.wait_for_subscription]
}

# ---------------------------------------------------------------------------
# 4. Governance resource group (protected — users cannot delete it)
#
# Deployed directly into the new subscription via azapi parent_id.
# No provider alias needed.
# ---------------------------------------------------------------------------
resource "azapi_resource" "governance_rg" {
  name      = "rg-sandbox-governance"
  parent_id = "/subscriptions/${local.subscription_id}"
  type      = "Microsoft.Resources/resourceGroups@2022-09-01"
  location  = var.location

  body = {
    tags = local.lifecycle_tags
  }

  depends_on = [time_sleep.wait_for_subscription]
}

# ---------------------------------------------------------------------------
# 5. Subscription-level tags
#
# azapi_update_resource merges tags onto the subscription resource without
# replacing other properties (PATCH semantics).
# ---------------------------------------------------------------------------
resource "azapi_update_resource" "subscription_tags" {
  resource_id = "/subscriptions/${local.subscription_id}"
  type        = "Microsoft.Resources/subscriptions@2022-09-01"

  body = {
    tags = local.lifecycle_tags
  }

  depends_on = [time_sleep.wait_for_subscription]
}
