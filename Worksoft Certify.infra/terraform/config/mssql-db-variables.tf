# MS SQL DB
variable "sqldb_service_objective_name" {
  type    = string
  description = "The service objective name for the database"
  default = "s1"
}
variable "enable_private_endpoint" {
  type    = bool
  description = "Enable Private Endpoint"
  default = true
}
variable "virtual_network_name" {
  type    = string
  description = "VNET for Private Endpoint"
  default = ""
}
variable "private_subnet_address_prefix" {
  type    = list(string)
  description = "Subnet in the VNET for Private Endpoint"
  default = [""]
}
