docker build -t springapp .

docker tag springapp:latest auladockeracr.azurecr.io/springapp:latest

terraform init

terraform apply