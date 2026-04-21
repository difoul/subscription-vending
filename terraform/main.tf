# ---------------------------------------------------------------------------
# Instantiates one sandbox subscription per entry in var.subscriptions.
# To provision: add an entry to subscriptions.auto.tfvars and apply.
# To decommission: run the decommission pipeline first (removes the lock and
# cancels the subscription), then remove the entry and apply.
# ---------------------------------------------------------------------------

module "sandbox_subscription" {
  for_each = var.subscriptions
  source   = "./modules/sandbox-subscription"

  subscription_display_name = each.key
  billing_scope             = var.billing_scope
  management_group_id       = var.management_group_id
  ops_email                 = var.ops_email

  owner_user_principal_name = each.value.owner_user_principal_name
  owner_email               = each.value.owner_email
  budget_amount             = each.value.budget_amount
  location                  = each.value.location
  workload_type             = each.value.workload_type
  additional_tags           = each.value.additional_tags
}
