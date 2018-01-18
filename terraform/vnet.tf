provider "azurerm" {
   subscription_id = "subscription_id-example"
   client_id = "client_id-example"
   client_secret = "client_secret-example"
   tenant_id = "tenant_id-example"
}

resource "azurerm_resource_group" "MyResource" {
   name = "example-name"
   location = "West US"
}

resource "azurerm_subnet" "MyResource" {
   name = "testsubnet"
   resource_group_name = "${azurerm_resource_group.test.name}"
   virtual_network_name = "${azurerm_virtual_network.test.name}"
   address_prefix = "10.0.1.0/24"
}

resource "azurerm_virtual_network" "MyResource" {
   name = "virtualNetwork1"
   location = "West US"
   resource_group_name = "${azurerm_resource_group.test.name}"
   address_space = ["10.0.0.0/16"]
   dns_servers = ["10.0.0.4"]
}
