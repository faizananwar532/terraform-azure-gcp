# Development VPC Outputs
output "dev_network_name" {
  description = "The name of the development VPC network"
  value       = module.development_vpc.network_name
}

output "dev_network_id" {
  description = "The ID of the development VPC network"
  value       = module.development_vpc.network_id
}

output "dev_subnets" {
  description = "Development subnets"
  value       = module.development_vpc.subnets
}

# Production VPC Outputs
output "prod_network_name" {
  description = "The name of the production VPC network"
  value       = module.production_vpc.network_name
}

output "prod_network_id" {
  description = "The ID of the production VPC network"
  value       = module.production_vpc.network_id
}

output "prod_subnets" {
  description = "Production subnets"
  value       = module.production_vpc.subnets
}
