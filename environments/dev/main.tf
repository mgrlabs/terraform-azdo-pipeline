terraform {
  backend "azurerm" {}
  required_version = ">= 1.1.0" # Pinned to a terraform version
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.93.1" # Pinned to a provider version
    }
  }
}

# Provider

provider "azurerm" {
  features {}
  subscription_id = "623aabe5-748d-4b15-be89-3119e247a9fd"
}

# locals {
#   tags = merge(var.tags, local.module_tags)
#   module_tags = {
#     "Module" = basename(abspath(path.module))
#   }
# }

data "azurerm_client_config" "current" {}

resource "random_password" "module" {
  length           = 16
  special          = true
  override_special = "_%@"
}
