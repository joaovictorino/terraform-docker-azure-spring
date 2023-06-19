# Terraform ambiente PaaS no Azure, usando MySQL, Azure Container Instances e Azure Container Apps

Pré-requisitos

- Az-cli instalado
- Terraform instalado

Logar no Azure via az-cli, o navegador será aberto para que o login seja feito

```sh
az login
```

Inicializar o Terraform

```sh
terraform init
```

Compilar a imagem Dockerfile localmente

```sh
docker build -t springapp .
```

Renomear a imagem

```sh
docker tag springapp:latest acraulaspring.azurecr.io/springapp:latest
```

Executar o Terraform

```sh
terraform apply -auto-approve
```
