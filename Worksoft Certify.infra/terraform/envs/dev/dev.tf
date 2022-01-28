#Set the terraform required version
# It is recommended to pin to a given version of the Provider
#
# from TF 0.13 onwards provider versions can't be pinned in providers.
# Configure the Azure Provider
provider "azurerm" {
  features {}
}
# AzureRM backend configuration
terraform {
  backend "azurerm" {
  }
}
# Invoke Main module
module "main" {
  source            = "../../config"
  environment       = "dev"
}
