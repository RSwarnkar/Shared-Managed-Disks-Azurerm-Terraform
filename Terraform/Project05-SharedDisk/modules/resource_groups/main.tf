

resource "azurerm_resource_group" "resource_groups" {
  for_each = { for rg in var.resource_groups : rg.name => rg }
  name     = each.value.name
  location = each.value.location
  tags     = merge(each.value.tags,var.default_tags)
}


