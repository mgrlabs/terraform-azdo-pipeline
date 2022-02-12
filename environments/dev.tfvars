# Common variables
resource_group_name = "RG_INTEGRATION_XXXX_CORE_DEV_AUE"
location            = "australiaeast"
environment         = "dev"
subscription_id     = "xxxx"

# Private Link variables
private_link_vnet_name                = "VNET_INTE_PRIVATE_NONPROD_AUE"
private_link_vnet_resource_group_name = "RG_CSVC_BASE_PRIVATE_NONPROD_AUE"
private_link_vnet_subnet_name         = "SUBNET_INTEGRATION_XXXX_PRIVATELINK_DEV_AUE"

# AKS Cluster SPN Object ID used to assign rights for Pod Identity
aks_cluster_object_id = "xxxx"

# Used to Assign RBAC to the various resources used for the solution
rbac_object_ids = [
  "xxxx", # ACME-CloudNonProdAdmin
]
