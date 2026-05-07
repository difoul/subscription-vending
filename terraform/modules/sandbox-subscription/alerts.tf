resource "azapi_resource" "subscription_alert" {
  name      = "alert-${var.subscription_display_name}"
  parent_id = azapi_resource.governance_rg.id
  type      = "Microsoft.Insights/scheduledQueryRules@2023-03-15-preview"
  location  = var.location

  identity {
    type = "SystemAssigned"
  }

  response_export_values = {
    principal_id = "identity.principalId"
  }

  body = {
    properties = {
      description         = "Fires when the subscription has passed its expiry date or has been disabled."
      severity            = 2
      enabled             = true
      scopes              = ["/subscriptions/${local.subscription_id}"]
      evaluationFrequency = "P1D"
      windowSize          = "P1D"
      autoMitigate        = false
      criteria = {
        allOf = [
          {
            query = <<-EOQ
              ResourceContainers
              | where type == "microsoft.resources/subscriptions"
              | where subscriptionId == "${local.subscription_id}"
              | where todatetime(tags["sandbox-expiry"]) < now()
                  or tostring(tags["sandbox-status"]) == "disabled"
              | project name, subscriptionId,
                  expiryDate = tags["sandbox-expiry"],
                  status     = tags["sandbox-status"],
                  owner      = tags["sandbox-owner-email"]
            EOQ
            timeAggregation = "Count"
            operator        = "GreaterThan"
            threshold       = 0
            failingPeriods = {
              numberOfEvaluationPeriods = 1
              minFailingPeriodsToAlert  = 1
            }
          }
        ]
      }
      actions = {
        actionGroups = [azapi_resource.budget_action_group.id]
      }
    }
  }

  depends_on = [azapi_resource.governance_rg, azapi_resource.budget_action_group]
}
