terraform {
  required_version = ">= 0.13"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  skip_provider_registration = true
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "eastus"
}

resource "azurerm_container_registry" "acr" {
  name                     = "auladockeracr"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  sku                      = "Basic"
  admin_enabled            = true

  depends_on = [
    azurerm_resource_group.example
  ]
}

resource "azurerm_mysql_server" "example" {
  name                = "tflab-mysqlserver-1-teste"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "8.0"

  administrator_login          = "mysqladminun"
  administrator_login_password = "easytologin4once!"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

resource "azurerm_mysql_database" "example" {
  name                = "exampledb"
  resource_group_name = azurerm_resource_group.example.name
  server_name         = azurerm_mysql_server.example.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_mysql_configuration" "example" {
  name                = "time_zone"
  resource_group_name = azurerm_resource_group.example.name
  server_name         = azurerm_mysql_server.example.name
  value               = "-03:00"
}

resource "azurerm_mysql_firewall_rule" "example" {
  name                = "azure_internal"
  resource_group_name = azurerm_resource_group.example.name
  server_name         = azurerm_mysql_server.example.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_container_group" "example" {
  name                = "aulainfraacg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  ip_address_type     = "Public"
  dns_name_label      = "aulainfraacg"
  os_type             = "Linux"

  image_registry_credential {
    server = azurerm_container_registry.acr.login_server
    username = azurerm_container_registry.acr.admin_username
    password = azurerm_container_registry.acr.admin_password
  }

  container {
    name   = "springapp"
    image  = "auladockeracr.azurecr.io/springapp:latest"
    cpu    = "0.5"
    memory = "1.5"
    
    ports {
      port     = 8080
      protocol = "TCP"
    }

    environment_variables = {
      "MYSQL_URL" = "jdbc:mysql://tflab-mysqlserver-1-teste.mysql.database.azure.com:3306/exampledb?useSSL=true&requireSSL=false"
      "MYSQL_USER" = "mysqladminun@tflab-mysqlserver-1-teste.mysql.database.azure.com"
      "MYSQL_PASS" = "easytologin4once!"
    }

  }

  depends_on = [
    azurerm_container_registry.acr,
    null_resource.upload_image,
    azurerm_mysql_database.example
  ]
}

resource "null_resource" "upload_image" {
    triggers = {
        order = azurerm_container_registry.acr.id
    }
    provisioner "local-exec" {
      command = "az acr login --name auladockeracr && docker push auladockeracr.azurecr.io/springapp:latest && sleep 20"
    }
}