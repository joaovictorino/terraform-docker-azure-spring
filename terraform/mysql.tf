resource "azurerm_mysql_flexible_server" "srv-db-aula-spring" {
  name                = "srv-db-aula-spring"
  location            = azurerm_resource_group.rg-aula-spring.location
  resource_group_name = azurerm_resource_group.rg-aula-spring.name

  sku_name = "B_Standard_B1s"

  administrator_login    = "mysqladminun"
  administrator_password = "easytologin4once!"

  backup_retention_days        = 7
}

resource "azurerm_mysql_flexible_database" "db-aula-spring" {
  name                = "db-aula-spring"
  resource_group_name = azurerm_resource_group.rg-aula-spring.name
  server_name         = azurerm_mysql_flexible_server.srv-db-aula-spring.name
  charset             = "utf8mb3"
  collation           = "utf8mb3_unicode_ci"
}

resource "azurerm_mysql_flexible_server_configuration" "cfg-srv-db-aula-spring" {
  name                = "time_zone"
  resource_group_name = azurerm_resource_group.rg-aula-spring.name
  server_name         = azurerm_mysql_flexible_server.srv-db-aula-spring.name
  value               = "-03:00"
}

resource "azurerm_mysql_flexible_server_firewall_rule" "frw-srv-db-aula-spring" {
  name                = "frw-srv-db-aula-spring"
  resource_group_name = azurerm_resource_group.rg-aula-spring.name
  server_name         = azurerm_mysql_flexible_server.srv-db-aula-spring.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}
