provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "main" {
  name     = "mujaheed-resources"
  location = "UK South"
}

variable "vnet_name" {
  description = "The name of the virtual network to be used in the network module."
  type        = string
  default     = "mujaheed-network"  // You can provide a default or make it mandatory to enter
}


module "network" {
  source = "./modules/network"
  location = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  vnet_name = var.vnet_name
}

module "compute" {
  source = "./modules/compute"
  web_subnet_id  = module.network.web_subnet_id
  location = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

module "application_gateway" {
  source              = "./modules/application_gateway"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  vnet_name           = module.network.vnet_name  # Make sure this output exists
  # appgw_public_ip_id  = azurerm_public_ip.appgw_pip.id
  # appgw_subnet_id     = module.network.appgw_subnet_id
  web_subnet_id = module.network.web_subnet_id
}



# module "application_gateway" {
#   source = "./modules/application_gateway"
#   web_subnet_id = module.network.web_subnet_id
#   # appgw_public_ip_id = azurerm_public_ip.appgw_pip.id
#   #vnet_name = azurerm_virtual_network.main.name
#   vnet_name = "mujaheed-vnet"
#   location = azurerm_resource_group.main.location
#   resource_group_name = azurerm_resource_group.main.name
# }
module "backup" {
  source = "./modules/backup"
  vm_id = module.compute.vm_id
  location = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}
module "database" {
  source = "./modules/database"
  location = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}
module "load_balancer" {
  source = "./modules/load_balancer"
  location = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}
module "security" {
  source = "./modules/security"
  location = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}