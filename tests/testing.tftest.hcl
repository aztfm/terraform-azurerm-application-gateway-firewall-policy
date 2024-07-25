provider "azurerm" {
  features {}
}

run "setup" {
  module {
    source = "./tests/environment"
  }
}

variables {
  managed_rule_sets = [{
    type    = "OWASP"
    version = "3.2"
    }, {
    type    = "Microsoft_BotManagerRuleSet"
    version = "1.0"
  }]
  managed_rule_exclusions = [{
    match_variable          = "RequestArgKeys"
    selector_match_operator = "Contains"
    selector                = "test-selector-1"
    rule_set = {
      type = "OWASP"
      rule_groups = [{
        rule_group_name = "REQUEST-911-METHOD-ENFORCEMENT"
        excluded_rules  = ["911100"]
        }, {
        rule_group_name = "REQUEST-913-SCANNER-DETECTION"
        excluded_rules  = ["913110", "913120"]
      }]
    }
    }, {
    match_variable          = "RequestCookieNames"
    selector_match_operator = "EndsWith"
    selector                = "test-selector-2"
  }]
}

run "plan" {
  command = plan

  variables {
    name                = run.setup.workspace_id
    resource_group_name = run.setup.resource_group_name
    location            = run.setup.resource_group_location
  }

  #region Managed Rule Sets

  assert {
    condition     = azurerm_web_application_firewall_policy.main.name == run.setup.workspace_id
    error_message = "The Application Gateway Firewall Policy name input variable is being modified."
  }

  assert {
    condition     = azurerm_web_application_firewall_policy.main.resource_group_name == run.setup.resource_group_name
    error_message = "The Application Gateway Firewall Policy resource group input variable is being modified."
  }

  assert {
    condition     = azurerm_web_application_firewall_policy.main.location == run.setup.resource_group_location
    error_message = "The Application Gateway Firewall Policy location input variable is being modified."
  }

  assert {
    condition     = azurerm_web_application_firewall_policy.main.managed_rules[0].managed_rule_set[0].type == var.managed_rule_sets[0].type
    error_message = "The managed rule set 1 type is being modified."
  }

  assert {
    condition     = azurerm_web_application_firewall_policy.main.managed_rules[0].managed_rule_set[0].version == var.managed_rule_sets[0].version
    error_message = "The managed rule set 1 version is being modified."
  }

  assert {
    condition     = azurerm_web_application_firewall_policy.main.managed_rules[0].managed_rule_set[1].type == var.managed_rule_sets[1].type
    error_message = "The managed rule set 2 type is being modified."
  }

  assert {
    condition     = azurerm_web_application_firewall_policy.main.managed_rules[0].managed_rule_set[1].version == var.managed_rule_sets[1].version
    error_message = "The managed rule set 2 version is being modified."
  }

  #region Managed Rule Exclusions

  assert {
    condition     = azurerm_web_application_firewall_policy.main.managed_rules[0].exclusion[0].match_variable == var.managed_rule_exclusions[0].match_variable
    error_message = "The exclusion type 1 of the managed rule is being modified."
  }

  assert {
    condition     = azurerm_web_application_firewall_policy.main.managed_rules[0].exclusion[0].selector_match_operator == var.managed_rule_exclusions[0].selector_match_operator
    error_message = "The exclusion selector match operator 1 of the managed rule is being modified."
  }

  assert {
    condition     = azurerm_web_application_firewall_policy.main.managed_rules[0].exclusion[0].selector == var.managed_rule_exclusions[0].selector
    error_message = "The exclusion selector 1 of the managed rule is being modified."
  }

  assert {
    condition     = azurerm_web_application_firewall_policy.main.managed_rules[0].exclusion[0].excluded_rule_set[0].type == var.managed_rule_exclusions[0].rule_set.type
    error_message = "The exclusion type 1 of the managed rule is being modified."
  }

  assert {
    condition     = azurerm_web_application_firewall_policy.main.managed_rules[0].exclusion[0].excluded_rule_set[0].rule_group[0].rule_group_name == var.managed_rule_exclusions[0].rule_set.rule_groups[0].rule_group_name
    error_message = "The rule group name 1 of the managed rule exclusion 1 is being modified."
  }

  assert {
    condition     = azurerm_web_application_firewall_policy.main.managed_rules[0].exclusion[0].excluded_rule_set[0].rule_group[0].excluded_rules == tolist([for n in var.managed_rule_exclusions[0].rule_set.rule_groups[0].excluded_rules : tostring(n)])
    error_message = "The rule group excluded rules 1 of the managed rule exclusion 1 is being modified."
  }

  assert {
    condition     = azurerm_web_application_firewall_policy.main.managed_rules[0].exclusion[0].excluded_rule_set[0].rule_group[1].rule_group_name == var.managed_rule_exclusions[0].rule_set.rule_groups[1].rule_group_name
    error_message = "The rule group name 2 of the managed rule exclusion 1 is being modified."
  }

  assert {
    condition     = azurerm_web_application_firewall_policy.main.managed_rules[0].exclusion[0].excluded_rule_set[0].rule_group[1].excluded_rules == tolist([for n in var.managed_rule_exclusions[0].rule_set.rule_groups[1].excluded_rules : tostring(n)])
    error_message = "The rule group excluded rules 2 of the managed rule exclusion 1 is being modified."
  }

  assert {
    condition     = azurerm_web_application_firewall_policy.main.managed_rules[0].exclusion[1].match_variable == var.managed_rule_exclusions[1].match_variable
    error_message = "The exclusion type 2 of the managed rule is being modified."
  }

  assert {
    condition     = azurerm_web_application_firewall_policy.main.managed_rules[0].exclusion[1].selector_match_operator == var.managed_rule_exclusions[1].selector_match_operator
    error_message = "The exclusion selector match operator 2 of the managed rule is being modified."
  }

  assert {
    condition     = azurerm_web_application_firewall_policy.main.managed_rules[0].exclusion[1].selector == var.managed_rule_exclusions[1].selector
    error_message = "The exclusion selector 2 of the managed rule is being modified."
  }
}

run "apply" {
  command = apply

  variables {
    name                = run.setup.workspace_id
    resource_group_name = run.setup.resource_group_name
    location            = run.setup.resource_group_location
  }

  assert {
    condition     = lower(azurerm_web_application_firewall_policy.main.id) == lower("${run.setup.resource_group_id}/providers/Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/${run.setup.workspace_id}")
    error_message = "The Application gateway firewall policy ID is not as expected."
  }

  assert {
    condition     = output.id == azurerm_web_application_firewall_policy.main.id
    error_message = "The output ID is not as expected."
  }
}
