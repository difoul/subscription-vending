# ---------------------------------------------------------------------------
# Budget — STEP 3 (commented out until governance RG is verified)
# ---------------------------------------------------------------------------

# resource "azapi_resource" "budget_action_group" {
#   name      = "ag-sandbox-budget-alerts"
#   parent_id = azapi_resource.governance_rg.id
#   type      = "Microsoft.Insights/actionGroups@2023-01-01"
#   location  = "global"
#
#   body = {
#     properties = {
#       groupShortName = "budgetalrt"
#       enabled        = true
#       emailReceivers = [
#         {
#           name                 = "owner"
#           emailAddress         = var.owner_email
#           useCommonAlertSchema = true
#         },
#         {
#           name                 = "ops"
#           emailAddress         = var.ops_email
#           useCommonAlertSchema = true
#         }
#       ]
#     }
#   }
#
#   depends_on = [azapi_resource.governance_rg]
# }

# resource "azurerm_consumption_budget_subscription" "sandbox" {
#   name            = "budget-sandbox"
#   subscription_id = "/subscriptions/${local.subscription_id}"
#   amount          = var.budget_amount
#   time_grain      = "Monthly"
#
#   time_period {
#     start_date = "${formatdate("YYYY-MM", time_static.created.rfc3339)}-01T00:00:00Z"
#     end_date   = "${local.expiry_date}T23:59:59Z"
#   }
#
#   notification {
#     enabled        = true
#     threshold      = 80
#     operator       = "GreaterThan"
#     threshold_type = "Actual"
#     contact_emails = [var.owner_email, var.ops_email]
#     contact_groups = [azapi_resource.budget_action_group.id]
#   }
#
#   notification {
#     enabled        = true
#     threshold      = 100
#     operator       = "GreaterThan"
#     threshold_type = "Actual"
#     contact_emails = [var.owner_email, var.ops_email]
#     contact_groups = [azapi_resource.budget_action_group.id]
#   }
#
#   depends_on = [azapi_resource.governance_rg, azapi_resource.budget_action_group]
# }
