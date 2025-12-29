/**
 * VPC Network Module
 * Creates VPC network with subnets and firewall rules
 */

resource "google_compute_network" "vpc" {
  name                    = var.network_name
  project                 = var.project_id
  auto_create_subnetworks = false
  routing_mode            = var.routing_mode
  description             = var.description
}

resource "google_compute_subnetwork" "subnets" {
  for_each = var.subnets

  name                     = each.value.name
  project                  = var.project_id
  network                  = google_compute_network.vpc.id
  region                   = each.value.region
  ip_cidr_range            = each.value.ip_cidr_range
  private_ip_google_access = each.value.private_ip_google_access
  description              = lookup(each.value, "description", null)

  dynamic "secondary_ip_range" {
    for_each = lookup(each.value, "secondary_ip_ranges", [])
    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }

  dynamic "log_config" {
    for_each = lookup(each.value, "enable_flow_logs", false) ? [1] : []
    content {
      aggregation_interval = "INTERVAL_5_SEC"
      flow_sampling        = 0.5
      metadata             = "INCLUDE_ALL_METADATA"
    }
  }
}

resource "google_compute_firewall" "rules" {
  for_each = var.firewall_rules

  name        = each.value.name
  project     = var.project_id
  network     = google_compute_network.vpc.name
  description = lookup(each.value, "description", null)
  direction   = each.value.direction
  priority    = lookup(each.value, "priority", 1000)

  source_ranges      = lookup(each.value, "source_ranges", null)
  destination_ranges = lookup(each.value, "destination_ranges", null)
  source_tags        = lookup(each.value, "source_tags", null)
  target_tags        = lookup(each.value, "target_tags", null)

  dynamic "allow" {
    for_each = lookup(each.value, "allow", [])
    content {
      protocol = allow.value.protocol
      ports    = lookup(allow.value, "ports", null)
    }
  }

  dynamic "deny" {
    for_each = lookup(each.value, "deny", [])
    content {
      protocol = deny.value.protocol
      ports    = lookup(deny.value, "ports", null)
    }
  }
}

# Cloud Router for NAT
resource "google_compute_router" "router" {
  count   = var.create_nat ? 1 : 0
  name    = "${var.network_name}-router"
  project = var.project_id
  region  = var.nat_region
  network = google_compute_network.vpc.id
}

# Cloud NAT
resource "google_compute_router_nat" "nat" {
  count   = var.create_nat ? 1 : 0
  name    = "${var.network_name}-nat"
  project = var.project_id
  router  = google_compute_router.router[0].name
  region  = google_compute_router.router[0].region

  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"

  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}
