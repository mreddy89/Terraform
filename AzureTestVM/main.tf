# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
      #version = "~> 1.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
  tenant_id = var.azure_tenant_details
  subscription_id = var.azure_subscription_details
  #tenant_id       = "47f864a9-0771-4193-bbd3-94717527643b"
  #subscription_id = "f293e78c-99d8-42fc-aede-75f9dc3d7b3e"
}

# Azure Resource Group Creation/Update
resource "azurerm_resource_group" "example01" {
  name = "rg-manju-01"
  location = "uaenorth"
  tags = local.tags
}

resource "azurerm_resource_group" "example02" {
  name = "rg-manju-02"
  location = "uaenorth"
  tags = local.tags
}

resource "azurerm_resource_group" "example03" {
  name = "${var.resource_group_name_prefix}manju-03"
  location = var.resource_group_location
}

resource "azurerm_virtual_network" "example01" {
  name = "vnet01-manju-un"
  address_space = [ "10.2.0.0/16" ]
  location = var.resource_group_location
  resource_group_name = azurerm_resource_group.example01.name  
}

resource "azurerm_subnet" "example01" {
  name = "subnet01-manju-un"
  address_prefixes = [ "10.2.1.0/24" ]
  virtual_network_name = azurerm_virtual_network.example01.name
  resource_group_name = azurerm_resource_group.example01.name
}

resource "azurerm_subnet" "example02" {
  name = "subnet02-manju-un"
  address_prefixes = [ "10.2.2.0/24" ]
  virtual_network_name = azurerm_virtual_network.example01.name
  resource_group_name = azurerm_resource_group.example01.name
}

resource "azurerm_network_interface" "example01" {
  name                = "test01nic01"
  location            = azurerm_resource_group.example01.location
  resource_group_name = azurerm_resource_group.example01.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.example01.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "example01" {
  name = "testmanju01"
  location = azurerm_resource_group.example01.location
  resource_group_name = azurerm_resource_group.example01.name
  network_interface_ids = [ azurerm_network_interface.example01.id ]
  vm_size = "Standard_DS1_v2"
  
  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer = "WindowsServer"
    sku = "2019-datacenter-core-smalldisk-g2"
    version = "latest"
  }
  
  storage_os_disk {
    name              = "myosdisk1"
    #caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name = "testmanju01"
    admin_username = "manjuadmin"
    admin_password = "P@ssw0rd@123"
  }

  os_profile_windows_config {
    enable_automatic_upgrades = false    
  }
}