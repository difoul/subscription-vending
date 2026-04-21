# ---------------------------------------------------------------------------
# Action group — recipients for budget alert emails
#
# Deployed via azapi into the governance RG of the new subscription.
# ---------------------------------------------------------------------------
resource "azapi_resource" "budget_action_group" {
  name      = "ag-sandbox-budget-alerts"
  parent_id = azapi_resource.governance_rg.id
  type      = "Microsoft.Insights/actionGroups@2023-01-01"
  location  = "global"

  body = {
    properties = {
      groupShortName = "budgetalrt"
      enabled        = true
      emailReceivers = [
        {
          name                 = "owner"
          emailAddress         = var.owner_email
          useCommonAlertSchema = true
        },
        {
          name                 = "ops"
          emailAddress         = var.ops_email
          useCommonAlertSchema = true
        }
      ]
    }
  }

  depends_on = [azapi_resource.governance_rg]
}

# ---------------------------------------------------------------------------
# Subscription-level budget with alerts at 80% (warning) and 100% (critical)
#
# azurerm_consumption_budget_subscription is kept with the default azurerm
# provider because it accepts subscription_id as an argument — no alias needed.
# ---------------------------------------------------------------------------
resource "azurerm_consumption_budget_subscription" "sandbox" {
  name            = "budget-sandbox"
  # azurerm v4 requires the full subscription resource ID, not the alias ID (.id).
  subscription_id = "/subscriptions/${local.subscription_id}"
  amount          = var.budget_amount
  time_grain      = "Monthly"

  time_period {
    # Budget starts on the first day of the month the subscription was created.
    # Note: single quotes are NOT escape characters in Terraform formatdate — T and Z
    # are non-sequence characters and pass through as literals without quoting.
    start_date = formatdate("YYYY-MM-01T00:00:00Z", time_static.created.rfc3339)
    # End date aligns with the subscription expiry.
    end_date = "${local.expiry_date}T23:59:59Z"
  }

  # 80% threshold — early warning.
  # contact_groups wires in the action group (which lives in the protected governance RG).
  # contact_emails is kept as a fallback in case the action group is not yet available.
  notification {
    enabled        = true
    threshold      = 80
    operator       = "GreaterThan"
    threshold_type = "Actual"
    contact_emails = [var.owner_email, var.ops_email]
    contact_groups = [azapi_resource.budget_action_group.id]
  }

  # 100% threshold — budget reached.
  notification {
    enabled        = true
    threshold      = 100
    operator       = "GreaterThan"
    threshold_type = "Actual"
    contact_emails = [var.owner_email, var.ops_email]
    contact_groups = [azapi_resource.budget_action_group.id]
  }

  depends_on = [azapi_resource.governance_rg, azapi_resource.budget_action_group]
}
