provider "azurerm" {
  version = "~> 1.13"
}

resource "azurerm_resource_group" "example-group" {
  name     = "terraform-example-resource-group"
  location = "UKSouth"
}

resource "azurerm_public_ip" "example-publicip" {
  name                         = "example-publicip"
  location                     = "${azurerm_resource_group.example-group.location}"
  resource_group_name          = "${azurerm_resource_group.example-group.name}"
  public_ip_address_allocation = "static"
  sku                          = "Standard"
  domain_name_label            = "example-diary"
}

resource "azurerm_lb" "example-lb" {
  name                = "example-lb"
  location            = "${azurerm_resource_group.example-group.location}"
  resource_group_name = "${azurerm_resource_group.example-group.name}"
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = "LoadBalancerFrontEnd"
    public_ip_address_id = "${azurerm_public_ip.example-publicip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "example-backendpool" {
  resource_group_name = "${azurerm_resource_group.example-group.name}"
  loadbalancer_id     = "${azurerm_lb.example-lb.id}"
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "example-probe" {
  resource_group_name = "${azurerm_resource_group.example-group.name}"
  loadbalancer_id     = "${azurerm_lb.example-lb.id}"
  name                = "default"
  protocol            = "Http"
  port                = "80"
  request_path        = "/Health"
  interval_in_seconds = "5"
  number_of_probes    = "2"
}

resource "azurerm_lb_rule" "example-rule" {
  resource_group_name            = "${azurerm_resource_group.example-group.name}"
  loadbalancer_id                = "${azurerm_lb.example-lb.id}"
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "LoadBalancerFrontEnd"
}
