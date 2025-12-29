output "workspace_id" {
  description = "Databricks Workspace ID"
  value       = azurerm_databricks_workspace.main.id
}

output "workspace_url" {
  description = "Databricks Workspace URL"
  value       = azurerm_databricks_workspace.main.workspace_url
}

output "workspace_name" {
  description = "Databricks Workspace name"
  value       = azurerm_databricks_workspace.main.name
}
