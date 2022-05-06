# Terraform ambiente PaaS no Azure, usando MySQL e Azure Container Instances

Pré-requisitos
- Az-cli instalado
- Terraform instalado

Logar no Azure via az-cli, o navegador será aberto para que o login seja feito
````sh
az login
````

Inicializar o Terraform
````sh
terraform init
````

Compilar a imagem Dockerfile localmente
````sh
docker build -t springapp .
````

Renomear a imagem
````sh
docker tag springapp:latest auladockeracr.azurecr.io/springapp:latest
````

Executar o Terraform
````sh
terraform apply -auto-approve
````

Logar no Registry do Azure
````sh
az acr login --name auladockeracr
````

Subir a imagem no Registry do Azure
````sh
docker push auladockeracr.azurecr.io/springapp:latest
````

Acessar a aplicação
````sh
curl http://aulainfraacg.eastus.azurecontainer.io:8080
````
