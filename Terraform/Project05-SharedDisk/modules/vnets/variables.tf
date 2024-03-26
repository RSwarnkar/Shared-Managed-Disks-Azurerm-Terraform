

variable "vnets" {
  description = "List of virtal networks"
  type = list(object({
    vnet_name = string
    resource_group_name = string
    location = string
    address_spaces = list(string)
    subnets = list(object({
      subnet_name = string
      subnet_address_space = string 
    }))
    tags = map(string)
  }))
}

variable "default_tags" {
  description = "Map of standard tags on all resources"
  type = map(string)
}

