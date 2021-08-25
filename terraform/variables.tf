# Azure common variables
variable "resource_group_name" {
  type        = string
  default     = "ACME-TEST-ADF-RG"
  description = "(Required) The name of the resource group the resources will be deployed into. Changing this forces a new resource to be created."
}

variable "location" {
  type        = string
  default     = "australiaeast"
  description = "(Required) Specifies the supported Azure location where the resource exists. Changing this forces a new resource to be created."
}

variable "environment" {
  type        = string
  default     = "dev"
  description = "The environment in which the resources will be associated with."
}

variable "subscription_id" {
  type        = string
  default     = "623aabe5-748d-4b15-be89-3119e247a9fd"
  description = "Subscription ID hosting the environment to deploy the resources into."
}

variable "aks_cluster_object_id" {
  type        = string
  default     = null
  description = "Object ID of the SPN used for the environment-specific AKS Cluster for UAI"
}

variable "rbac_object_ids" {
  type        = list(any)
  description = "description"
}

# Private Link Variables
variable "private_link_vnet_name" {
  type        = string
  description = "description"
}

variable "private_link_vnet_resource_group_name" {
  type        = string
  description = "description"
}

variable "private_link_vnet_subnet_name" {
  type        = string
  description = "description"
}
