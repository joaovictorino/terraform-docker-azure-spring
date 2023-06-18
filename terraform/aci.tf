resource "azurerm_container_group" "aci-aula-spring" {
  name                = "aciaulaspring"
  location            = azurerm_resource_group.rg-aula-spring.location
  resource_group_name = azurerm_resource_group.rg-aula-spring.name
  ip_address_type     = "Public"
  dns_name_label      = "aciaulaspring"
  os_type             = "Linux"

  image_registry_credential {
    server   = azurerm_container_registry.acr-aula-spring.login_server
    username = azurerm_container_registry.acr-aula-spring.admin_username
    password = azurerm_container_registry.acr-aula-spring.admin_password
  }

  container {
    name   = "springapp"
    image  = "acraulaspring.azurecr.io/springapp:latest"
    cpu    = "1"
    memory = "2"

    ports {
      port     = 80
      protocol = "TCP"
    }

    environment_variables = {
      "MYSQL_URL"  = "jdbc:mysql://srv-db-aula-spring.mysql.database.azure.com:3306/db-aula-spring?useSSL=true"
      "MYSQL_USER" = "mysqladminun"
      "MYSQL_PASS" = "easytologin4once!"
    }

  }

  depends_on = [
    azurerm_container_registry.acr-aula-spring,
    azurerm_mysql_flexible_database.db-aula-spring,
    null_resource.upload_image,
  ]
}
