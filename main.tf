terraform {
  required_providers {
    azurerm = {
        source  = "hashicorp/azurerm"
        version = "~> 4.3.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "azurerm" {
  features {}
  subscription_id = "4308162f-4b8c-41ce-9432-43e7ee01a694"
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

module "storage_account" {
  source = "./modules/storage_account/storage_account"
  resource_group_name = var.resource_group_name
  storage_account_name = var.storage_account_name
  location = var.location
  source_folder_name = var.source_folder_name
  destination_folder_name = var.destination_folder_name

  depends_on = [ azurerm_resource_group.rg ]
}

module "data_factory" {
  source = "./modules/data_factory/data_factory"
  df_name =  var.df_name
  location = var.location
  resource_group_name = var.resource_group_name
  storage_account_name = var.storage_account_name

  depends_on = [ module.storage_account ]
}