# Azure Provider setup
provider "azurerm" {
  features {}
  skip_provider_registration = true
  subscription_id            = var.subscription_id
}

terraform {
  backend "azurerm" {
  }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.59"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1"
    }
  }
  required_version = "~> 0.15"
}