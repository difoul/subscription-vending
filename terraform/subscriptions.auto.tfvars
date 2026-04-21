# ---------------------------------------------------------------------------
# Sandbox subscription definitions.
#
# To provision a new subscription: add an entry below and open an MR.
# To decommission: run the decommission pipeline first (SUB_NAME + SUB_ID),
# then remove the entry here and merge.
#
# Key = subscription display name (must start with "sandbox-", no spaces).
# ---------------------------------------------------------------------------

subscriptions = {
  # "sandbox-jdoe-api-testing" = {
  #   owner_user_principal_name = "jdoe@company.com"
  #   owner_email               = "jdoe@company.com"
  #   budget_amount             = 500                          # optional, default 500
  #   location                  = "westeurope"                 # optional
  #   workload_type             = "DevTest"                    # optional
  #   additional_tags           = { ticket-id = "INC0012345", team = "backend" }
  # }
}
