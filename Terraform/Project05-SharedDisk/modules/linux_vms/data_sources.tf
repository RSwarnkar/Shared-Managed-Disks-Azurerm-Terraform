
data "azurerm_subnet" "subnets" {
    for_each = { for subnet in local.subnet_list : "${subnet.vnet_name}-${subnet.subnet_name}" => subnet }
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.resource_group_name
}