# Single output map — read by lifecycle-check.sh from the GitLab state API.
output "subscriptions" {
  description = "Map of all provisioned sandbox subscriptions with their lifecycle data."
  value = {
    for key, mod in module.sandbox_subscription : key => {
      subscription_id = mod.subscription_id
      expiry_date     = mod.expiry_date
      owner_email     = mod.owner_email
      budget_amount   = mod.budget_amount
    }
  }
}
