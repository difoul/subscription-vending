terraform {
  required_version = ">= 1.5.0"

  required_providers {
    # azapi is a thin layer over the Azure REST API. Used for all resources that
    # target the new sandbox subscription (subscription alias, governance RG,
    # action group, management lock, tags). It does not require a pre-configured
    # subscription context — resources are scoped via parent_id / resource_id
    # arguments, which solves the chicken-and-egg problem with provider aliases.
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.5"
    }

    # azurerm (default provider) is used only for resources that accept the
    # target subscription as an argument rather than via provider scoping:
    #   - azurerm_consumption_budget_subscription (subscription_id argument)
    #   - azurerm_role_assignment (scope argument)
    # ARM_SUBSCRIPTION_ID must be set to an existing platform/management
    # subscription — NOT a sandbox. It is only the authentication context.
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.69.0"
    }

    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0"
    }

    time = {
      source  = "hashicorp/time"
      version = "~> 0.12"
    }
  }
}

