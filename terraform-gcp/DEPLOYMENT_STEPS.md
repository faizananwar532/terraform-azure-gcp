# Deployment Steps

## Prerequisites
```bash
brew install google-cloud-sdk terraform
gcloud auth application-default login
```

## Configure

1. **Edit `gcp.tfvars`**:
   - Update `organization_id`
   - Update `billing_account`
   - Update `tf_dev_folder_id`
   - Set `project_prefix` (e.g., `tf-dev`)
   - Adjust project/module settings as needed

2. **Verify `backend.tf`** (already configured):
   - GCS bucket: `tf-dev-gcp-terraform-state`
   - State prefix: `terraform-gcp/state`
   - Credentials: `../terraform-gcp-datawarehouse-369d72c63b0e.json`

## Deploy

```bash
# Initialize
terraform init

# Validate
terraform validate

# Preview
terraform plan -var-file=gcp.tfvars

# Deploy
terraform apply -var-file=gcp.tfvars
```

⏱️ Takes ~10-15 minutes

## Verify

```bash
# Check outputs
terraform output

# List projects
gcloud projects list --filter="parent.id=YOUR_FOLDER_ID"
```

## Destroy

```bash
# Remove all resources
terraform destroy -var-file=gcp.tfvars
```

⏱️ Takes ~5-10 minutes

**Note**: After destroying projects, folders will show "Resources pending deletion" and remain for **30 days** until projects are permanently purged by Google. To immediately remove folders:
- **Option 1**: Wait 30 days for automatic cleanup
- **Option 2**: Manually delete via GCP Console (IAM & Admin > Manage Resources > ⋮ > Delete folder)

## Troubleshooting

**Insufficient permissions**: Need Organization Admin or Folder Admin roles

**Project ID conflict**: Project IDs must be globally unique across all GCP

**Billing account issues**: Ensure billing account has credit and is linked to organization

**Folders not deleting**: GCP keeps folders for 30 days after project deletion - this is normal behavior

---

## Infrastructure Architecture

### Folder & Project Structure

Terraform automatically creates the following hierarchy:

```
gradis.co.uk (Organization: 960813111154)
└── tf-dev (Folder: 1056367965450) [PRE-EXISTING - Must exist]
    │
    ├── Data Core (Folder) [AUTO-CREATED BY TERRAFORM]
    │   ├── Archive (Folder) [AUTO-CREATED BY TERRAFORM]
    │   │   └── tf-dev-data-core-archive (Project) [AUTO-CREATED BY TERRAFORM]
    │   ├── Development (Folder) [AUTO-CREATED BY TERRAFORM]
    │   │   └── tf-dev-data-core-dev (Project) [AUTO-CREATED BY TERRAFORM]
    │   └── Production (Folder) [AUTO-CREATED BY TERRAFORM]
    │       └── tf-dev-data-core-prod (Project) [AUTO-CREATED BY TERRAFORM]
    │
    ├── Security (Folder) [AUTO-CREATED BY TERRAFORM]
    │   └── tf-dev-security-acm (Project) [AUTO-CREATED BY TERRAFORM]
    │
    ├── Networking (Folder) [AUTO-CREATED BY TERRAFORM]
    │   ├── tf-dev-network-development (Project) [AUTO-CREATED BY TERRAFORM]
    │   └── tf-dev-network-production (Project) [AUTO-CREATED BY TERRAFORM]
    │
    ├── Monitoring (Folder) [AUTO-CREATED BY TERRAFORM]
    │   └── tf-dev-central-monitoring (Project) [AUTO-CREATED BY TERRAFORM]
    │
    └── Data Analytics (Folder) [AUTO-CREATED BY TERRAFORM]
        └── Looker (Folder) [AUTO-CREATED BY TERRAFORM]
            ├── tf-dev-looker-development (Project) [AUTO-CREATED BY TERRAFORM]
            └── tf-dev-looker-production (Project) [AUTO-CREATED BY TERRAFORM]
```

**Legend:**
- **AUTO-CREATED BY TERRAFORM**: Automatically created when you run `terraform apply`
- **PRE-EXISTING**: Must exist before running Terraform

### What Terraform Creates

✅ **All Folders**:
- Data Core (with subfolders: Archive, Development, Production)
- Security
- Networking
- Monitoring
- Data Analytics (with subfolder: Looker)

✅ **All Projects**:
- Archive, Development, Production (Data Core)
- Networking Development & Production
- Security ACM
- Central Monitoring
- Looker Development & Production

✅ **All Resources**:
- BigQuery datasets (Bronze, Silver, Gold)
- GCS buckets with hierarchical namespace
- VPC networks and subnets
- IAM permissions
- API enablement

### What You Need to Provide

⚠️ **Pre-existing Requirements**:
1. GCP Organization (e.g., gradis.co.uk)
2. tf-dev parent folder (ID: 1056367965450)
3. Billing account (linked and accessible)
4. Service account with proper permissions

**Configuration in `gcp.tfvars`**:
1. Organization ID
2. tf-dev folder ID
3. Billing account ID
4. Desired project IDs
5. User/group emails for IAM access
6. Region preferences

**That's it!** Just run `terraform apply` and everything is created automatically.
