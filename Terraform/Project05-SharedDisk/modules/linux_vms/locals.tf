locals {

  linuxvm_datadisk_list = flatten([
    for vm in var.linux_vms : [
      for disk in vm.data_disks : {
        disk_name            = "${vm.hostname}-${disk.disk_name_suffix}"
        hostname             = vm.hostname
        storage_account_type = disk.storage_account_type
        disk_size_gb         = disk.disk_size_gb
        location             = vm.location
        resource_group_name  = vm.resource_group_name
      }
    ]
  ])

  subnet_list = flatten([
    for vnet in var.vnets : [
      for subnet in vnet.subnets : {
        subnet_name         = subnet.subnet_name
        vnet_name           = vnet.vnet_name
        resource_group_name = vnet.resource_group_name
        location            = vnet.location
      }
    ]
  ])

  linuxvm_shared_disk_attach_list = flatten([
    for vm in var.linux_vms : [
      for disk in vm.shared_disks : {
        hostname         = vm.hostname
        shared_disk_name = disk.shared_disk_name
        disk_rg_name     = disk.disk_rg_name
        vm_rg_name       = vm.resource_group_name
        lun              = disk.lun
      }
    ]
  ])

}

