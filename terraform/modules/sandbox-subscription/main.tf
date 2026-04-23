# ---------------------------------------------------------------------------
# 1. Subscription alias (EA/MCA programmatic creation via azapi)
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
      additionalProperties = {
        managementGroupId = "/providers/Microsoft.Management/managementGroups/${var.management_group_id}"
      }
    }
  }

  response_export_values = {
    subscription_id = "properties.subscriptionId"
  }

  lifecycle {
    ignore_changes = [body, name]
  }
}

# ---------------------------------------------------------------------------
# 2. Governance resource group (protected — users cannot delete it)
#
# Deployed directly into the new subscription via azapi parent_id.
# No provider alias needed.
#
# retry handles eventual consistency — the new subscription ID may not be
# resolvable by ARM immediately after creation.
# ---------------------------------------------------------------------------
resource "azapi_resource" "governance_rg" {
  name      = "rg-sandbox-governance"
  parent_id = "/subscriptions/${local.subscription_id}"
  type      = "Microsoft.Resources/resourceGroups@2022-09-01"
  location  = var.location

  body = {
    tags = local.lifecycle_tags
  }

  retry = {
    error_message_regex  = ["SubscriptionNotFound", "LinkedAuthorizationFailed"]
    interval_seconds     = 10
    max_interval_seconds = 60
  }

  depends_on = [azapi_resource.subscription]
}

# ---------------------------------------------------------------------------
# 3. Destroy-time subscription cancellation
#
# Fires only during terraform destroy (when = "destroy"). Soft-cancels the
# subscription before Terraform attempts to delete the alias resource.
# retry handles the case where Azure rejects cancellation because resources
# still exist inside the subscription — the pipeline's decommission:prepare
# step removes the lock and empties the governance RG first, but this retry
# ensures destroy is safe even when called directly.
# ---------------------------------------------------------------------------
resource "azapi_resource_action" "subscription_cancel" {
  action      = "providers/Microsoft.Subscription/cancel"
  method      = "POST"
  resource_id = "/subscriptions/${local.subscription_id}"
  type        = "Microsoft.Resources/subscriptions@2021-10-01"
  when        = "destroy"

  retry = {
    error_message_regex = ["ResourcesExistingOnSubscription"]
  }

  timeouts {
    create = "30m"
    delete = "30m"
    read   = "30m"
    update = "30m"
  }

  depends_on = [azapi_resource.subscription]
}

# ---------------------------------------------------------------------------
# 4. Subscription-level tags
#
# azapi_resource targets the Tags child resource (PUT semantics) on the
# subscription — the correct ARM path for subscription-level tag management.
# ---------------------------------------------------------------------------
resource "azapi_resource" "subscription_tags" {
  type      = "Microsoft.Resources/tags@2022-09-01"
  name      = "default"
  parent_id = "/subscriptions/${local.subscription_id}"

  body = {
    properties = {
      tags = local.lifecycle_tags
    }
  }

  retry = {
    error_message_regex  = ["SubscriptionNotFound", "LinkedAuthorizationFailed"]
    interval_seconds     = 10
    max_interval_seconds = 60
  }

  depends_on = [azapi_resource.subscription]
}
