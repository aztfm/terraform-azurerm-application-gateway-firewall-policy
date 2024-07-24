variable "name" {
  type        = string
  description = "The name of the Application Gateway Firewall Policy."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the Application Gateway Firewall Policy."
}

variable "location" {
  type        = string
  description = "The location/region where the Application Gateway Firewall Policy is created."
}

variable "tags" {
  type        = map(string)
  default     = null
  description = "A mapping of tags to assign to the resource."
}

variable "managed_rule_sets" {
  type = list(object({
    type    = string
    version = string
  }))
  description = "A mapping of managed rule set types and versions to associate with the policy."

  validation {
    condition     = alltrue([for rule in var.managed_rule_sets : contains(["OWASP", "Microsoft_DefaultRuleSet", "Microsoft_BotManagerRuleSet"], rule.type)])
    error_message = "All managed rules types must be OWASP, Microsoft_DefaultRuleSet or Microsoft_BotManagerRuleSet."
  }

  validation {
    condition     = alltrue([for rule in var.managed_rule_sets : rule.type != "OWASP" || contains(["3.0", "3.1", "3.2"], rule.version)])
    error_message = "If the managed rule set type is OWASP, the version must be 3.0, 3.1 or 3.2."
  }

  validation {
    condition     = alltrue([for rule in var.managed_rule_sets : rule.type != "Microsoft_DefaultRuleSet" || rule.version == "2.1"])
    error_message = "If the managed rule set type is Microsoft_DefaultRuleSet, the version must be 2.1."
  }

  validation {
    condition     = alltrue([for rule in var.managed_rule_sets : rule.type != "Microsoft_BotManagerRuleSet" || contains(["0.1", "1.0"], rule.version)])
    error_message = "If the managed rule set type is Microsoft_BotManagerRuleSet, the version must be 0.1 or 1.0."
  }

  validation {
    condition     = anytrue([for rule in var.managed_rule_sets : contains(["OWASP", "Microsoft_DefaultRuleSet"], rule.type)])
    error_message = "At least one managed rule set type must be OWASP or Microsoft_DefaultRuleSet."
  }

  validation {
    condition     = length([for rule in var.managed_rule_sets : rule.type if rule.type == "OWASP" || rule.type == "Microsoft_DefaultRuleSet"]) <= 1
    error_message = "There can only be one rule of type OWASP or Microsoft_DefaultRuleSet."
  }

  validation {
    condition     = length([for rule in var.managed_rule_sets : rule.type]) == length(distinct([for rule in var.managed_rule_sets : rule.type]))
    error_message = "There can only be one rule of each type."
  }
}
