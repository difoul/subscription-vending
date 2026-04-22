# ---------------------------------------------------------------------------
# Governance RG lock — STEP 3 (commented out until governance RG is verified)
# ---------------------------------------------------------------------------

# resource "azapi_resource" "governance_rg_lock" {
#   name      = "lock-governance-cannotdelete"
#   parent_id = azapi_resource.governance_rg.id
#   type      = "Microsoft.Authorization/locks@2020-05-01"
#
#   body = {
#     properties = {
#       level = "CanNotDelete"
#       notes = "Managed by the subscription vending pipeline. Do not remove manually."
#     }
#   }
#
#   depends_on = [azapi_resource.governance_rg]
# }
