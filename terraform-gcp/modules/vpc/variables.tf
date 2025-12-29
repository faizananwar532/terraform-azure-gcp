variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "network_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "description" {
  description = "Description of the VPC network"
  type        = string
  default     = null
}

variable "routing_mode" {
  description = "The network routing mode (GLOBAL or REGIONAL)"
  type        = string
  default     = "REGIONAL"
}

variable "subnets" {
  description = "Map of subnets to create"
  type = map(object({
    name                     = string
    region                   = string
    ip_cidr_range            = string
    private_ip_google_access = bool
    description              = optional(string)
    enable_flow_logs         = optional(bool, false)
    secondary_ip_ranges = optional(list(object({
      range_name    = string
      ip_cidr_range = string
    })), [])
  }))
  default = {}
}

variable "firewall_rules" {
  description = "Map of firewall rules to create"
  type = map(object({
    name               = string
    description        = optional(string)
    direction          = string
    priority           = optional(number, 1000)
    source_ranges      = optional(list(string))
    destination_ranges = optional(list(string))
    source_tags        = optional(list(string))
    target_tags        = optional(list(string))
    allow = optional(list(object({
      protocol = string
      ports    = optional(list(string))
    })), [])
    deny = optional(list(object({
      protocol = string
      ports    = optional(list(string))
    })), [])
  }))
  default = {}
}

variable "create_nat" {
  description = "Whether to create Cloud NAT for the VPC"
  type        = bool
  default     = false
}

variable "nat_region" {
  description = "Region for Cloud NAT and Router"
  type        = string
  default     = null
}
