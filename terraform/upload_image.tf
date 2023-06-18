resource "null_resource" "upload_image" {
  triggers = {
    order = azurerm_container_registry.acr-aula-spring.id
  }
  provisioner "local-exec" {
    command = "az acr login --name acraulaspring && docker push acraulaspring.azurecr.io/springapp:latest && sleep 20"
  }
}
