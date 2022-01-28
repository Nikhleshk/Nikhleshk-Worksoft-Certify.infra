data "azurerm_key_vault" "kv3" {
  name                = "otk-workcert-dev-kv" 
  resource_group_name = "worksoftcertify-dev-rg" 
}

data "azurerm_key_vault_secret" "sec03" {  
  name         = "grpunderscorecloudcoe"
  key_vault_id = data.azurerm_key_vault.kv3.id
}


module "domain-join3" {
  source  = "kumarvna/domain-join/azurerm"
  version = "1.1.0"

  virtual_machine_id        = element(concat(module.virtual-machine3.windows_virtual_machine_ids, [""]), 0)
  active_directory_domain   = "od.cssdom.com"
  active_directory_username = "grp_cloudcoe"
  active_directory_password = data.azurerm_key_vault_secret.sec03.value
  ou_path = "OU=Worksoft Certify,OU=Azure West Europe,OU=Cloud,OU=Servers,DC=od,DC=cssdom,DC=com"


  # Adding TAG's to your Azure resources (Required)
   tags = {
    "guid"           = "${local.settings.variables.applicationsysid}"
    "project number" = "${local.settings.variables.projectnumber}"
  }
  
depends_on = [
    module.key-vault.main,
    module.key-vault.key_vault_name,
    module.virtual-machine3,
    module.key-vault,
  ]
}