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

resource "azurerm_container_group" "example" {
  name                = "aulainfraacg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  ip_address_type     = "public"
  dns_name_label      = "aulainfraacg"
  os_type             = "Linux"

  image_registry_credential {
    server = azurerm_container_registry.acr.login_server
    username = azurerm_container_registry.acr.admin_username
    password = azurerm_container_registry.acr.admin_password
  }

  container {
    name   = "mysqldb"
    image  = "mysql:8.0"
    cpu    = "0.5"
    memory = "1.5"

    ports {
      port     = 3306
      protocol = "TCP"
    }

    environment_variables = {
      "MYSQL_ROOT_PASSWORD" = "root"
      "MYSQL_DATABASE" = "petclinic"
    }
  }

  container {
    name   = "springapp"
    image  = "auladockeracr.azurecr.io/springapp"
    cpu    = "0.5"
    memory = "1.5"
    
    ports {
      port     = 8080
      protocol = "TCP"
    }
  }

  container {
    name    = "aci--dns--sidecar"
    image   = "docker/aci-hostnames-sidecar:1.0"
    cpu     = "0.5"
    memory  = "0.5"
    
    commands = [ "/hosts", "mysqldb", "springapp" ] 
  }

  depends_on = [
    azurerm_container_registry.acr,
    null_resource.upload_image
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