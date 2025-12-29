# Deployment Steps

## Prerequisites
1. Install Azure CLI:
   ```bash
   # macOS
   brew install azure-cli
   ```

2. Install Terraform:
   ```bash
   # macOS
   brew install terraform
   ```

3. Login to Azure:
   ```bash
   az login
   ```

## Get Azure Details
```bash
# Get Tenant ID
az account show --query tenantId -o tsv

# List Subscriptions
az account list --output table
```

## Configure

1. **Edit `azure.tfvars`**:
   - Update all 5 `subscription_ids`
   - Update `tenant_id`
   - Update any other value if you want related to networking.

2. **Verify `backend.tf`** (already configured):
   - GCS bucket: `tf-dev-gcp-terraform-state`
   - State prefix: `terraform-azure/state`
   - Credentials: `../terraform-gcp-datawarehouse-369d72c63b0e.json`

## Deploy

```bash
# Initialize
terraform init

# Validate
terraform validate

# Preview
terraform plan -var-file=azure.tfvars

# Deploy
terraform apply -var-file=azure.tfvars
```

⏱️ Takes ~15-20 minutes

## Verify

```bash
# Check outputs
terraform output

# Check Azure Portal
# Verify VNet peerings: Status = "Connected"
```

## Destroy

```bash
# Remove all resources
terraform destroy -var-file=azure.tfvars
```

⚠️ **Note**: If destroy fails with Databricks Network Intent Policy errors:
- Wait 5-10 minutes
- Run `terraform destroy -var-file=azure.tfvars` again

⏱️ Takes ~10-15 minutes

## Troubleshooting

**Insufficient permissions**: Need Owner/Contributor on all 5 subscriptions

**Storage name conflict**: Change `company_name` in `azure.tfvars`

**VNet peering fails**: Ensure all subscriptions are in same Azure AD tenant
