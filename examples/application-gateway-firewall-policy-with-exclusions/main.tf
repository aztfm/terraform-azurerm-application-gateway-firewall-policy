resource "azurerm_resource_group" "rg" {
  name     = "resource-group"
  location = "West Europe"
}

module "application_gateway_firewall_policy" {
  source              = "aztfm/application-gateway-firewall-policy/azurerm"
  version             = ">=1.0.0"
  name                = "application-gateway-firewall-policy"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
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
    selector                = "example-1"
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
    selector                = "example-2"
  }]
}
