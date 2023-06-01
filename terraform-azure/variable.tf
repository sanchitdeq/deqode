variable "subscription_id" {
  type = string
  }

  variable "client_id" {
  type = string
  }

variable "client_secret" {
  type = string
  }

  variable "tenant_id" {
  type = string
  }



variable "location" {
 // default = "East US"
  type = string   
}

variable "resource_group_name" {
  type = string
}

variable "cluster_name" {
  type = string   
}

# variable "storage_name" {
#    type = string
# }


variable "dns_prefix" {
  default = "aksdemo"
}


variable "node_count" {
  default = "2"
}

variable "instance_type" {
  default = "Standard_DS2_v2"
}

variable "azurerm_virtual_network" {
  default = "aks-vn"
}