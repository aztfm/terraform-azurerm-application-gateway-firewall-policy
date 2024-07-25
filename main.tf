resource "azurerm_web_application_firewall_policy" "main" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  policy_settings {
    enabled = var.enabled
    mode    = var.mode
  }

  managed_rules {
    dynamic "managed_rule_set" {
      for_each = var.managed_rule_sets

      content {
        type    = managed_rule_set.value.type
        version = managed_rule_set.value.version
      }
    }

    dynamic "exclusion" {
      for_each = var.managed_rule_exclusions

      content {
        match_variable          = exclusion.value.match_variable
        selector_match_operator = exclusion.value.selector_match_operator
        selector                = exclusion.value.selector

        dynamic "excluded_rule_set" {
          for_each = exclusion.value.rule_set != null ? [""] : []

          content {
            type    = exclusion.value.rule_set.type
            version = local.managed_rule_exclusion_rule_set_version[exclusion.value.rule_set.type]

            dynamic "rule_group" {
              for_each = exclusion.value.rule_set.rule_groups

              content {
                rule_group_name = rule_group.value.rule_group_name
                excluded_rules  = rule_group.value.excluded_rules
              }
            }
          }
        }
      }
    }
  }
}
