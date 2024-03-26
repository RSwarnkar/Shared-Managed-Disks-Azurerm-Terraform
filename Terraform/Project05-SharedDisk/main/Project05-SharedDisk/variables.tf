
variable "default_tags" {
  type = map(any)
}

variable "resource_groups" {
  type = list(any)
}

variable "vnets" {
  type = list(any)
}

variable "linux_vms" {
  type = list(any)
}

variable "linuxvm_shared_disks" {
  type = list(any)
}