#!/bin/bash

docker build -t springapp .

docker tag springapp:latest acraulaspring.azurecr.io/springapp:latest

cd terraform

terraform init

terraform apply -auto-approve
