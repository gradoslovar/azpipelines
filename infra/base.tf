# Declare variable - Base Module
variable "global_customer_id" {}
variable "global_product_id" {}
variable "global_location" {}
variable "global_vnet_address_space" {}
variable "global_vnet_subnet_prefixes" {}
variable "global_tags" {}
variable "global_alsid_vpn_address" {}
variable "global_tenable_whitelist_addresses" {}

# Set Azure provider
terraform {
  required_providers {
    azurerm = {
      version = "=2.68.0"
    }
  }
#  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

# Use afad-base module to create resource group, vnet and subnet(s).
module "afad-base" {
  source               = "./modules/afad-base"
  resource_group_name  = "${var.global_customer_id}-${var.global_product_id}"
  virtual_network_name = "${var.global_customer_id}-${var.global_product_id}-vnet"
  location             = var.global_location
  address_space        = var.global_vnet_address_space
  subnet_names = [
    "${var.global_customer_id}-sen-subnet",
    "${var.global_customer_id}-dl-subnet",
    "${var.global_customer_id}-sql-subnet"
  ]
  subnet_prefixes = var.global_vnet_subnet_prefixes
  tags            = var.global_tags
}

# Create Network Security Group
resource "azurerm_network_security_group" "nsg" {
  depends_on          = [module.afad-base]
  name                = "${var.global_customer_id}-${var.global_product_id}-nsg"
  location            = var.global_location
  resource_group_name = "${var.global_customer_id}-${var.global_product_id}"

  security_rule {
    name                       = "Alsid_HTTPS"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = var.global_alsid_vpn_address
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Alsid_HTTP"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = var.global_alsid_vpn_address
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Tenable_HTTPS"
    priority                   = 2000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefixes    = var.global_tenable_whitelist_addresses
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Tenable_HTTP"
    priority                   = 2001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefixes    = var.global_tenable_whitelist_addresses
    destination_address_prefix = "*"
  }
}

# Associate AFAD subnets with NSG
resource "azurerm_subnet_network_security_group_association" "nsg-sen-association" {
  subnet_id                 = module.afad-base.vnet_subnets[count.index]
  network_security_group_id = azurerm_network_security_group.nsg.id
  count                     = length(var.global_vnet_subnet_prefixes)
}