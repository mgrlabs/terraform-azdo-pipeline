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

variable "environment" {
  type        = string
  default     = "sandbox"
  description = "description"
}

variable "random_name_suffix" {
  type        = string
  description = "description"
}

variable "rbac_object_ids" {
  type        = list(any)
  description = "List of Azure AD Object IDs to assign to each service based on the role mappings."
}

variable "uai_principal_id" {
  type        = string
  description = "The Principal ID of the User Assigned Identity, used for Pod identity"
}

# Log Analytics variables

variable "log_analytics_workspace_retention" {
  type        = string
  default     = "90"
  description = "(Optional) The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730."
}

variable "splunk_hec_uri" {
  type        = string
  description = "Splunk HEC Webhook URI to send the alert payload to."
}