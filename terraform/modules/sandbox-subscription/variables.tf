variable "subscription_display_name" {
  description = "Display name for the sandbox subscription. Follow the org naming convention (e.g., sandbox-<username>-<purpose>)."
  type        = string

  validation {
    condition     = can(regex("^sandbox-", var.subscription_display_name))
    error_message = "Subscription name must start with 'sandbox-'."
  }
}

variable "billing_scope" {
  description = "EA enrollment account billing scope. Format: /providers/Microsoft.Billing/billingAccounts/<id>/enrollmentAccounts/<id>"
  type        = string
}

variable "management_group_id" {
  description = "Resource ID of the Management Group where sandbox subscriptions are placed."
  type        = string
}

variable "owner_user_principal_name" {
  description = "Azure AD UPN (e.g., jdoe@company.com) of the subscription requester. Used for RBAC lookup."
  type        = string
}

variable "owner_email" {
  description = "Email address of the subscription owner. Used for budget alerts and lifecycle notifications."
  type        = string
}

variable "ops_email" {
  description = "Central ops team email address. Receives a copy of all budget alerts and lifecycle notifications."
  type        = string
}

variable "budget_amount" {
  description = "Monthly budget cap in USD. Alerts fire at 80% and 100%."
  type        = number
  default     = 500

  validation {
    condition     = var.budget_amount > 0
    error_message = "Budget amount must be greater than 0."
  }
}

variable "location" {
  description = "Azure region for the governance resource group."
  type        = string
  default     = "westeurope"
}

variable "workload_type" {
  description = "EA workload type. 'DevTest' reduces costs and is the default for sandboxes. Use 'Production' only when explicitly required."
  type        = string
  default     = "DevTest"

  validation {
    condition     = contains(["DevTest", "Production"], var.workload_type)
    error_message = "workload_type must be 'DevTest' or 'Production'."
  }
}

variable "additional_tags" {
  description = "Optional extra tags to apply to the subscription (e.g., team, cost-center)."
  type        = map(string)
  default     = {}
}
