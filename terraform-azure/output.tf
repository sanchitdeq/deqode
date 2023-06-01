
output "kube_config" {
  value = azurerm_kubernetes_cluster.k8s.kube_config_raw
  sensitive = true
}

output "host" {
  value = azurerm_kubernetes_cluster.k8s.kube_config.0.host
  sensitive = true
}


output "configure" {
  value =  <<CONFIGURE
}


Run the following commands to configure kubernetes client:

$ terraform output kube_config > ~/.kube/config
$ export KUBECONFIG=~/.kube/config


Test configuration using kubectl

$ kubectl get nodes
CONFIGURE
}


output "storage_account_name" {
  value = azurerm_storage_account.cbstorage.name
  sensitive = true
}

output "primary_key_details" {
  value = azurerm_storage_account.cbstorage.primary_access_key
  sensitive = true
}
