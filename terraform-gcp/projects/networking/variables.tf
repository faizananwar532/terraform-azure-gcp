variable "tf_dev_folder_id" {
  description = "The tf-dev parent folder ID"
  type        = string
}

variable "billing_account" {
  description = "The billing account ID"
  type        = string
}

variable "networking_dev_project_id" {
  description = "The GCP project ID for the Networking Development project"
  type        = string
}

variable "networking_prod_project_id" {
  description = "The GCP project ID for the Networking Production project"
  type        = string
}

variable "region" {
  description = "The GCP region for networking resources"
  type        = string
  default     = "europe-west2"
}

variable "dev_subnet_cidr" {
  description = "CIDR range for development subnet"
  type        = string
  default     = "10.20.0.0/24"
}

variable "prod_subnet_cidr" {
  description = "CIDR range for production subnet"
  type        = string
  default     = "10.21.0.0/24"
}

variable "create_dev_nat" {
  description = "Whether to create Cloud NAT for development VPC"
  type        = bool
  default     = true
}

variable "create_prod_nat" {
  description = "Whether to create Cloud NAT for production VPC"
  type        = bool
  default     = true
}

variable "common_labels" {
  description = "Common labels to apply to all resources"
  type        = map(string)
  default = {
    managed_by = "terraform"
    team       = "networking"
  }
}
