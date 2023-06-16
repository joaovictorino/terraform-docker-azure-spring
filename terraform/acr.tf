resource "azurerm_container_registry" "acr-aula-spring" {
  name                = "acraulaspring"
  resource_group_name = azurerm_resource_group.rg-aula-spring.name
  location            = azurerm_resource_group.rg-aula-spring.location
  sku                 = "Basic"
  admin_enabled       = true
}
