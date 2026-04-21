# CanNotDelete lock on the governance resource group.
#
# Effect: Users with Contributor cannot delete this resource group or the
# resources inside it (budget, action group). Removing a lock requires
# Microsoft.Authorization/locks/delete, which is only held by Owner and
# User Access Administrator roles — neither of which is granted to the
# subscription requester.
#
# The pipeline service principal (Owner) removes this lock automatically
# during the decommission pipeline before running terraform destroy.
resource "azapi_resource" "governance_rg_lock" {
  name      = "lock-governance-cannotdelete"
  parent_id = azapi_resource.governance_rg.id
  type      = "Microsoft.Authorization/locks@2020-05-01"

  body = {
    properties = {
      level = "CanNotDelete"
      notes = "Managed by the subscription vending pipeline. Do not remove manually."
    }
  }

  depends_on = [azapi_resource.governance_rg]
}
