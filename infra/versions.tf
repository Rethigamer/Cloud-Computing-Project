terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      # Lock to a stable major version (~> 3.0 or ~> 4.0 are common)
      version = "~> 3.0" 
    }
    random = {
      source = "hashicorp/random"
      version = "~> 3.0"
    }
  }

  # Ensure Terraform CLI version compatibility
  required_version = ">= 1.0.0"
}

provider "azurerm" {
  features {}
}