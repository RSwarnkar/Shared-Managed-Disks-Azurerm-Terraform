

resource "azurerm_virtual_network" "vnets" {
  for_each            = { for vnet in var.vnets : vnet.vnet_name => vnet }
  name                = each.value.vnet_name
  resource_group_name = each.value.resource_group_name
  address_space       = each.value.address_spaces
  location            = each.value.location
}

resource "azurerm_subnet" "subnets" {
  for_each             = { for subnet in local.subnet_list : "${subnet.vnet_name}~${subnet.subnet_name}" => subnet }
  name                 = each.value.subnet_name
  resource_group_name  = each.value.resource_group_name
  address_prefixes     = [each.value.subnet_address_space]
  virtual_network_name = each.value.vnet_name
  depends_on = [ azurerm_virtual_network.vnets ]
}

# NSGs: 

resource "azurerm_network_security_group" "nsgs" {
  for_each            = { for subnet in local.subnet_list : "${subnet.vnet_name}~${subnet.subnet_name}" => subnet }
  name                = "nsg-${each.value.subnet_name}"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  security_rule {
    name                         = "SR-Allow-SSH-RDP-Inbound"
    priority                     = 4000
    direction                    = "Inbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_ranges      = ["22", "3389"]
    source_address_prefix        = "*"
    destination_address_prefixes = [each.value.subnet_address_space]
  }
  tags = merge(each.value.tags, var.default_tags)

  depends_on = [ azurerm_subnet.subnets ]
}

# Attach NSG on Subnet

resource "azurerm_subnet_network_security_group_association" "nsgs_on_subnet" {
  for_each                  = { for subnet in local.subnet_list : "${subnet.vnet_name}~${subnet.subnet_name}" => subnet }
  subnet_id                 = azurerm_subnet.subnets["${each.value.vnet_name}~${each.value.subnet_name}"].id
  network_security_group_id = azurerm_network_security_group.nsgs["${each.value.vnet_name}~${each.value.subnet_name}"].id
}

