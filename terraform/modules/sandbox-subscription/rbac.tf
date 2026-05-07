# Grant Contributor at subscription scope, time-bounded to match subscription expiry.
# Group object ID is passed directly — no AAD user lookup required.
# Requires Azure AD P2 / Microsoft Entra ID Governance (PIM).
resource "azurerm_pim_active_role_assignment" "group_contributor" {
  scope              = "/subscriptions/${local.subscription_id}"
  role_definition_id = "/subscriptions/${local.subscription_id}/providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c"
  principal_id       = var.owner_group_object_id
  justification      = "Sandbox subscription access — expires with subscription on ${local.expiry_date}."

  schedule {
    expiration {
      end_date_time = "${local.expiry_date}T23:59:59Z"
    }
  }

  depends_on = [azapi_resource.governance_rg, azapi_resource_action.subscription_cancel]
}

# Reader on the subscription — lets the alert rule's managed identity query
# Resource Graph (ResourceContainers) when evaluating the scheduled query rule.
resource "azurerm_role_assignment" "alert_reader" {
  scope                = "/subscriptions/${local.subscription_id}"
  role_definition_name = "Reader"
  principal_id         = azapi_resource.subscription_alert.output.principal_id
}
