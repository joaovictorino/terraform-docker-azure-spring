output "address_containerapps" {
  value = "https://app-aula-spring.${azurerm_container_app_environment.app-env-aula-spring.default_domain}"
}