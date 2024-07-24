resource "azurerm_web_application_firewall_policy" "main" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  managed_rules {
    dynamic "managed_rule_set" {
      for_each = var.managed_rule_sets

      content {
        type    = managed_rule_set.value.type
        version = managed_rule_set.value.version
      }
    }
  }
}
