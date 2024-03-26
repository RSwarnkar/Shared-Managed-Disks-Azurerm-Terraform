



resource "azurerm_managed_disk" "linuxvm_shared_disks" {
  for_each = { for disk in var.linuxvm_shared_disks : disk.shared_disk_name => disk }

  name                          = each.value.shared_disk_name
  resource_group_name           = each.value.resource_group_name
  location                      = each.value.location
  storage_account_type          = each.value.storage_account_type
  disk_size_gb                  = each.value.disk_size_gb
  create_option                 = "Empty"
  tier                          = each.value.performance_tier
  max_shares                    = each.value.max_shares_count
  public_network_access_enabled = each.value.public_network_access_enabled
  network_access_policy         = each.value.network_access_policy

  tags = each.value.tags

}



resource "azurerm_virtual_machine_data_disk_attachment" "linuxvm-shared-disk-attach" {
  for_each              = { for disk in local.linuxvm_shared_disk_attach_list : "${disk.hostname}~${disk.shared_disk_name}" => disk }
  managed_disk_id    = azurerm_managed_disk.linuxvm_shared_disks[each.value.shared_disk_name].id
  virtual_machine_id = azurerm_linux_virtual_machine.linuxvms[each.value.hostname].id
  lun                = each.value.lun
  caching            = "None"
  depends_on         = [ 
    azurerm_linux_virtual_machine.linuxvms,
    azurerm_managed_disk.linuxvm_shared_disks
    ]
}


