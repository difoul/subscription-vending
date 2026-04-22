# ---------------------------------------------------------------------------
# Shared constants — same for all subscriptions.
# Set in shared.auto.tfvars (managed by ops, rarely changes).
# ---------------------------------------------------------------------------

variable "billing_scope" {
  description = "Billing scope for subscription creation. EA: /providers/Microsoft.Billing/billingAccounts/<id>/enrollmentAccounts/<id> | MCA: /providers/Microsoft.Billing/billingAccounts/<id>/billingProfiles/<id>/invoiceSections/<id>"
  type        = string
}

variable "management_group_id" {
  description = "Resource ID of the Management Group where all sandbox subscriptions are placed."
  type        = string
}

variable "ops_email" {
  description = "Central ops team email. Receives a copy of all budget alerts and lifecycle notifications."
  type        = string
}

# ---------------------------------------------------------------------------
# Subscription definitions — managed in subscriptions.auto.tfvars.
# Ops adds/removes entries here to provision or decommission subscriptions.
# ---------------------------------------------------------------------------

variable "subscriptions" {
  description = "Map of all sandbox subscriptions to provision. Key = subscription display name (must start with 'sandbox-')."
  type = map(object({
    owner_user_principal_name = string
    owner_email               = string
    budget_amount             = optional(number, 500)
    location                  = optional(string, "westeurope")
    workload_type             = optional(string, "DevTest")
    additional_tags           = optional(map(string), {})
  }))
  default = {}

  validation {
    condition     = alltrue([for k, _ in var.subscriptions : startswith(k, "sandbox-")])
    error_message = "All subscription keys (display names) must start with 'sandbox-'."
  }
}
