# Pinned to minor version release

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.45"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  required_version = "~> 0.14"
}

# Azure Provider setup
provider "azurerm" {
  features {}
  skip_provider_registration = true
}