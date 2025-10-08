# Define the unique part based on random_pet
resource "random_pet" "unique_name" {
  prefix = var.project_prefix
  length = 2
}

# 1. Azure Resource Group (RG)
resource "azurerm_resource_group" "rg" {
  name     = "${random_pet.unique_name.id}-rg"
  location = var.location
}

# 2. Azure Container Registry (ACR)
resource "azurerm_container_registry" "acr" {
  # FIX: Use the 'replace' function to remove hyphens/dashes from the random ID 
  # to satisfy ACR's alphanumeric-only naming convention.
  name                = "${replace(random_pet.unique_name.id, "-", "")}acr"
  
  # The required arguments that were missing:
  resource_group_name = azurerm_resource_group.rg.name  # Takes name from the RG resource
  location            = azurerm_resource_group.rg.location # Takes location from the RG resource
  sku                 = "Basic"
  admin_enabled       = true 
}

# 3. Minimal Azure Kubernetes Service (AKS) Cluster
resource "azurerm_kubernetes_cluster" "aks" {
  # This resource will likely still fail due to the policy restriction, 
  # but the Terraform code definition is complete.
  name                = "${random_pet.unique_name.id}-aks"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  dns_prefix          = "${random_pet.unique_name.id}-dns"
  kubernetes_version  = var.aks_version

  default_node_pool {
    name            = "systempool"
    node_count      = 1
    vm_size         = "Standard_DS2_v2" 
    os_disk_size_gb = 30
  }

  identity {
    type = "SystemAssigned"
  }
}