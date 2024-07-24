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
}

run "plan" {
  command = plan

  variables {
    name                = run.setup.workspace_id
    resource_group_name = run.setup.resource_group_name
    location            = run.setup.resource_group_location
  }

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
    condition     = azurerm_web_application_firewall_policy.main.managed_rules[0].managed_rule_set[0].type == var.managed_rule[0].type
    error_message = "The managed rule set 1 type is being modified."
  }

  assert {
    condition     = azurerm_web_application_firewall_policy.main.managed_rules[0].managed_rule_set[0].version == var.managed_rules[0].version
    error_message = "The managed rule set 1 version is being modified."
  }

  assert {
    condition     = azurerm_web_application_firewall_policy.main.managed_rules[0].managed_rule_set[1].type == var.managed_rules[1].type
    error_message = "The managed rule set 2 type is being modified."
  }

  assert {
    condition     = azurerm_web_application_firewall_policy.main.managed_rules[0].managed_rule_set[1].version == var.managed_rules[1].version
    error_message = "The managed rule set 2 version is being modified."
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
