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
  description = "The environment in which the resource would be created in/associated with."
}

variable "random_name_suffix" {
  type        = string
  description = "Random character string unique for each environment"
}

variable "storage_account_id" {
  type        = string
  description = "(Required) Specifies the id of the storage account id where the storage queue is located."
}

variable "storage_account_queue_name" {
  type        = string
  description = "(Required) Specifies the name of the storage queue where the Event Subscription will receive events."
}