locals {
  name_suffix   = "acme${var.environment}${local.location_abbr}${var.random_name_suffix}"
  location_abbr = local.location_map[var.location]
  location_map = {
    australiaeast      = "aue"
    australiasoutheast = "aus"
  }
  topic_type = "Microsoft.Storage.StorageAccounts"
  event_types = [
    "Microsoft.Storage.BlobCreated"
  ]
}

##################################
# Event Grid
##################################

resource "azurerm_eventgrid_system_topic" "acme" {
  name                   = "evgt-${local.name_suffix}"
  resource_group_name    = var.resource_group_name
  location               = var.location
  source_arm_resource_id = var.storage_account_id
  topic_type             = local.topic_type

  tags = var.tags
}

resource "azurerm_eventgrid_system_topic_event_subscription" "acme" {
  name                = "evgs-${local.name_suffix}"
  system_topic        = azurerm_eventgrid_system_topic.acme.name
  resource_group_name = var.resource_group_name

  storage_queue_endpoint {
    storage_account_id = var.storage_account_id
    queue_name         = var.storage_account_queue_name
  }

  included_event_types = local.event_types

  subject_filter {
    subject_begins_with = "/blobServices/default/containers/inbox/"
  }
}