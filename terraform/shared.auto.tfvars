# ---------------------------------------------------------------------------
# Shared constants — apply to all sandbox subscriptions.
# Managed by the ops team. Changes here affect all subscriptions on next apply.
# ---------------------------------------------------------------------------

# EA enrollment account billing scope.
# Find with: az billing account list && az billing account show --name <id> --expand enrollmentAccounts
#billing_scope = "/providers/Microsoft.Billing/billingAccounts/REPLACE_BILLING_ACCOUNT_ID/enrollmentAccounts/REPLACE_ENROLLMENT_ACCOUNT_ID"
billing_scope = "/providers/Microsoft.Billing/billingAccounts/bbe9356e-72a1-55fc-9ca5-55105c79c6e4:4cec7e51-c3bc-4f19-8a4a-f272b561bb43_2019-05-31/billingProfiles/ZKDD-4IW5-BG7-PGB/invoiceSections/Y6G6-QJT6-PJA-PGB"

# Management Group where all sandbox subscriptions are placed.
management_group_id = "lz"

# Ops team distribution list — receives copies of all budget alerts and lifecycle notifications.
ops_email = "foudil.bendjabeur@outlook.com"
