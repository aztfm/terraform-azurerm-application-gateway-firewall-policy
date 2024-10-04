# Azure Application Gateway Firewall Policy - Terraform Module

[devcontainer]: https://vscode.dev/redirect?url=vscode://ms-vscode-remote.remote-containers/cloneInVolume?url=https://github.com/aztfm/terraform-azurerm-application-gateway-firewall-policy
[registry]: https://registry.terraform.io/modules/aztfm/application-gateway-firewall-policy/azurerm/

[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit)](https://github.com/pre-commit/pre-commit)
[![Terraform Registry](https://img.shields.io/badge/terraform-registry-blueviolet?logo=terraform&logoColor=white)][registry]
[![Dev Container](https://img.shields.io/badge/devcontainer-VSCode-blue?logo=linuxcontainers)][devcontainer]
![GitHub License](https://img.shields.io/github/license/aztfm/terraform-azurerm-application-gateway-firewall-policy)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/aztfm/terraform-azurerm-application-gateway-firewall-policy)

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/aztfm/terraform-azurerm-application-gateway-firewall-policy?quickstart=1)

## :gear: Version compatibility

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 1.x.x       | >= 1.9.x          | >= 3.112.0      |

## :memo: Usage

```hcl
resource "azurerm_resource_group" "rg" {
  name     = "resource-group"
  location = "Spain Central"
}

module "application_gateway_firewall_policy" {
  source              = "aztfm/application-gateway-firewall-policy/azurerm"
  version             = ">=1.0.0"
  name                = "application-gateway-firewall-policy"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = azurerm_resource_group.rg.tags
  managed_rule_sets = [{
    type    = "OWASP"
    version = "3.2"
    }, {
    type    = "Microsoft_BotManagerRuleSet"
    version = "1.0"
  }]
}
```

Reference to more [examples](https://github.com/aztfm/terraform-azurerm-application-gateway-firewall-policy/tree/main/examples).

<!-- BEGIN_TF_DOCS -->
## :arrow_forward: Parameters

The following parameters are supported:

| Name | Description | Type | Default | Required |
| ---- | ----------- | :--: | :-----: | :------: |
|name|The name of the Application Gateway Firewall Policy.|`string`|n/a|yes|
|resource\_group\_name|The name of the resource group in which to create the Application Gateway Firewall Policy.|`string`|n/a|yes|
|location|The location/region where the Application Gateway Firewall Policy is created.|`string`|n/a|yes|
|tags|A mapping of tags to assign to the resource.|`map(string)`|`{}`|no|
|enabled|Describes if the policy is in enabled state or disabled state.|`bool`|`true`|no|
|mode|Describes if it is in detection mode or prevention mode at the policy level. Valid values are `Detection` and `Prevention`.|`string`|`"Prevention"`|no|
|request\_body\_inspect\_limit\_in\_kb|The maximum request body inspection size in KB for the policy.|`number`|`128`|no|
|max\_request\_body\_size\_in\_kb|The maximum request body size in KB for the policy.|`number`|`128`|no|
|file\_upload\_limit\_in\_mb|The maximum file upload size in MB for the policy.|`number`|`100`|no|
|managed\_rule\_sets|A mapping of managed rule set types and versions to associate with the policy.|`list(object({}))`|n/a|yes|
|managed\_rule\_exclusions|A mapping of managed rule exclusions to associate with the policy.|`list(object({}))`|`[]`|no|

The `managed_rule_sets` supports the following:

| Name | Description | Type | Default | Required |
| ---- | ----------- | :--: | :-----: | :------: |
|type|The rule set type. Possible values: `Microsoft_BotManagerRuleSet`, `Microsoft_DefaultRuleSet` and `OWASP`.|`string`|n/a|yes|
|version|The rule set version. Possible values: `0.1`, `1.0`, `2.1`, `3.0`, `3.1` and `3.2`.|`string`|n/a|yes|

The `managed_rule_exclusions` supports the following:

| Name | Description | Type | Default | Required |
| ---- | ----------- | :--: | :-----: | :------: |
|match\_variable|The name of the Match Variable. Possible values: `RequestArgKeys`, `RequestArgNames`, `RequestArgValues`, `RequestCookieKeys`, `RequestCookieNames`, `RequestCookieValues`, `RequestHeaderKeys`, `RequestHeaderNames` and `RequestHeaderValues`.|`string`|n/a|yes|
|selector\_match\_operator|Describes operator to be matched. Possible values: `Contains`, `EndsWith`, `Equals`, `EqualsAny` and `StartsWith`.|`string`|n/a|yes|
|selector|Describes field of the matchVariable collection.|`string`|n/a|yes|
|rule\_set|The rule set to be excluded.|`object({})`|`null`|no|

The `managed_rule_exclusions.rule_set` supports the following:

| Name | Description | Type | Default | Required |
| ---- | ----------- | :--: | :-----: | :------: |
|type|The rule set type. The only possible value include `Microsoft_DefaultRuleSet` and `OWASP`.|`string`|n/a|yes|
|rule\_groups|The rule groups to exclude from the rule set.|`list(object({})`|`[]`|no|

The `managed_rule_exclusions.rule_set.rule_groups` supports the following:

| Name | Description | Type | Default | Required |
| ---- | ----------- | :--: | :-----: | :------: |
|rule\_group\_name| The name of the Rule Group. Possible values are `BadBots`, `crs_20_protocol_violations`, `crs_21_protocol_anomalies`, `crs_23_request_limits`, `crs_30_http_policy`, `crs_35_bad_robots`, `crs_40_generic_attacks`, `crs_41_sql_injection_attacks`, `crs_41_xss_attacks`, `crs_42_tight_security`, `crs_45_trojans`, `crs_49_inbound_blocking`, `General`, `GoodBots`, `KnownBadBots`, `Known-CVEs`, `REQUEST-911-METHOD-ENFORCEMENT`, `REQUEST-913-SCANNER-DETECTION`, `REQUEST-920-PROTOCOL-ENFORCEMENT`, `REQUEST-921-PROTOCOL-ATTACK`, `REQUEST-930-APPLICATION-ATTACK-LFI`, `REQUEST-931-APPLICATION-ATTACK-RFI`, `REQUEST-932-APPLICATION-ATTACK-RCE`, `REQUEST-933-APPLICATION-ATTACK-PHP`, `REQUEST-941-APPLICATION-ATTACK-XSS`, `REQUEST-942-APPLICATION-ATTACK-SQLI`, `REQUEST-943-APPLICATION-ATTACK-SESSION-FIXATION`, `REQUEST-944-APPLICATION-ATTACK-JAVA`, `UnknownBots`, `METHOD-ENFORCEMENT`, `PROTOCOL-ENFORCEMENT`, `PROTOCOL-ATTACK`, `LFI`, `RFI`, `RCE`, `PHP`, `NODEJS`, `XSS`, `SQLI`, `FIX`, `JAVA`, `MS-ThreatIntel-WebShells`, `MS-ThreatIntel-AppSec`, `MS-ThreatIntel-SQLI`, `MS-ThreatIntel-CVEs`, `MS-ThreatIntel-AppSec`, `MS-ThreatIntel-SQLI` and `MS-ThreatIntel-CVEs`.|`string`|n/a|yes|
|excluded\_rules|One or more Rule IDs for exclusion.|`list(number)`|`[]`|no|

## :arrow_backward: Outputs

The following outputs are exported:

| Name | Description | Sensitive |
| ---- | ----------- | :-------: |
|id|The ID of Application Gateway Firewall Policy.|no|
<!-- END_TF_DOCS -->
