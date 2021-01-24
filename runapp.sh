docker network create petclinic
docker run -d --name=mysqldb --network=petclinic --env="MYSQL_ROOT_PASSWORD=root" --env="MYSQL_PASSWORD=root" --env="MYSQL_DATABASE=petclinic" mysql:8.0
docker build -t springapp ./springapp
docker exec -i mysqldb mysql -uroot -proot petclinic < ../mysql/user.sql
docker exec -i mysqldb mysql -uroot -proot petclinic < ../mysql/schema.sql
docker exec -i mysqldb mysql -uroot -proot petclinic < ../mysql/data.sql
docker run -t --network=petclinic -p 8080:8080 springapp:latest