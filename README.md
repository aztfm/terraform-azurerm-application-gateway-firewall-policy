# Azure Application Gateway Firewall Policy - Terraform Module

[![pre-commit](https://img.shields.io/badge/pre--commit-enabled-brightgreen?logo=pre-commit)](https://github.com/pre-commit/pre-commit)
[![Terraform Registry](https://img.shields.io/badge/terraform-registry-blueviolet.svg)](https://registry.terraform.io/modules/aztfm/application-gateway-firewall-policy/azurerm/)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/aztfm/terraform-azurerm-terraform-azurerm-application-gateway-firewall-policy)

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/aztfm/terraform-azurerm-application-gateway-firewall-policy?quickstart=1)

## Version compatibility

| Module version | Terraform version | AzureRM version |
| -------------- | ----------------- | --------------- |
| >= 1.x.x       | >= 1.9.x          | >= 3.112.0      |

<!-- BEGIN_TF_DOCS -->
## Parameters

The following parameters are supported:

| Name | Description | Type | Default | Required |
| ---- | ----------- | :--: | :-----: | :------: |
|name|The name of the Application Gateway Firewall Policy.|`string`|n/a|yes|
|resource\_group\_name|The name of the resource group in which to create the Application Gateway Firewall Policy.|`string`|n/a|yes|
|location|The location/region where the Application Gateway Firewall Policy is created.|`string`|n/a|yes|
|tags|A mapping of tags to assign to the resource.|`map(string)`|`null`|no|
|managed\_rule\_sets|A mapping of managed rule set types and versions to associate with the policy.|`list(object({}))`|n/a|yes|

The `managed_rule_sets` supports the following:

| Name | Description | Type | Default | Required |
| ---- | ------------| :--: | :-----: | :------: |
|type|The rule set type. Possible values: `Microsoft_BotManagerRuleSet`, `Microsoft_DefaultRuleSet` and `OWASP`.|`string`|n/a|yes|
|version|The rule set version. Possible values: `0.1`, `1.0`, `2.1`, `3.0`, `3.1` and `3.2`.|`string`|n/a|yes|

## Outputs

The following outputs are exported:

| Name | Description | Sensitive |
| ---- | ------------| :-------: |
|id|The ID of Application Gateway Firewall Policy.|no|
<!-- END_TF_DOCS -->
