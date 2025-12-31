variable "tf_dev_folder_id" {
  description = "The tf-dev parent folder ID"
  type        = string
}

variable "billing_account" {
  description = "The billing account ID"
  type        = string
}

variable "security_project_id" {
  description = "The GCP project ID for the Security ACM project"
  type        = string
}

variable "common_labels" {
  description = "Common labels to apply to all resources"
  type        = map(string)
  default = {
    managed_by = "terraform"
    team       = "security"
  }
}
