# Sources and References

All documentation, registry entries, and specifications consulted during the design and implementation of this subscription vending pipeline.

---

## Azure Cloud Adoption Framework

| Topic | URL |
|---|---|
| Subscription vending overview | https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/subscription-vending |
| How to implement subscription vending | https://learn.microsoft.com/azure/cloud-adoption-framework/ready/landing-zone/design-area/subscription-vending#how-to-implement-subscription-vending |
| Subscription vending implementation guidance | https://learn.microsoft.com/azure/architecture/landing-zones/subscription-vending |
| Create a subscription (implementation) | https://learn.microsoft.com/azure/architecture/landing-zones/subscription-vending#create-a-subscription |

---

## Azure Cost Management & Billing

| Topic | URL |
|---|---|
| Create EA subscriptions programmatically (latest APIs) | https://learn.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription-enterprise-agreement |
| Find enrollment accounts you have access to | https://learn.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription-enterprise-agreement#find-accounts-you-have-access-to |
| Create subscriptions under a specific enrollment account | https://learn.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription-enterprise-agreement#create-subscriptions-under-a-specific-enrollment-account |
| Create subscriptions in a different tenant | https://learn.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription-enterprise-agreement#create-subscriptions-in-a-different-tenant |
| Limitations of the EA subscription creation API | https://learn.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription-enterprise-agreement#limitations-of-azure-enterprise-subscription-creation-api |
| Create an Enterprise Agreement subscription (portal) | https://learn.microsoft.com/azure/cost-management-billing/manage/create-enterprise-subscription |
| Create Azure subscriptions programmatically (all agreement types) | https://learn.microsoft.com/azure/cost-management-billing/manage/programmatically-create-subscription |

---

## Azure Resource Manager

| Topic | URL |
|---|---|
| Lock resources to protect infrastructure | https://learn.microsoft.com/azure/azure-resource-manager/management/lock-resources |
| Who can create or delete locks | https://learn.microsoft.com/azure/azure-resource-manager/management/lock-resources#who-can-create-or-delete-locks |
| Microsoft.Authorization/locks ARM template reference (2020-05-01) | https://learn.microsoft.com/azure/templates/microsoft.authorization/2020-05-01/locks |
| Microsoft.Authorization/locks ARM template reference (latest) | https://learn.microsoft.com/azure/templates/microsoft.authorization/locks |

---

## Azure Monitor

| Topic | URL |
|---|---|
| Activity log in Azure Monitor | https://learn.microsoft.com/azure/azure-monitor/platform/activity-log |
| View and retrieve the activity log | https://learn.microsoft.com/azure/azure-monitor/platform/activity-log#view-and-retrieve-the-activity-log |
| Activity log entries and retention (90 days) | https://learn.microsoft.com/azure/azure-monitor/platform/activity-log |

---

## Azure Consumption Budgets

| Topic | URL |
|---|---|
| Microsoft.Consumption/budgets ARM template reference (2023-11-01) | https://learn.microsoft.com/azure/templates/microsoft.consumption/2023-11-01/budgets |
| Microsoft.Consumption/budgets ARM template reference (2022-09-01) | https://learn.microsoft.com/azure/templates/microsoft.consumption/2022-09-01/budgets |
| Microsoft.Consumption/budgets ARM template reference (2021-10-01) | https://learn.microsoft.com/azure/templates/microsoft.consumption/2021-10-01/budgets |

---

## Azure Verified Modules (AVM)

| Topic | URL |
|---|---|
| AVM Terraform interface specifications — Resource Locks | https://learn.microsoft.com/github/AvmGithubIo/azure.github.io/Azure-Verified-Modules/specs/tf/interfaces/#resource-locks |

---

## Terraform Authentication

| Topic | URL |
|---|---|
| Authenticate to Azure with a service principal | https://learn.microsoft.com/azure/developer/terraform/authenticate-to-azure-with-service-principle |
| Specify service principal credentials in environment variables | https://learn.microsoft.com/azure/developer/terraform/authenticate/authenticate-to-azure-with-service-principle#specify-service-principal-credentials |

