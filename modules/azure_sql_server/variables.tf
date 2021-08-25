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
  description = "description"
}

variable "random_name_suffix" {
  type        = string
  description = "description"
}

variable "esfx_service_principal_object_id" {
  type        = string
  description = "Object ID of the SPN used for acme for access to resources."
}

variable "esfx_service_principal_name" {
  type        = string
  description = "description"
}


# MSSQL Server Variables
variable "mssql_administrator_login" {
  type        = string
  description = "(Required) The administrator login name for the new server. Changing this forces a new resource to be created."
}

# variable mssql_administrator_login_password {
#   type        = string
#   description = "(Required) The password associated with the administrator_login user. Needs to comply with Azure's Password Policy"
# }

variable "mssql_version" {
  type        = string
  default     = "12.0"
  description = "(Required) The version for the new server. Valid values are: 2.0 (for v11 server) and 12.0 (for v12 server)."
}

variable "mssql_minimum_tls_version" {
  type        = string
  default     = "1.2"
  description = "(Optional) The Minimum TLS Version for all SQL Database and SQL Data Warehouse databases associated with the server. Valid values are: 1.0, 1.1 and 1.2."
}

# MSSQL Database Variables
variable "mssql_database_name" {
  type        = string
  default     = "sqldb-esfx01"
  description = "(Required) The name of the Ms SQL Database. Changing this forces a new resource to be created"
}

variable "mssql_database_collation" {
  type        = string
  default     = "SQL_Latin1_General_CP1_CI_AS"
  description = "(Optional) Specifies the collation of the database. Changing this forces a new resource to be created."
}

# variable mssql_database_license_type {
#   type        = string
#   default     = "LicenseIncluded"
#   description = "(Optional) Specifies the license type applied to this database. Possible values are LicenseIncluded and BasePrice."
# }

variable "mssql_database_max_size_gb" {
  type        = string
  default     = "1"
  description = "(Optional) The max size of the database in gigabytes."
}

variable "mssql_database_sku_name" {
  type        = string
  default     = "S3"
  description = "description"
}

