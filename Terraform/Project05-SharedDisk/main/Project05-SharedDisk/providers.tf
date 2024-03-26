terraform {
  backend "azurerm" {
  }
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">=2.47.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=3.97.0"
    }
    azuredevops = {
      source  = "microsoft/azuredevops"
      version = ">=1.0.1"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=3.6.0"
    }
  }
}

provider "azuread" {
  # Configuration options
}

provider "azurerm" {
  # Configuration options
  features {}
  skip_provider_registration = true
}

provider "azuredevops" {
  # Configuration options
}

provider "random" {
  # Configuration options
}


