# Archive Dataset Outputs
output "archive_dataset_id" {
  description = "The ID of the archive BigQuery dataset"
  value       = module.archive_dataset.dataset_id
}

output "archive_dataset_name" {
  description = "The fully-qualified name of the archive dataset"
  value       = module.archive_dataset.dataset_name
}

# Development Outputs
output "development_bronze_dataset_id" {
  description = "The ID of the development bronze BigQuery dataset"
  value       = module.development_bronze_dataset.dataset_id
}

output "development_silver_dataset_id" {
  description = "The ID of the development silver BigQuery dataset"
  value       = module.development_silver_dataset.dataset_id
}

output "development_gold_dataset_id" {
  description = "The ID of the development gold BigQuery dataset"
  value       = module.development_gold_dataset.dataset_id
}

output "development_bucket_name" {
  description = "The name of the development GCS bucket"
  value       = module.development_gcs_bucket.bucket_name
}

output "development_tables" {
  description = "Map of created development tables"
  value       = module.development_gold_dataset.tables
}

# Production Outputs
output "production_bronze_dataset_id" {
  description = "The ID of the production bronze BigQuery dataset"
  value       = module.production_bronze_dataset.dataset_id
}

output "production_silver_dataset_id" {
  description = "The ID of the production silver BigQuery dataset"
  value       = module.production_silver_dataset.dataset_id
}

output "production_gold_dataset_id" {
  description = "The ID of the production gold BigQuery dataset"
  value       = module.production_gold_dataset.dataset_id
}

output "production_bucket_name" {
  description = "The name of the production GCS bucket"
  value       = module.production_gcs_bucket.bucket_name
}

output "production_tables" {
  description = "Map of created production tables"
  value       = module.production_gold_dataset.tables
}
