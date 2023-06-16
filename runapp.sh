docker network create petclinic
docker run -d --name=mysqldb --network=petclinic --env="MYSQL_ROOT_PASSWORD=root" --env="MYSQL_PASSWORD=root" --env="MYSQL_DATABASE=petclinic" mysql:8.0
docker build -t springapp ./springapp
docker run -t --network=petclinic -p 80:80 springapp:latest
