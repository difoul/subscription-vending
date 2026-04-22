# # Look up the requester's object ID from their UPN.
# data "azuread_user" "owner" {
#   user_principal_name = var.owner_user_principal_name
# }

# # Grant Contributor at the subscription scope.
# # Contributor can create/modify/delete resources but CANNOT manage RBAC or locks,
# # so they cannot remove the CanNotDelete lock protecting the governance RG.
# resource "azurerm_role_assignment" "owner_contributor" {
#   scope                = "/subscriptions/${local.subscription_id}"
#   role_definition_name = "Contributor"
#   principal_id         = data.azuread_user.owner.object_id

#   depends_on = [time_sleep.wait_for_subscription]
# }
