## 1.1.0 (Unreleased)

FIXES:

- The parameters `request_body_inspect_limit_in_kb`, `max_request_body_size_in_kb` and `file_upload_limit_in_mb` are now functional.

## 1.0.0 (July 25, 2024)

FEATURES:

- **New Parameter:** `name`
- **New Parameter:** `resource_group_name`
- **New Parameter:** `location`
- **New Parameter:** `tags`
- **New Parameter:** `enabled`
- **New Parameter:** `mode`
- **New Parameter:** `request_body_inspect_limit_in_kb`
- **New Parameter:** `max_request_body_size_in_kb`
- **New Parameter:** `file_upload_limit_in_mb`
- **New Parameter:** `managed_rule_sets`
- **New Parameter:** `managed_rule_sets.type`
- **New Parameter:** `managed_rule_sets.version`
- **New Parameter:** `managed_rule_exclusions`
- **New Parameter:** `managed_rule_exclusions.match_variable`
- **New Parameter:** `managed_rule_exclusions.selector_match_operator`
- **New Parameter:** `managed_rule_exclusions.selector`
- **New Parameter:** `managed_rule_exclusions.rule_set`
- **New Parameter:** `managed_rule_exclusions.rule_set.type`
- **New Parameter:** `managed_rule_exclusions.rule_set.rule_groups`
- **New Parameter:** `managed_rule_exclusions.rule_set.rule_groups.rule_group_name`
- **New Parameter:** `managed_rule_exclusions.rule_set.rule_groups.excluded_rules`
