# GitLab-managed Terraform HTTP backend.
# Each subscription uses its own state file, keyed by TF_STATE_NAME.
# TF_STATE_NAME is set in the CI/CD pipeline to the slugified subscription name
# (e.g., sandbox-jdoe-api-testing).
#
# The backend block cannot use interpolated values, so the address is
# completed via -backend-config flags in the pipeline's terraform init call.
terraform {
  backend "http" {}
}
