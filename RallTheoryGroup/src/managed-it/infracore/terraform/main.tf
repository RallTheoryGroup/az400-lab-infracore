terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

resource "azurerm_resource_group" "infracore" {
  name     = "rg-infracore-${var.environment}"
  location = var.location

  tags = {
    environment = var.environment
    managed_by  = "infracore"
  }
}

resource "azurerm_storage_account" "infracore" {
  name                     = "stinfracore${var.environment}"
  resource_group_name      = azurerm_resource_group.infracore.name
  location                 = azurerm_resource_group.infracore.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  allow_nested_items_to_be_public = false
  enable_https_traffic_only       = true
  public_network_access_enabled  = false

  network_rules {
    default_action = "Deny"
    bypass         = ["AzureServices"]
  }

  tags = {
    environment = var.environment
    managed_by  = "infracore"
  }
}

output "storage_account_id" {
  value = azurerm_storage_account.infracore.id
}
