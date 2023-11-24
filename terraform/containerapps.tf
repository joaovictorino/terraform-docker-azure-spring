resource "azurerm_log_analytics_workspace" "log-aula-spring" {
  name                = "log-aula-spring"
  location            = azurerm_resource_group.rg-aula-spring.location
  resource_group_name = azurerm_resource_group.rg-aula-spring.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "app-env-aula-spring" {
  name                       = "appenv-aula-spring"
  location                   = azurerm_resource_group.rg-aula-spring.location
  resource_group_name        = azurerm_resource_group.rg-aula-spring.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.log-aula-spring.id
}

resource "azurerm_container_app" "app-aula-spring" {
  name                         = "app-aula-spring"
  container_app_environment_id = azurerm_container_app_environment.app-env-aula-spring.id
  resource_group_name          = azurerm_resource_group.rg-aula-spring.name
  revision_mode                = "Single"

  ingress {
    external_enabled           = true
    allow_insecure_connections = true
    target_port                = 80
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  registry {
    server               = azurerm_container_registry.acr-aula-spring.login_server
    username             = azurerm_container_registry.acr-aula-spring.admin_username
    password_secret_name = "container-registry-password"
  }

  secret {
    name  = "container-registry-password"
    value = azurerm_container_registry.acr-aula-spring.admin_password
  }

  template {
    container {
      name   = "springapp"
      image  = "acraulaspring.azurecr.io/springapp:latest"
      cpu    = 1
      memory = "2Gi"

      env {
        name  = "MYSQL_URL"
        value = "jdbc:mysql://srv-db-aula-spring.mysql.database.azure.com:3306/db-aula-spring?useSSL=true"
      }

      env {
        name  = "MYSQL_USER"
        value = "mysqladminun"
      }

      env {
        name  = "MYSQL_PASS"
        value = "easytologin4once!"
      }
    }
    min_replicas = 1
    max_replicas = 4
  }


  depends_on = [
    azurerm_container_registry.acr-aula-spring,
    azurerm_mysql_flexible_database.db-aula-spring,
    null_resource.upload_image,
  ]
}