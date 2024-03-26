
# First, create Public IP 
resource "azurerm_public_ip" "linuxvm_public_ips" {
  for_each            = { for linuxvm in var.linux_vms : linuxvm.hostname => linuxvm }
  name                = "${each.value.hostname}-pubip01"
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  allocation_method   = "Static"
  tags                = merge(var.default_tags, each.value.tags)
}


# Create NIC for VM with 1 Private IP and 1 Public IP
resource "azurerm_network_interface" "linuxvm_nics" {
  for_each            = { for linuxvm in var.linux_vms : linuxvm.hostname => linuxvm }
  name                = "${each.value.hostname}-nic01"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.subnets["${each.value.network.vnet_name}-${each.value.network.subnet_name}"].id
    private_ip_address_allocation = each.value.network.private_ip_address == null ? "Dynamic" : "Static"
    private_ip_address            = each.value.network.private_ip_address == null ? null : each.value.network.private_ip_address
    public_ip_address_id          = azurerm_public_ip.linuxvm_public_ips[each.value.hostname].id
  }
  tags = merge(var.default_tags, each.value.tags)

  depends_on = [azurerm_public_ip.linuxvm_public_ips]
}

# Create Virtual Machine
resource "azurerm_linux_virtual_machine" "linuxvms" {

  for_each = { for linuxvm in var.linux_vms : linuxvm.hostname => linuxvm }

  name                = each.value.hostname
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  size                = each.value.size
  admin_username      = var.linuxvm_admin_username

  network_interface_ids = [azurerm_network_interface.linuxvm_nics[each.value.hostname].id]

  admin_ssh_key {
    username   = var.linuxvm_admin_username
    public_key = file("${path.root}/sshkey.pub")
  }

  os_disk {
    name                 = "${each.value.hostname}_osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 64
  }

  source_image_reference {
    publisher = each.value.image_source_reference.publisher
    offer     = each.value.image_source_reference.offer
    sku       = each.value.image_source_reference.sku
    version   = each.value.image_source_reference.version
  }
  depends_on = [azurerm_network_interface.linuxvm_nics]
  tags       = merge(var.default_tags, each.value.tags)
}

# Create Data Disks for Linux VMs 
resource "azurerm_managed_disk" "linuxvm_datadisks" {
  for_each             = { for disk in local.linuxvm_datadisk_list : disk.disk_name => disk }
  name                 = each.value.disk_name
  location             = each.value.location
  resource_group_name  = each.value.resource_group_name
  storage_account_type = each.value.storage_account_type
  create_option        = "Empty"
  disk_size_gb         = each.value.disk_size_gb
  tags                 = var.default_tags

  depends_on = [azurerm_linux_virtual_machine.linuxvms]
}

# Disk Attachments 

resource "azurerm_virtual_machine_data_disk_attachment" "attach_datadisk" {
  for_each           = { for disk in local.linuxvm_datadisk_list : disk.disk_name => disk }
  managed_disk_id    = azurerm_managed_disk.linuxvm_datadisks[each.value.disk_name].id
  virtual_machine_id = azurerm_linux_virtual_machine.linuxvms[each.value.hostname].id
  lun                = index(local.linuxvm_datadisk_list, each.value)
  caching            = "ReadWrite"
}

# Create Shared Disks
# TBD 


