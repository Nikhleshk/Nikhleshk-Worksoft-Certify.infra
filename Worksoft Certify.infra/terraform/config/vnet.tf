
# Define common VNET details for Private Endpoints
# Subscriptions for VNETS
# You only need to add a provider if vnets are in another subscription.
/*
provider "azurerm" {
  alias           = "pe_dev_vnet_sub"
  subscription_id = "886e6121-dbf6-463b-8df0-498aaf0aca7a"
  features {}
}
*/
# trying to figure this out =)

variable "vnet_map" {  
  type        = map(any)
  default = {
    dev  	= {}
    test 	= {}
    prod 	= {}
	  cs		= {}
  }
}

#
# DEV VNET
#
data "azurerm_virtual_network" "pe_dev_vnet01" {  
  name                = "${local.settings.variables.shortapplicationname}-${local.settings.variables.shortregion}-dev-vnet"
  resource_group_name = "${local.settings.variables.applicationname}-networks-${local.settings.variables.shortregion}-dev-rg"
}
# Dev Subnet
data "azurerm_subnet" "pe_dev_vnet01_subnet01" {    
  name                 = "${local.settings.variables.shortapplicationname}-${local.settings.variables.shortregion}-dev-subnet"
  virtual_network_name = data.azurerm_virtual_network.pe_dev_vnet01.name
  resource_group_name = data.azurerm_virtual_network.pe_dev_vnet01.resource_group_name
}

#
# TEST VNET
#
data "azurerm_virtual_network" "pe_test_vnet01" {  
  name                = "${local.settings.variables.shortapplicationname}-${local.settings.variables.shortregion}-test-vnet"
  resource_group_name = "${local.settings.variables.applicationname}-networks-${local.settings.variables.shortregion}-test-rg"
}
# Test Subnet
data "azurerm_subnet" "pe_test_vnet01_subnet01" {    
  name                 = "${local.settings.variables.shortapplicationname}-${local.settings.variables.shortregion}-test-subnet"
  virtual_network_name = data.azurerm_virtual_network.pe_test_vnet01.name
  resource_group_name = data.azurerm_virtual_network.pe_test_vnet01.resource_group_name
}

#
# PROD VNET
#
data "azurerm_virtual_network" "pe_prod_vnet01" {
  name                = "${local.settings.variables.shortapplicationname}-${local.settings.variables.shortregion}-prod-vnet"
  resource_group_name = "${local.settings.variables.applicationname}-networks-${local.settings.variables.shortregion}-prod-rg"
}

# Prod Subnet
data "azurerm_subnet" "pe_prod_vnet01_subnet01" {
  name                 = "${local.settings.variables.shortapplicationname}-${local.settings.variables.shortregion}-prod-subnet"
  virtual_network_name = data.azurerm_virtual_network.pe_prod_vnet01.name
  resource_group_name = data.azurerm_virtual_network.pe_prod_vnet01.resource_group_name
}


locals {
  vnet_map = merge(
	var.vnet_map,
    {
    dev = {
      vnet = "${data.azurerm_virtual_network.pe_dev_vnet01.id}"
      default_subnet = "${data.azurerm_subnet.pe_dev_vnet01_subnet01.id}"
    }
    test = {
      vnet = "${data.azurerm_virtual_network.pe_test_vnet01.id}"
      default_subnet = "${data.azurerm_subnet.pe_test_vnet01_subnet01.id}"
    }
    prod = {
      vnet = "${data.azurerm_virtual_network.pe_prod_vnet01.id}"
      default_subnet = "${data.azurerm_subnet.pe_prod_vnet01_subnet01.id}"
    }
    },
  )
}



output "vnet_map" {
  description = "VNET map on existing vnets and subnets per environment"
  value       = local.vnet_map
}
