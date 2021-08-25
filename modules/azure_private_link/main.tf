##################################
# PrivateLink
##################################

data "azurerm_subnet" "module" {
  name                 = var.private_link_vnet_subnet_name
  virtual_network_name = var.private_link_vnet_name
  resource_group_name  = var.private_link_vnet_resource_group_name
}

resource "azurerm_private_endpoint" "module" {
  for_each            = toset(var.private_link_subresource_types)
  name                = "${var.private_link_resource_name}-${each.key}-endpoint"
  location            = var.private_link_nic_location
  resource_group_name = var.private_link_nic_resource_group_name
  subnet_id           = data.azurerm_subnet.module.id

  private_service_connection {
    name                           = "${var.private_link_resource_name}-${each.key}-privateserviceconnection"
    private_connection_resource_id = var.private_link_resource_id
    is_manual_connection           = false
    subresource_names              = [each.key]
  }
}
