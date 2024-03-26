

module "resource_groups" {
  source          = "../../modules/resource_groups"
  resource_groups = var.resource_groups
  default_tags    = var.default_tags
  providers = {
    azurerm = azurerm
  }
}

module "vnets" {
  source       = "../../modules/vnets"
  vnets        = var.vnets
  default_tags = var.default_tags
  providers = {
    azurerm = azurerm
  }
}

module "linux_vms" {
  source       = "../../modules/linux_vms"
  linux_vms    = var.linux_vms
  default_tags = var.default_tags
  vnets        = var.vnets
  linuxvm_shared_disks = var.linuxvm_shared_disks
  providers = {
    azurerm = azurerm
  }
}

