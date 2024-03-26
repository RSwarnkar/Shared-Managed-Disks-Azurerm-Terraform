

variable "resource_groups" {
  description = "List of resource groups"
  type = list(object({
    name = string
    location = string
    tags = map(string)
  }))
}

variable "default_tags" {
  description = "Map of standard tags on all resources"
  type = map(string)
}