output "dataset_id" {
  description = "The ID of the BigQuery dataset"
  value       = google_bigquery_dataset.dataset.dataset_id
}

output "dataset_name" {
  description = "The fully-qualified name of the BigQuery dataset"
  value       = google_bigquery_dataset.dataset.id
}

output "dataset_self_link" {
  description = "The self link of the BigQuery dataset"
  value       = google_bigquery_dataset.dataset.self_link
}

output "dataset_location" {
  description = "The location of the BigQuery dataset"
  value       = google_bigquery_dataset.dataset.location
}

output "dataset_project" {
  description = "The project ID of the BigQuery dataset"
  value       = google_bigquery_dataset.dataset.project
}

output "dataset_etag" {
  description = "The ETag of the BigQuery dataset"
  value       = google_bigquery_dataset.dataset.etag
}

output "dataset_creation_time" {
  description = "The time when the dataset was created, in milliseconds since epoch"
  value       = google_bigquery_dataset.dataset.creation_time
}

output "dataset_last_modified_time" {
  description = "The time when the dataset was last modified, in milliseconds since epoch"
  value       = google_bigquery_dataset.dataset.last_modified_time
}

output "tables" {
  description = "Map of created BigQuery tables"
  value = {
    for k, v in google_bigquery_table.tables : k => {
      table_id   = v.table_id
      self_link  = v.self_link
      project    = v.project
      dataset_id = v.dataset_id
    }
  }
}
