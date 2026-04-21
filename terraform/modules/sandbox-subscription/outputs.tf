output "subscription_id" {
  description = "The Azure subscription ID of the newly created sandbox."
  value       = local.subscription_id
}

output "subscription_name" {
  description = "Display name of the sandbox subscription."
  value       = var.subscription_display_name
}

output "governance_resource_group_id" {
  description = "Resource ID of the protected governance resource group."
  value       = azapi_resource.governance_rg.id
}

output "expiry_date" {
  description = "ISO date (YYYY-MM-DD) when this subscription expires and will be disabled."
  value       = local.expiry_date
}

output "owner_email" {
  description = "Email address of the subscription owner."
  value       = var.owner_email
}

output "budget_amount" {
  description = "Monthly budget cap in USD."
  value       = var.budget_amount
}
