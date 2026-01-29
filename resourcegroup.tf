terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.57.0"
    }
  }
}

provider "azurerm" {
  # Configuration options
  features {}
  subscription_id = "b14a3699-29f5-4013-af1a-5ee5bcc0c511"
}

resource "azurerm_resource_group" "example" {
  name     = "rohit-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "storageacct-create" {
  name                     = "storageacct"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_virtual_network" "VNet-create" {
  name                = "Vnet"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_network_security_group" "nsg-create" {
  name                = "nsg"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
}

resource "azurerm_subnet" "app-subnet-create" {
  name                 = "app-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "nic-create" {
  name                = "nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.app-subnet-create.id
    private_ip_address_allocation = "Dynamic"
  }
  
}
