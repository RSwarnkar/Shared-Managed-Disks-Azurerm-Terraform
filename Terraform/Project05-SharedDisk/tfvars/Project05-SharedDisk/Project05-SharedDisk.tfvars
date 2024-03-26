
default_tags = {
  owner        = "Rajesh Swarnkar"
  cost_center  = "PayG"
  department   = "DevOps Infra"
  deployed_via = "Terraform"
}


##---------------- RELEASE 1 -----------------
## Resource Groups 
##--------------------------------------------

resource_groups = [
  {
    name     = "rg-shareddisk"
    location = "East US"
    tags = {
      appname = "Shared Disk"
    }
  }
]


##---------------- RELEASE 2 -----------------
## Virtual Network Infra
##--------------------------------------------

vnets = [
  {
    vnet_name           = "vnet-01"
    resource_group_name = "rg-shareddisk"
    location            = "East US"
    address_spaces = [
      "10.100.0.0/16",
    ]
    subnets = [
      {
        subnet_name          = "subnet-01"
        subnet_address_space = "10.100.1.0/24"
      }
    ]
    tags = {
      appname = "Shared Disk"
    }
  }
]

##---------------- RELEASE 3 -----------------
## Virtual Network Infra
##--------------------------------------------

linuxvm_shared_disks = [
  {
    shared_disk_name             = "shared-disk-01"
    resource_group_name           = "rg-shareddisk"
    location                      = "eastus"
    storage_account_type          = "Premium_ZRS"
    disk_size_gb                  = 8
    performance_tier              = "P2"
    max_shares_count              = 3
    public_network_access_enabled = false 
    network_access_policy         = "DenyAll"
    tags                          = {
      appname = "Shared Disk"
    }
  },
]

##---------------- RELEASE 4 -----------------
## Linux Virtual Machines 
##--------------------------------------------

linux_vms = [
  {
    hostname            = "ubuntuvm01"
    location            = "eastus"
    resource_group_name = "rg-shareddisk"
    size                = "Standard_B2ms"

    image_source_reference = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts-gen2"
      version   = "latest"
    }

    network = {
      vnet_rg_name       = "rg-shareddisk"
      subnet_name        = "subnet-01"
      vnet_name          = "vnet-01"
      private_ip_address = null # "10.100.1.5"
    }

    data_disks = [
      {
        disk_name_suffix     = "disk01"
        storage_account_type = "Standard_LRS"
        disk_size_gb         = 8
      }
    ]

    shared_disks = [
      {
        shared_disk_name = "shared-disk-01"
        disk_rg_name = "rg-shareddisk"
        lun = 2
      }
    ]
    tags = {
      daily_shutdown = "0900"
    }
  },
  {
    hostname            = "ubuntuvm02"
    location            = "eastus"
    resource_group_name = "rg-shareddisk"
    size                = "Standard_B2ms"

    image_source_reference = {
      publisher = "Canonical"
      offer     = "0001-com-ubuntu-server-jammy"
      sku       = "22_04-lts-gen2"
      version   = "latest"
    }

    network = {
      vnet_rg_name       = "rg-shareddisk"
      subnet_name        = "subnet-01"
      vnet_name          = "vnet-01"
      private_ip_address = null # "10.100.1.5"
    }

    data_disks = [
      {
        disk_name_suffix     = "disk01"
        storage_account_type = "Standard_LRS"
        disk_size_gb         = 8
      }
    ]

    shared_disks = [
      {
        shared_disk_name = "shared-disk-01"
        disk_rg_name = "rg-shareddisk"
        lun = 2
      }
    ]
    tags = {
      daily_shutdown = "0900"
    }
  },
]

