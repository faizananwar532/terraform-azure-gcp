output "network_name" {
  description = "The name of the VPC network"
  value       = google_compute_network.vpc.name
}

output "network_id" {
  description = "The ID of the VPC network"
  value       = google_compute_network.vpc.id
}

output "network_self_link" {
  description = "The self link of the VPC network"
  value       = google_compute_network.vpc.self_link
}

output "subnets" {
  description = "Map of created subnets"
  value = {
    for k, v in google_compute_subnetwork.subnets : k => {
      name       = v.name
      id         = v.id
      self_link  = v.self_link
      ip_range   = v.ip_cidr_range
      region     = v.region
    }
  }
}

output "firewall_rules" {
  description = "Map of created firewall rules"
  value = {
    for k, v in google_compute_firewall.rules : k => {
      name      = v.name
      id        = v.id
      self_link = v.self_link
    }
  }
}
