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

resource "azapi_resource" "app-aula-spring" {
  type      = "Microsoft.App/containerapps@2022-03-01"
  name      = "app-aula-spring"
  parent_id = azurerm_resource_group.rg-aula-spring.id
  location  = azurerm_resource_group.rg-aula-spring.location

  body = jsonencode({
    properties = {
      managedEnvironmentId = azurerm_container_app_environment.app-env-aula-spring.id
      configuration = {
        activeRevisionsMode = "Multiple"
        ingress = {
          external      = true
          allowInsecure = true
          targetPort    = 80
          traffic = [
            {
              latestRevision = true
              weight         = 100
            }
          ]
        }
        registries = [
          {
            server            = azurerm_container_registry.acr-aula-spring.login_server
            username          = azurerm_container_registry.acr-aula-spring.admin_username
            passwordSecretRef = "container-registry-password"
          }
        ]
        secrets = [
          {
            name  = "container-registry-password"
            value = azurerm_container_registry.acr-aula-spring.admin_password
          }
        ]
      }
      template = {
        containers = [
          {
            image = "acraulaspring.azurecr.io/springapp:latest"
            name  = "springapp"
            resources = {
              cpu    = 1
              memory = "2Gi"
            }
            env = [
              {
                name  = "MYSQL_URL"
                value = "jdbc:mysql://srv-db-aula-spring.mysql.database.azure.com:3306/db-aula-spring?useSSL=true"
              },
              {
                name  = "MYSQL_USER"
                value = "mysqladminun"
              },
              {
                name  = "MYSQL_PASS"
                value = "easytologin4once!"
              }
            ]
          }
        ]
        scale = {
          minReplicas = 1
          maxReplicas = 4
        }
      }
    }
  })
}

#resource "azurerm_container_app" "app-aula-spring" {
#  name                         = "app-aula-spring"
#  container_app_environment_id = azurerm_container_app_environment.app-env-aula-spring.id
#  resource_group_name          = azurerm_resource_group.rg-aula-spring.name
#  revision_mode                = "Single"
# 
#  identity {
#    type         = "UserAssigned"
#    identity_ids = [azurerm_user_assigned_identity.app-user-aula-spring.id]
#  }
# 
#  registry {
#    server   = azurerm_container_registry.acr-aula-spring.login_server
#    identity = azurerm_user_assigned_identity.app-user-aula-spring.id
#  }
#
#  ingress {
#    allow_insecure_connections = true
#    fqdn = "app-aula-spring"
#    external_enabled           = true
#    target_port                = 80
#
#    traffic_weight{
#      latest_revision = true
#      percentage = 100
#    }
#  }
#
#  template {
#    min_replicas = 1
#    max_replicas = 4
#    container {
#      name   = "springapp"
#      image  = "acraulaspring.azurecr.io/springapp:latest"
#      cpu    = 1
#      memory = "2Gi"
#
#      env {
#        name = "MYSQL_URL"
#        value = "jdbc:mysql://srv-db-aula-spring.mysql.database.azure.com:3306/db-aula-spring?useSSL=true"
#      }
#
#      env {
#        name = "MYSQL_USER"
#        value = "mysqladminun"
#      }
#
#      env {
#        name = "MYSQL_PASS"
#        value = "easytologin4once!"
#      }
#    }
#  }
#}

