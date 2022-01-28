variable "applicationname" {
  type = string
  description = "Application name. Use only lowercase letters and numbers"
  default = "starterterraform"
}

variable "onboarddetailsid" {
  type = string
  description = "onboard details id"
  default = "167"
}

variable "environment" {
  type    = string
  description = "Environment name, e.g. 'dev' or 'stage'"
  default = "dev"
}

variable "location" {
  type    = string
  description = "Azure region where to create resources."
  default = "West Europe"
}

variable "tags" {  
  type  = map(string)
  description = "Azure region where to create resources."
  default = {
    templated  = "terraform"
  }
}
variable "tenant_id" {
  type    = string
  description = "Azure Active Directory Id"
  default = ""
}

variable "short_env" {
  type  = map(string)
  description = "Short value for Environment name"
  default = {
    dev = "d"
    test = "t"
    stg = "s"
    uat = "u"
    prod = "p"
    dr = "r"    
  }
}

variable "vm_sku" {
  type    = string
  description = "sku size of vm"
  default = "Standard_B4ms"
}

variable "vm_single_count" {
  description = "instance count of vm"
  default     = "1"
}


variable "vm_sku2" {
  type    = string
  description = "sku size of vm"
  default = "Standard_A2m_v2"
}



variable "vm_single_count2" {
  description = "instance count of vm"
  default     = "1"
}

variable "vm_sku3" {
  type    = string
  description = "sku size of vm"
  default = "Standard_B4ms"
}


variable "vm_single_count3" {
  description = "instance count of vm"
  default     = "1"
}
