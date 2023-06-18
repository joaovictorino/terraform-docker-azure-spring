terraform {
  required_version = ">= 0.13"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
    azapi = {
      source = "azure/azapi"
      version = "= 1.6"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

provider "azapi" {
}

resource "azurerm_resource_group" "rg-aula-spring" {
  name     = "rg-aula-spring"
  location = "eastus"
}
