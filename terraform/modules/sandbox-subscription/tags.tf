# Use a static timestamp so the expiry date is computed once at apply time
# and does not drift on subsequent plans.
resource "time_static" "created" {}

locals {
  # Extract the real subscription GUID from the azapi response.
  subscription_id = azapi_resource.subscription.output.properties.subscriptionId

  created_date = formatdate("YYYY-MM-DD", time_static.created.rfc3339)

  # 90 days = 2160 hours
  expiry_date = formatdate("YYYY-MM-DD", timeadd(time_static.created.rfc3339, "2160h"))

  lifecycle_tags = merge(var.additional_tags, {
    sandbox-owner       = var.owner_user_principal_name
    sandbox-owner-email = var.owner_email
    sandbox-created     = local.created_date
    sandbox-expiry      = local.expiry_date
    sandbox-budget      = tostring(var.budget_amount)
    sandbox-status      = "active"
    environment         = "sandbox"
  })
}
