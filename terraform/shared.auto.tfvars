# ---------------------------------------------------------------------------
# Shared constants — apply to all sandbox subscriptions.
# Managed by the ops team. Changes here affect all subscriptions on next apply.
# ---------------------------------------------------------------------------

# EA enrollment account billing scope.
# Find with: az billing account list && az billing account show --name <id> --expand enrollmentAccounts
billing_scope = "/providers/Microsoft.Billing/billingAccounts/REPLACE_BILLING_ACCOUNT_ID/enrollmentAccounts/REPLACE_ENROLLMENT_ACCOUNT_ID"

# Management Group where all sandbox subscriptions are placed.
management_group_id = "/providers/Microsoft.Management/managementGroups/REPLACE_MG_ID"

# Ops team distribution list — receives copies of all budget alerts and lifecycle notifications.
ops_email = "platform-ops@company.com"