---

## Terraform Registry — Modules

| Module | Version | URL |
|---|---|---|
| Azure/avm-ptn-alz-sub-vending/azure (Azure Verified Pattern for Subscription Vending) | 0.1.1 | https://registry.terraform.io/modules/Azure/avm-ptn-alz-sub-vending/azure/0.1.1 |
| Source repository | — | https://github.com/Azure/terraform-azure-avm-ptn-alz-sub-vending |

---

## Terraform Registry — Provider: Azure/azapi ~> 2.5

| Resource / Data Source | URL |
|---|---|
| Provider overview | https://registry.terraform.io/providers/Azure/azapi/latest/docs |
| `azapi_resource` (create/manage ARM resources) | https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource |
| `azapi_resource_action` (invoke ARM actions/PUT without full lifecycle) | https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource_action |
| `azapi_update_resource` (PATCH existing resources) | https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/update_resource |
| `response_export_values` (extract values from API response) | https://registry.terraform.io/providers/Azure/azapi/latest/docs/resources/resource#response_export_values |
| AVM pattern module (azapi-based subscription vending) | https://github.com/Azure/terraform-azure-avm-ptn-alz-sub-vending |

---

## Terraform Registry — Provider: hashicorp/azurerm 4.69.0

| Resource / Data Source | URL |
|---|---|
| Provider overview & arguments (`subscription_id`, `resource_provider_registrations`) | https://registry.terraform.io/providers/hashicorp/azurerm/4.69.0/docs |
| `azurerm_subscription` | https://registry.terraform.io/providers/hashicorp/azurerm/4.69.0/docs/resources/subscription |
| `azurerm_management_group_subscription_association` | https://registry.terraform.io/providers/hashicorp/azurerm/4.69.0/docs/resources/management_group_subscription_association |
| `azurerm_consumption_budget_subscription` | https://registry.terraform.io/providers/hashicorp/azurerm/4.69.0/docs/resources/consumption_budget_subscription |
| `azurerm_monitor_action_group` | https://registry.terraform.io/providers/hashicorp/azurerm/4.69.0/docs/resources/monitor_action_group |
| `azurerm_management_lock` | https://registry.terraform.io/providers/hashicorp/azurerm/4.69.0/docs/resources/management_lock |
| `azurerm_role_assignment` | https://registry.terraform.io/providers/hashicorp/azurerm/4.69.0/docs/resources/role_assignment |
| `azurerm_resource_group` | https://registry.terraform.io/providers/hashicorp/azurerm/4.69.0/docs/resources/resource_group |

---

## Terraform Registry — Provider: hashicorp/azuread ~> 3.0

| Resource / Data Source | URL |
|---|---|
| Provider overview | https://registry.terraform.io/providers/hashicorp/azuread/latest/docs |
| `data.azuread_user` | https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user |

---

## Terraform Registry — Provider: hashicorp/time ~> 0.12

| Resource | URL |
|---|---|
| `time_static` (used to fix expiry date at first apply) | https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/static |

---

## Azure REST APIs

| Topic | URL |
|---|---|
| Subscription — Cancel (`POST /subscriptions/{id}/providers/Microsoft.Subscription/cancel`) | https://learn.microsoft.com/en-us/rest/api/subscription/2021-10-01/subscription/cancel |
| Subscription Alias — Create | https://learn.microsoft.com/en-us/rest/api/subscription/2021-10-01/alias/create |
| Activity Logs — List | https://learn.microsoft.com/en-us/rest/api/monitor/activity-logs |
| Tags — Update | https://learn.microsoft.com/en-us/rest/api/resources/tags/update |

---

## GitLab Documentation

| Topic | URL |
|---|---|
| GitLab-managed Terraform state (HTTP backend) | https://docs.gitlab.com/ee/user/infrastructure/iac/terraform_state.html |
| GitLab CI/CD scheduled pipelines | https://docs.gitlab.com/ee/ci/pipelines/schedules.html |
| GitLab CI/CD pipeline variables | https://docs.gitlab.com/ee/ci/variables/ |
