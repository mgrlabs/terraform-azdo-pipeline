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

variable "data_factory_name" {
  type        = string
  description = "The name given to the ADF resource."
}

variable "rbac_object_ids" {
  type        = list(any)
  description = "List of Azure AD Object IDs to assign to each service based on the role mappings."
}

variable "uai_principal_id" {
  type        = string
  description = "The Principal ID of the User Assigned Identity, used for Pod identity"
}