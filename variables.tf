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
  default     = {}
  description = "A mapping of tags to assign to the resource."
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Describes if the policy is in enabled state or disabled state."
}

variable "mode" {
  type        = string
  default     = "Prevention"
  description = "Describes if it is in detection mode or prevention mode at the policy level. Valid values are `Detection` and `Prevention`."

  validation {
    condition     = contains(["Detection", "Prevention"], var.mode)
    error_message = "The mode must be either Detection or Prevention."
  }
}

variable "request_body_inspect_limit_in_kb" {
  type        = number
  default     = 128
  description = "The maximum request body inspection size in KB for the policy."

  validation {
    condition     = var.request_body_inspect_limit_in_kb >= 8 && var.request_body_inspect_limit_in_kb <= 2000
    error_message = "The request body inspection limit must be between 8 and 2000 KB."
  }
}

variable "max_request_body_size_in_kb" {
  type        = number
  default     = 128
  description = "The maximum request body size in KB for the policy."

  validation {
    condition     = var.max_request_body_size_in_kb >= 8 && var.max_request_body_size_in_kb <= 2000
    error_message = "The request body size must be between 8 and 2000 KB."
  }
}

variable "file_upload_limit_in_mb" {
  type        = number
  default     = 100
  description = "The maximum file upload size in MB for the policy."

  validation {
    condition     = var.file_upload_limit_in_mb >= 1 && var.file_upload_limit_in_mb <= 4000
    error_message = "The file upload limit must be between 1 and 4000 MB."
  }
}

