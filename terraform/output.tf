output "address_containerapps" {
  value = "https://app-aula-spring.${azurerm_container_app_environment.app-env-aula-spring.default_domain}"
}

output "address_aci" {
  value = "http://${azurerm_container_group.aci-aula-spring.fqdn}:8080"
}
