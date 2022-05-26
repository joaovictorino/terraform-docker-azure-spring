#!/bin/bash

docker build -t springapp .

docker tag springapp:latest auladockeracr.azurecr.io/springapp:latest

cd terraform

terraform init -upgrade

terraform apply -auto-approve

#curl http://aulainfraacg.eastus.azurecontainer.io:8080