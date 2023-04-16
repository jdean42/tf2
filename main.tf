locals {
  resource_group_name="app-grp"
  location="UK South"
}
  resource "azurerm_resource_group" "appgrp" {
  name     = local.resource_group_name
  location = local.location  
}

resource "azurerm_storage_account" "appstorex" {
  count = 3 
  name                     = "appstore${count.index}x351967"
  resource_group_name     = local.resource_group_name
  location 					= local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"
  depends_on = [
    azurerm_resource_group.appgrp
  ]
}

#using count
resource "azurerm_storage_container" "store0containers" {
  count=3
  name                  = "data${count.index}"
  storage_account_name  = "appstore0x351967"
  container_access_type = "blob"
  depends_on = [   azurerm_storage_account.appstorex  ]
  
}


#using for_each set
resource "azurerm_storage_container" "store1containers" {
  for_each = toset(["sample1tom","sample2dick","sample3harry"])
  name                  = each.key
  storage_account_name  = "appstore1x351967"
  container_access_type = "blob"
  depends_on = [   azurerm_storage_account.appstorex  ]
  
}

#using for_each using map, this uses key value pairs
resource "azurerm_storage_container" "store2containers" {
  for_each = {sample1="tom",sample2="dick",sample3="harry"}
  name                  = "${each.key}${each.value}"
  storage_account_name  = "appstore2x351967"
  container_access_type = "blob"
  depends_on = [   azurerm_storage_account.appstorex  ]
  
}