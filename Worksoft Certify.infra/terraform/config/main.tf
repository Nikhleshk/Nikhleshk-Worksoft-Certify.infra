locals {
  raw_settings = yamldecode(file("${path.module}/../../parameters/globalvariables.yml"))
  
  settings = {
    variables = {
      for v in local.raw_settings.variables : v.name => v.value
    }
  }
}

# Calculate one year expiry for secrets stored in Key Vaults
# https://discuss.hashicorp.com/t/add-year-in-timeadd-function-or-availability-of-dateadd-function-in-tf/22977/2
resource "time_offset" "password_end" {
  offset_years = 1
}


module "key-vault" {
  source = "../modules/terraform-azurerm-key-vault"
  #source  = "kumarvna/key-vault/azurerm"
  #version = "2.2.0"
  

  # Resource Group and Key Vault pricing tier details
  resource_group_name        = "${local.settings.variables.applicationname}-${var.environment}-rg"
  key_vault_name             = "otk-${local.settings.variables.shortapplicationname}-${var.environment}-kv"
  key_vault_sku_pricing_tier = "standard"
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.laws.id

  access_policies = [
    {
      azure_ad_group_names = ["GRP GG Cloud Coe Admin","GG ${local.settings.variables.fullapplicationname} Cloud Contributor"]
      key_permissions               = ["create", "delete", "get", "backup", "decrypt", "encrypt", "import", "list", "recover", "restore", "sign", "update", "verify"]
      secret_permissions            = ["backup", "delete", "get", "list", "recover", "restore", "set"]
      certificate_permissions       = ["backup", "create", "delete", "deleteissuers", "get", "getissuers", "import", "list", "listissuers", "managecontacts", "manageissuers", "recover", "restore", "setissuers", "update"]
      storage_permissions           = ["backup", "delete", "deletesas", "get", "getsas", "list", "listsas", "recover", "regeneratekey", "restore", "set", "setsas", "update"]
    },
    {
      azure_ad_group_names = ["GG ${local.settings.variables.fullapplicationname} Cloud Reader"]
      key_permissions               = ["get", "list"]
      secret_permissions            = ["get", "list"]
      certificate_permissions       = ["get","list"]
      storage_permissions           = ["get", "list"]
    }
    #,
    #{
    #  azure_ad_service_principal_names = [replace("devops-rg-${local.settings.variables.fullapplicationname}-${var.environment}-spn"," ", "-")]
    #  key_permissions               = ["get", "list"]
    #  secret_permissions            = ["get", "list"]
    #  certificate_permissions       = ["get","list"]
    #  storage_permissions           = ["get", "list"]
    #}
  ]

  # Create a required Secrets as per your need.
  # When you Add `usernames` with empty password this module creates a strong random password 
  # use .tfvars file to manage the secrets as variables to avoid security issues. 
  secrets = {
    "grppcsremaccautprod" = "Cloud#PC$654321"
  }

  # Creating Private Endpoint requires, VNet name and address prefix to create a subnet
  # By default this will create a `privatelink.vaultcore.azure.net` DNS zone. 
  # To use existing private DNS zone specify `existing_private_dns_zone` with valid zone name
  

  enable_private_endpoint = true
  existing_vnet_id = var.enable_private_endpoint == true ? lookup(local.vnet_map, var.environment, ).vnet : null
  existing_subnet_id = var.enable_private_endpoint == true ? lookup(local.vnet_map, var.environment, ).default_subnet : null
  existing_private_dns_zone = "privatelink.vault.azure.net"  
  

  # Adding Tags to your Azure resources (Required)  
  tags = {
    "guid"            = "${local.settings.variables.applicationsysid}"
    "project number"  = "${local.settings.variables.projectnumber}"
  }
}


provider "azurerm" {
  alias           = "OTK-Cyber-Security-SOC"
  subscription_id = "d58e5435-084f-42ac-8457-1a041210526e"
  features {}
}

# Data
# Make client_id, tenant_id, subscription_id and object_id variables
data "azurerm_client_config" "current" {}

data "azurerm_log_analytics_workspace" "laws" {
  provider            = azurerm.OTK-Cyber-Security-SOC
  name                = "otk-soc-weu-la"
  resource_group_name = "azureservicemanagement-prod-rg"
}

