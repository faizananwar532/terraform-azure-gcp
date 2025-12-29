# Multi-Cloud Terraform Infrastructure

Terraform configurations for managing Azure and GCP infrastructure with remote state management.

## 📂 Repository Structure

```
terraform-azure-gcp/
├── terraform-azure/              # Azure hub-spoke network topology
│   ├── DEPLOYMENT_STEPS.md      # Detailed Azure deployment guide
│   ├── terraform.tfvars         # Azure configuration
│   └── *.tf                     # Terraform configuration files
│
└── terraform-gcp/                # GCP hierarchical data platform
    ├── DEPLOYMENT_STEPS.md      # Detailed GCP deployment guide
    ├── gcp.tfvars               # GCP configuration
    ├── modules/                 # Reusable modules (bigquery, gcs, vpc)
    ├── projects/                # Project-specific configs
    └── *.tf                     # Terraform configuration files
```

## 🚀 Quick Start
### Prerequisites
make sure `terraform-gcp-datawarehouse-369d72c63b0e.json` exist in the root folder, `gcp.tfvars` in `terraform-gcp/`, and `azure.tfvars` in `terraform-azure/` 

### Azure Deployment

Deploys hub-spoke network topology across 5 subscriptions (dev, test, prod, analytics, core).

```bash
cd terraform-azure
terraform init
terraform plan -var-file=terraform.tfvars
terraform apply -var-file=terraform.tfvars
```

📖 **Detailed Guide**: [terraform-azure/DEPLOYMENT_STEPS.md](terraform-azure/DEPLOYMENT_STEPS.md)

### GCP Deployment

Deploys hierarchical folder structure with data platform (BigQuery, GCS, VPC).

```bash
cd terraform-gcp
terraform init
terraform plan -var-file=gcp.tfvars
terraform apply -var-file=gcp.tfvars
```

📖 **Detailed Guide**: [terraform-gcp/DEPLOYMENT_STEPS.md](terraform-gcp/DEPLOYMENT_STEPS.md)

## 🔧 Prerequisites

| Tool | Purpose |
|------|---------|
| Terraform >= 1.0 | Infrastructure provisioning |
| Azure CLI (`az`) | Azure authentication |
| Google Cloud SDK (`gcloud`) | GCP authentication |
| Service Account Key | GCP API access |
| GCS Bucket | Remote state storage |

## 📋 Infrastructure Overview

### Azure
- **Architecture**: Hub-spoke network topology
- **Subscriptions**: 5 (dev, test, prod, analytics, core)
- **Resources**: VNets, VNet peerings, resource groups, NSGs
- **State**: `gs://tf-dev-gcp-terraform-state/terraform-azure/state`

### GCP
- **Organization**: gradis.co.uk (960813111154)
- **Root Folder**: tf-dev (1056367965450)
- **Projects**: Data Core, Networking, Security, Monitoring, Analytics
- **Resources**: Folders, projects, BigQuery datasets, GCS buckets, VPCs
- **State**: `gs://tf-dev-gcp-terraform-state/terraform-gcp/state`

## 🛠️ Common Commands

```bash
# Initialize and validate
terraform init
terraform validate
terraform fmt

# Plan and apply
terraform plan -var-file=<vars-file>
terraform apply -var-file=<vars-file>

# State management
terraform state list
terraform state show <resource>
terraform output

# Cleanup
terraform destroy -var-file=<vars-file>
```

## 📚 Documentation

- **Azure**: See [terraform-azure/DEPLOYMENT_STEPS.md](terraform-azure/DEPLOYMENT_STEPS.md) for complete deployment instructions, architecture details, and troubleshooting
- **GCP**: See [terraform-gcp/DEPLOYMENT_STEPS.md](terraform-gcp/DEPLOYMENT_STEPS.md) for folder structure, project hierarchy, and deployment steps

---

🎉 **You're all set!** Everything you need is in this one file.
