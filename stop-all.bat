@REM Stop and delete the containers
docker-compose down

@REM  Deleting network
docker network rm spring-cloud-microservices