variable "managed_rule_sets" {
  type = list(object({
    type    = string
    version = string
  }))
  description = "A mapping of managed rule set types and versions to associate with the policy."

  validation {
    condition     = alltrue([for rule in var.managed_rule_sets : contains(["OWASP", "Microsoft_DefaultRuleSet", "Microsoft_BotManagerRuleSet"], rule.type)])
    error_message = "All managed rule set types must be OWASP, Microsoft_DefaultRuleSet or Microsoft_BotManagerRuleSet."
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

variable "managed_rule_exclusions" {
  type = list(object({
    match_variable          = string
    selector_match_operator = string
    selector                = string
    rule_set = optional(object({
      type = string
      rule_groups = optional(list(object({
        rule_group_name = string
        excluded_rules  = list(number)
      })), [])
    }))
  }))
  default     = []
  description = "A mapping of managed rule exclusions to associate with the policy."

  validation {
    condition = alltrue([for exclusion in var.managed_rule_exclusions : contains([
      "RequestArgKeys", "RequestArgNames", "RequestArgValues",
      "RequestCookieKeys", "RequestCookieNames", "RequestCookieValues",
      "RequestHeaderKeys", "RequestHeaderNames", "RequestHeaderValues"
    ], exclusion.match_variable)])
    error_message = "All managed rule exclusion match variables must be RequestArgKeys, RequestArgNames, RequestArgValues, RequestCookieKeys, RequestCookieNames, RequestCookieValues, RequestHeaderKeys, RequestHeaderNames or RequestHeaderValues."
  }

  validation {
    condition     = alltrue([for exclusion in var.managed_rule_exclusions : contains(["Contains", "EndsWith", "Equals", "EqualsAny", "StartsWith"], exclusion.selector_match_operator)])
    error_message = "All managed rule exclusion selector match operators must be Contains, EndsWith, Equals, EqualsAny or StartsWith."
  }

  validation {
    condition     = alltrue([for exclusion in var.managed_rule_exclusions : contains(["OWASP", "Microsoft_DefaultRuleSet"], exclusion.rule_set.type) if exclusion.rule_set != null])
    error_message = "All managed rule exclusion rule set types must be OWASP or Microsoft_DefaultRuleSet."
  }

  validation {
    condition = alltrue([for exclusion in var.managed_rule_exclusions :
      alltrue([for rule_group in exclusion.rule_set.rule_groups :
        contains([
          "BadBots", "crs_20_protocol_violations", "crs_21_protocol_anomalies", "crs_23_request_limits", "crs_30_http_policy", "crs_35_bad_robots",
          "crs_40_generic_attacks", "crs_41_sql_injection_attacks", "crs_41_xss_attacks", "crs_42_tight_security", "crs_45_trojans", "crs_49_inbound_blocking",
          "General", "GoodBots", "KnownBadBots", "Known-CVEs", "REQUEST-911-METHOD-ENFORCEMENT", "REQUEST-913-SCANNER-DETECTION", "REQUEST-920-PROTOCOL-ENFORCEMENT",
          "REQUEST-921-PROTOCOL-ATTACK", "REQUEST-930-APPLICATION-ATTACK-LFI", "REQUEST-931-APPLICATION-ATTACK-RFI", "REQUEST-932-APPLICATION-ATTACK-RCE",
          "REQUEST-933-APPLICATION-ATTACK-PHP", "REQUEST-941-APPLICATION-ATTACK-XSS", "REQUEST-942-APPLICATION-ATTACK-SQLI", "REQUEST-943-APPLICATION-ATTACK-SESSION-FIXATION",
          "REQUEST-944-APPLICATION-ATTACK-JAVA", "UnknownBots", "METHOD-ENFORCEMENT", "PROTOCOL-ENFORCEMENT", "PROTOCOL-ATTACK", "LFI", "RFI", "RCE", "PHP", "NODEJS", "XSS",
          "SQLI", "FIX", "JAVA", "MS-ThreatIntel-WebShells", "MS-ThreatIntel-AppSec", "MS-ThreatIntel-SQLI", "MS-ThreatIntel-CVEs", "MS-ThreatIntel-AppSec", "MS-ThreatIntel-SQLI",
          "MS-ThreatIntel-CVEs"
        ], rule_group.rule_group_name)
    ]) if exclusion.rule_set != null])
    error_message = "All managed rule exclusion rule group names must be BadBots, crs_20_protocol_violations, crs_21_protocol_anomalies, crs_23_request_limits, crs_30_http_policy, crs_35_bad_robots, crs_40_generic_attacks, crs_41_sql_injection_attacks, crs_41_xss_attacks, crs_42_tight_security, crs_45_trojans, crs_49_inbound_blocking, General, GoodBots, KnownBadBots, Known-CVEs, REQUEST-911-METHOD-ENFORCEMENT, REQUEST-913-SCANNER-DETECTION, REQUEST-920-PROTOCOL-ENFORCEMENT, REQUEST-921-PROTOCOL-ATTACK, REQUEST-930-APPLICATION-ATTACK-LFI, REQUEST-931-APPLICATION-ATTACK-RFI, REQUEST-932-APPLICATION-ATTACK-RCE, REQUEST-933-APPLICATION-ATTACK-PHP, REQUEST-941-APPLICATION-ATTACK-XSS, REQUEST-942-APPLICATION-ATTACK-SQLI, REQUEST-943-APPLICATION-ATTACK-SESSION-FIXATION, REQUEST-944-APPLICATION-ATTACK-JAVA, UnknownBots, METHOD-ENFORCEMENT, PROTOCOL-ENFORCEMENT, PROTOCOL-ATTACK, LFI, RFI, RCE, PHP, NODEJS, XSS, SQLI, FIX, JAVA, MS-ThreatIntel-WebShells, MS-ThreatIntel-AppSec, MS-ThreatIntel-SQLI, MS-ThreatIntel-CVEs, MS-ThreatIntel-AppSec, MS-ThreatIntel-SQLI and MS-ThreatIntel-CVEs"
  }

  validation {
    condition = alltrue([for exclusion in var.managed_rule_exclusions :
      alltrue([for rule_group in exclusion.rule_set.rule_groups :
        alltrue([for rule in rule_group.excluded_rules :
          can(regex("^[0-9]{6}$", tonumber(rule)))
        ])
      ]) if exclusion.rule_set != null]
    )
    error_message = "All managed rule exclusion rules must be 6-digit numbers."
  }
}
