
# MAKE CHNAGE AS YOU NEED
variable "linuxvm_admin_username" {
  description = "Linux Admin Username"
  type = string
  default = "rswarnka"
}

variable "linux_vms" {
    description = "List of Linux VMs to be created"
    type = list(object({
      hostname = string 
      location = string 
      resource_group_name = string 
      size = string
      image_source_reference = object({
        publisher = string 
        offer = string 
        sku = string
        version = string  
      })
      network = object({
        vnet_rg_name = string
        subnet_name = string
        vnet_name = string 
        private_ip_address = string 
      })
      data_disks = list(object({
        disk_name_suffix = string 
        storage_account_type = string
        disk_size_gb = number  
      }))
      shared_disks = list(object({
        shared_disk_name = string
        disk_rg_name = string
        lun = number
      }))
      tags = map(string)
    }))
}

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


variable "linuxvm_shared_disks" {
  description = "Linux VM Shared Disks"
  type = list(object({
    shared_disk_name  = string 
    resource_group_name = string 
    location = string 
    storage_account_type = string 
    disk_size_gb = number 
    performance_tier = string 
    max_shares_count = number
    public_network_access_enabled = bool 
    network_access_policy = string
    tags = map(string)
  }))
}
 