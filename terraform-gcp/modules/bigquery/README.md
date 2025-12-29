# BigQuery Terraform Module

This module creates and manages Google Cloud BigQuery datasets and tables with configurable access controls, encryption, and lifecycle policies.

## Features

- Create BigQuery datasets with custom configurations
- Support for dataset-level IAM bindings
- Optional KMS encryption
- Configurable table expiration
- Support for partitioned and clustered tables
- Automatic labeling with management metadata

## Usage

### Basic Dataset Creation

```hcl
module "bigquery_dataset" {
  source = "./modules/bigquery"

  project_id  = "my-project-id"
  dataset_id  = "my_dataset"
  location    = "UK"
  description = "My BigQuery dataset"
  
  labels = {
    environment = "production"
    team        = "data"
  }
}
```

### Dataset with Access Controls

```hcl
module "bigquery_dataset_with_access" {
  source = "./modules/bigquery"

  project_id  = "my-project-id"
  dataset_id  = "secure_dataset"
  location    = "UK"
  description = "Dataset with custom access controls"
  
  access_roles = [
    {
      role           = "OWNER"
      user_by_email  = "admin@example.com"
    },
    {
      role           = "READER"
      group_by_email = "data-analysts@example.com"
    }
  ]
  
  dataset_iam_members = {
    viewer1 = {
      role   = "roles/bigquery.dataViewer"
      member = "user:viewer@example.com"
    }
  }
}
```

### Dataset with Tables

```hcl
module "bigquery_dataset_with_tables" {
  source = "./modules/bigquery"

  project_id  = "my-project-id"
  dataset_id  = "analytics_dataset"
  location    = "UK"
  description = "Analytics dataset with partitioned tables"
  
  tables = {
    events = {
      description = "User events table"
      schema      = file("${path.module}/schemas/events.json")
      time_partitioning = {
        type                     = "DAY"
        field                    = "event_timestamp"
        require_partition_filter = true
      }
      clustering = {
        fields = ["user_id", "event_type"]
      }
      labels = {
        data_type = "events"
      }
    }
    
    users = {
      description = "Users dimension table"
      schema      = file("${path.module}/schemas/users.json")
    }
  }
}
```

### Dataset with Encryption

```hcl
module "encrypted_dataset" {
  source = "./modules/bigquery"

  project_id   = "my-project-id"
  dataset_id   = "encrypted_dataset"
  location     = "UK"
  kms_key_name = "projects/my-project/locations/us/keyRings/my-keyring/cryptoKeys/my-key"
  
  labels = {
    encrypted = "true"
  }
}
```

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project_id | The GCP project ID where the BigQuery dataset will be created | `string` | n/a | yes |
| dataset_id | A unique ID for the BigQuery dataset | `string` | n/a | yes |
| friendly_name | A descriptive name for the dataset | `string` | `null` | no |
| description | A user-friendly description of the dataset | `string` | `null` | no |
| location | The geographic location where the dataset should reside | `string` | `"UK"` | no |
| default_table_expiration_ms | The default lifetime of all tables in the dataset, in milliseconds | `number` | `null` | no |
| delete_contents_on_destroy | If set to true, delete all the tables in the dataset when destroying | `bool` | `false` | no |
| labels | A mapping of labels to assign to the dataset | `map(string)` | `{}` | no |
| access_roles | List of access roles to grant on the dataset | `list(object)` | `[]` | no |
| dataset_iam_members | Map of IAM members to grant specific roles on the dataset | `map(object)` | `{}` | no |
| kms_key_name | The Cloud KMS key name used for encryption | `string` | `null` | no |
| tables | A map of tables to create in the dataset | `map(object)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| dataset_id | The ID of the BigQuery dataset |
| dataset_name | The fully-qualified name of the BigQuery dataset |
| dataset_self_link | The self link of the BigQuery dataset |
| dataset_location | The location of the BigQuery dataset |
| dataset_project | The project ID of the BigQuery dataset |
| dataset_etag | The ETag of the BigQuery dataset |
| dataset_creation_time | The time when the dataset was created, in milliseconds since epoch |
| dataset_last_modified_time | The time when the dataset was last modified, in milliseconds since epoch |
| tables | Map of created BigQuery tables |

## Table Schema Example

Create a JSON file for your table schema (e.g., `schemas/events.json`):

```json
[
  {
    "name": "event_id",
    "type": "STRING",
    "mode": "REQUIRED",
    "description": "Unique event identifier"
  },
  {
    "name": "event_timestamp",
    "type": "TIMESTAMP",
    "mode": "REQUIRED",
    "description": "When the event occurred"
  },
  {
    "name": "user_id",
    "type": "STRING",
    "mode": "REQUIRED",
    "description": "User identifier"
  },
  {
    "name": "event_type",
    "type": "STRING",
    "mode": "REQUIRED",
    "description": "Type of event"
  },
  {
    "name": "properties",
    "type": "JSON",
    "mode": "NULLABLE",
    "description": "Event properties"
  }
]
```

## Requirements

- Terraform >= 1.0
- Google Provider >= 5.0

## Permissions Required

The service account or user running Terraform needs the following permissions:

- `bigquery.datasets.create`
- `bigquery.datasets.get`
- `bigquery.datasets.update`
- `bigquery.datasets.delete`
- `bigquery.tables.create`
- `bigquery.tables.get`
- `bigquery.tables.update`
- `bigquery.tables.delete`

Typical roles:
- `roles/bigquery.admin` (for full management)
- `roles/bigquery.dataEditor` (for data operations)
