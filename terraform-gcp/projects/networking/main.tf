# Networking Project Configuration
#
# This configuration manages VPC networks for Development and Production environments
# Projects should be created manually and their IDs provided via variables

# ============================================
# DEVELOPMENT VPC
# ============================================

module "development_vpc" {
  source = "../../modules/vpc"

  project_id   = var.networking_dev_project_id
  
  depends_on = [google_project_service.networking_dev_apis]
  network_name = "vpc-dev"
  description  = "Development VPC Network"
  routing_mode = "REGIONAL"
  
  subnets = {
    dev_subnet = {
      name                     = "subnet-dev-${var.region}"
      region                   = var.region
      ip_cidr_range            = var.dev_subnet_cidr
      private_ip_google_access = true
      description              = "Development subnet"
      enable_flow_logs         = true
    }
  }
  
  firewall_rules = {
    allow_internal_dev = {
      name          = "allow-internal-dev"
      description   = "Allow internal communication"
      direction     = "INGRESS"
      priority      = 1000
      source_ranges = [var.dev_subnet_cidr]
      allow = [
        {
          protocol = "tcp"
          ports    = null
        },
        {
          protocol = "udp"
          ports    = null
        },
        {
          protocol = "icmp"
          ports    = null
        }
      ]
    }
    allow_egress_dns_dev = {
      name               = "allow-egress-dns-dev"
      description        = "Allow DNS queries"
      direction          = "EGRESS"
      priority           = 1000
      destination_ranges = ["0.0.0.0/0"]
      allow = [{
        protocol = "tcp"
        ports    = ["53"]
      },
      {
        protocol = "udp"
        ports    = ["53"]
      }]
    }
    allow_egress_http_https_dev = {
      name               = "allow-egress-http-https-dev"
      description        = "Allow HTTP and HTTPS egress"
      direction          = "EGRESS"
      priority           = 1000
      destination_ranges = ["0.0.0.0/0"]
      allow = [{
        protocol = "tcp"
        ports    = ["80", "443"]
      }]
    }
    deny_all_ingress_dev = {
      name          = "deny-all-ingress-dev"
      description   = "Deny all other ingress traffic"
      direction     = "INGRESS"
      priority      = 65534
      source_ranges = ["0.0.0.0/0"]
      deny = [{
        protocol = "all"
        ports    = null
      }]
    }
  }
  
  create_nat = var.create_dev_nat
  nat_region = var.region
}

# ============================================
# PRODUCTION VPC
# ============================================

module "production_vpc" {
  source = "../../modules/vpc"

  project_id   = var.networking_prod_project_id
  
  depends_on = [google_project_service.networking_prod_apis]
  network_name = "vpc-prod"
  description  = "Production VPC Network"
  routing_mode = "REGIONAL"
  
  subnets = {
    prod_subnet = {
      name                     = "subnet-prod-${var.region}"
      region                   = var.region
      ip_cidr_range            = var.prod_subnet_cidr
      private_ip_google_access = true
      description              = "Production subnet"
      enable_flow_logs         = true
    }
  }
  
  firewall_rules = {
    allow_internal_prod = {
      name          = "allow-internal-prod"
      description   = "Allow internal communication"
      direction     = "INGRESS"
      priority      = 1000
      source_ranges = [var.prod_subnet_cidr]
      allow = [
        {
          protocol = "tcp"
          ports    = null
        },
        {
          protocol = "udp"
          ports    = null
        },
        {
          protocol = "icmp"
          ports    = null
        }
      ]
    }
    allow_egress_dns_prod = {
      name               = "allow-egress-dns-prod"
      description        = "Allow DNS queries"
      direction          = "EGRESS"
      priority           = 1000
      destination_ranges = ["0.0.0.0/0"]
      allow = [{
        protocol = "tcp"
        ports    = ["53"]
      },
      {
        protocol = "udp"
        ports    = ["53"]
      }]
    }
    allow_egress_http_https_prod = {
      name               = "allow-egress-http-https-prod"
      description        = "Allow HTTP and HTTPS egress"
      direction          = "EGRESS"
      priority           = 1000
      destination_ranges = ["0.0.0.0/0"]
      allow = [{
        protocol = "tcp"
        ports    = ["80", "443"]
      }]
    }
    deny_all_ingress_prod = {
      name          = "deny-all-ingress-prod"
      description   = "Deny all other ingress traffic"
      direction     = "INGRESS"
      priority      = 65534
      source_ranges = ["0.0.0.0/0"]
      deny = [{
        protocol = "all"
        ports    = null
      }]
    }
  }
  
  create_nat = var.create_prod_nat
  nat_region = var.region
}
