locals {
  vm_name_prefix = "az${local.settings.variables.shortregion}${local.settings.variables.onboarddetailsid}as${var.short_env[var.environment]}"
  }


module "virtual-machine1" {
  source = "../modules/terraform-azurerm-virtual-machine"
  #source  = "kumarvna/virtual-machine/azurerm"
  #version = "2.3.0"
  # insert the 27 required variables here  

  # Resource Group, location, VNet and Subnet details
  resource_group_name = "${local.settings.variables.applicationname}-${var.environment}-rg"
  location            = local.settings.variables.location

  existing_vnet_id   = lookup(local.vnet_map, var.environment, ).vnet
  existing_subnet_id = lookup(local.vnet_map, var.environment, ).default_subnet

  virtual_machine_name = local.vm_name_prefix

  key_vault_name = "otk-${local.settings.variables.shortapplicationname}-${var.environment}-kv"

  # This module support multiple Pre-Defined Linux and Windows Distributions.
  # Check the README.md file for more pre-defined images for WindowsServer, MSSQLServer.
  # Please make sure to use gen2 images supported VM sizes if you use gen2 distributions
  # This module creates a random admin password if `admin_password` is not specified
  # Specify a valid password with `admin_password` argument to use your own password 
  os_flavor                 = "windows"
  windows_distribution_name = "windows2019dc"
  virtual_machine_size      = var.vm_sku
  #admin_username            = "${local.virtual_machine_name}-adm"
  instances_count           = var.vm_single_count

  # Proxymity placement group, Availability Set and adding Public IP to VM's are optional.
  # remove these argument from module if you dont want to use it.  
  enable_proximity_placement_group = false
  enable_vm_availability_set       = false
  enable_public_ip_address         = false

  # Network Seurity group
  existing_network_security_group_id = "/subscriptions/ae561200-9fcb-454a-8961-a82f778450d2/resourceGroups/worksoftcertify-networks-weu-dev-rg/providers/Microsoft.Network/networkSecurityGroups/workcert-weu-dev-nsg"


  # Boot diagnostics to troubleshoot virtual machines, by default uses managed 
  # To use custom storage account, specify `storage_account_name` with a valid name
  # Passing a `null` value will utilize a Managed Storage Account to store Boot Diagnostics
  enable_boot_diagnostics = true

  # Attach a managed data disk to a Windows/Linux VM's. Possible Storage account type are: 
  # `Standard_LRS`, `StandardSSD_ZRS`, `Premium_LRS`, `Premium_ZRS`, `StandardSSD_LRS`
  # or `UltraSSD_LRS` (UltraSSD_LRS only available in a region that support availability zones)
  # Initialize a new data disk - you need to connect to the VM and run diskmanagemnet or fdisk
  data_disks = [
    {
      name                 = "disk1"
      disk_size_gb         = 100
      storage_account_type = "StandardSSD_LRS"
    }
  ]
 
  # (Optional) To enable Azure Monitoring and install log analytics agents
  # (Optional) Specify `storage_account_name` to save monitoring logs to storage.   
  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.laws.id

  # Deploy log analytics agents to virtual machine. 
  # Log analytics workspace customer id and primary shared key required.
  deploy_log_analytics_agent                 = false
  log_analytics_customer_id                  = data.azurerm_log_analytics_workspace.laws.workspace_id
  log_analytics_workspace_primary_shared_key = data.azurerm_log_analytics_workspace.laws.primary_shared_key

  # Adding Tags to your Azure resources (Required)  
  tags = {
    "guid"           = "${local.settings.variables.applicationsysid}"
    "project number" = "${local.settings.variables.projectnumber}"
  }

  depends_on = [
    module.key-vault.main,
    module.key-vault.key_vault_name,
  ]
}

