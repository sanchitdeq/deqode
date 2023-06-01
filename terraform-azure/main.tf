# ##############################################################
# # AZURE Cluster Creating
# ##############################################################

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"

    }
  }
  backend "azurerm" {}
      
}

provider "azurerm" {
  features {}
    
      subscription_id = var.subscription_id
      client_id = var.client_id
      client_secret = var.client_secret
      tenant_id = var.tenant_id
      

}  
resource "azurerm_resource_group" "k8s" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "k8svirtual" {
  name = var.azurerm_virtual_network
  depends_on = [ azurerm_resource_group.k8s ]
  location = var.location
  address_space = ["192.168.4.0/24"]
  resource_group_name = azurerm_resource_group.k8s.name
  tags =  {
    Environment = "production"
  }
  
  
}

resource "azurerm_subnet" "k8ssubnet" {
  name = "akssubnet"
  resource_group_name = azurerm_resource_group.k8s.name
  address_prefixes = ["192.168.4.0/24"]
  virtual_network_name = azurerm_virtual_network.k8svirtual.name
  depends_on = [ azurerm_resource_group.k8s , azurerm_virtual_network.k8svirtual ]

}



resource "random_id" "id" {
	  byte_length = 8

}

resource "azurerm_kubernetes_cluster_node_pool" "k8s_nodepool" {
  name                  = "internal"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.k8s.id
  vm_size               = "Standard_DS2_v2"
  node_count            = 1
  vnet_subnet_id = azurerm_subnet.k8ssubnet.id
  

  
  
  tags = {
    Environment = "Production"
  }
}


resource "azurerm_kubernetes_cluster" "k8s" { 
  name                = var.cluster_name

  depends_on = [ azurerm_resource_group.k8s, azurerm_virtual_network.k8svirtual , azurerm_subnet.k8ssubnet ]
  resource_group_name = azurerm_resource_group.k8s.name
  location            = azurerm_resource_group.k8s.location
  dns_prefix          = var.dns_prefix
  
  default_node_pool {
    name       = "default"
    node_count = var.node_count
    vm_size    = var.instance_type
    vnet_subnet_id = azurerm_subnet.k8ssubnet.id

  }




 identity {
    type = "SystemAssigned"
  }

  tags = {
    Environment = "production"
  }
}





resource "azurerm_storage_account" "cbstorage" {
  name                     = "storage${random_id.id.hex}"
  resource_group_name      = azurerm_resource_group.k8s.name
  location                 = azurerm_resource_group.k8s.location
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  account_replication_type = "LRS"
  depends_on               = [azurerm_resource_group.k8s, azurerm_kubernetes_cluster.k8s]

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_share" "cbshare" {
  name                 = "cbshare"
  storage_account_name = azurerm_storage_account.cbstorage.name
  depends_on = [ azurerm_storage_account.cbstorage ]
  quota = 4
}


# ##############################################################
# # END
# ##############################################################
