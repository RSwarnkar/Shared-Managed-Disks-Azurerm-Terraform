locals {
  subnet_list = flatten([
    for vnet in var.vnets : [
        for subnet in vnet.subnets : {
            vnet_name = vnet.vnet_name 
            subnet_name = subnet.subnet_name
            resource_group_name = vnet.resource_group_name
            subnet_address_space = subnet.subnet_address_space
            location = vnet.location 
            tags = vnet.tags
        }
    ]
  ])
}
