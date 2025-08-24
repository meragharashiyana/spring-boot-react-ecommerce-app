@REM Stop and delete the containers
@REM docker-compose down

@REM  Stop and delete the containers
docker-compose stop 

@REM Deleting network if available
docker network rm spring-cloud-microservices

@REM Creating network for services
docker network create spring-cloud-microservices

@REM Increasing default HTTP Timeout from 60 to 300
set COMPOSE_HTTP_TIMEOUT=300

@REM Start all services in background with -d flag
docker-compose up --build
