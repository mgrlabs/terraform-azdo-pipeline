# Azure common variables
variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the resource group in which to create the MySQL Server. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "tags" {
  type        = map(any)
  default     = {}
  description = "Azure resource tags to identify the resource's purpose."
}

# variable "environment" {
#   type        = string
#   description = "description"
# }

# variable "random_name_suffix" {
#   type        = string
#   description = "description"
# }

variable "rbac_object_ids" {
  type        = list(any)
  default     = null
  description = "List of Azure AD Object IDs to assign to each service based on the role mappings."
}

variable "uai_principal_id" {
  type        = string
  description = "The Principal ID of the User Assigned Identity, used for Pod identity"
}

variable "name_suffix" {
  type        = string
  description = "The convention appended to the name of a resource."
}

# Key Vault variables
variable "key_vault_enabled_for_disk_encryption" {
  type        = bool
  default     = true
  description = "(Optional) Boolean flag to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. Defaults to false."
}

variable "key_vault_soft_delete_retention_days" {
  type        = string
  default     = "7"
  description = "(Optional) The number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 (the default) days."
}

variable "key_vault_purge_protection_enabled" {
  type        = bool
  default     = false
  description = "(Optional) Is Purge Protection enabled for this Key Vault? Defaults to false."
}
