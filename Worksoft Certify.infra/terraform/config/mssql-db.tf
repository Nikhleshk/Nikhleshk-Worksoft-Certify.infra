module "mssql-server" {
  source = "../modules/terraform-azurerm-mssql-db/"
  #source  = "kumarvna/mssql-db/azurerm"
  #version = "1.3.0"

  
  # By default, this module will not create a resource group
  # proivde a name to use an existing resource group, specify the existing resource group name,
  # and set the argument to `create_resource_group = false`. Location will be same as existing RG.
  create_resource_group = false
  resource_group_name   = "${local.settings.variables.applicationname}-${var.environment}-rg"
  location              = var.location
  # SQL Server and Database details
  # The valid service objective name for the database include S0, S1, S2, S3, P1, P2, P4, P6, P11
  sqlserver_name               = "otk${local.settings.variables.shortapplicationname}${var.environment}dbserv"
  database_name                = "otk${local.settings.variables.shortapplicationname}${var.environment}db"
  sql_database_edition         = "Standard"
  sqldb_service_objective_name = var.sqldb_service_objective_name

  # use Key Vault
  key_vault_name  = module.key-vault.key_vault_name
  #key_vault_name        = "otk-${local.settings.variables.shortapplicationname}-${var.environment}-kv"

  # AD administrator for an Azure SQL server
  # Allows you to set a user or group as the AD administrator for an Azure SQL server
  ad_admin_login_name = "GG ${local.settings.variables.fullapplicationname} Iaas Database Admin"
  # Firewall Rules to allow azure and external clients and specific Ip address/ranges.
  enable_firewall_rules = true
  firewall_rules = [
    {
      name             = "access-to-azure"
      start_ip_address = "0.0.0.0"
      end_ip_address   = "0.0.0.0"
    },
  ]
  
  # SQL server extended auditing policy defaults to `true`. 
  # To turn off set enable_sql_server_extended_auditing_policy to `false`  
  # Do DB and SQL extended audit only in special cases.
  # This needs Storage account
  enable_sql_server_extended_auditing_policy  = false
  # DB extended auditing policy defaults to `false`. 
  # to tun on set the variable `enable_database_extended_auditing_policy` to `true` 
  # Note: this module does not support separate configs for DB and SQL Server extended audit, hence SQL Server is enough.
  # Never enable DB audit as it is just duplicating logging.
  enable_database_extended_auditing_policy    = false    
   
  # To enable Azure Defender for database set `enable_threat_detection_policy` to true 
  enable_threat_detection_policy = false
  # Enable, if you enable Defender.
  # Requires Storage Account
  enable_vulnerability_assessment = false
  
  # When logging to Storage Account, need to set the log retention.
  log_retention_days             = 0
  
  
  # To enable Azure Monitoring for Azure SQL database including audit logs
  enable_log_monitoring      = true
  # Log Analytic workspace resource id required  
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.laws.id

  # Creating Private Endpoint requires, VNet name and address prefix to create a subnet
  # By default this will create a `privatelink.database.windows.net` DNS zone. 
  # To use existing private DNS zone specify `existing_private_dns_zone` with valid zone name
  # Creating Private Endpoint requires, VNet name and address prefix to create a subnet
  enable_private_endpoint = var.enable_private_endpoint

  existing_vnet_id = var.enable_private_endpoint == true ? lookup(local.vnet_map, var.environment, ).vnet : null
  existing_subnet_id = var.enable_private_endpoint == true ? lookup(local.vnet_map, var.environment, ).default_subnet : null
  existing_private_dns_zone = "privatelink.database.windows.net"

  # Adding TAG's to your Azure resources (Required)
  tags = {
    "guid"            = "${local.settings.variables.applicationsysid}"
    "project number"  = "${local.settings.variables.projectnumber}"
  }

  depends_on = [
    module.key-vault.main,
    module.key-vault.key_vault_name,
  ]
}

output "sql_server_admin_user" {
    value = module.mssql-server.sql_server_admin_user
    sensitive = true
}
output "sql_server_admin_password" {
  value = module.mssql-server.sql_server_admin_password
  sensitive = true
}
output "sql_database_name" {
  value = module.mssql-server.sql_database_name
}