# Inception

## Commands

*docker build -t mariadb .* - build a named docker image

*docker run -it --rm <image>/mariadb sh* - drop into shell before container is created

*docker exec -it <container> sh* - drop into shell after container is created and running

*docker run -d --name mariadb -p 3306:3306 mariadb* - run as container in background once ready

*docker logs -f mariadb* - logs

*docker rm -f mariadb* - remove container, rmi = remove image

*docker image prune* - remove all dangling images. If -a is specified, also remove all images not referenced by any container

conditional only if folder is not initialized - first run.
## mariadb-install-db --user=mysql --datadir=/var/lib/mysql

## mkdir -p /run/mysqld
## chown -R mysql:mysql /run/mysqld
## chmod 755 /run/mysqld
entrypoint:
## mariadbd --user=mysql


**add to services depending on mariadb health**
depends_on:
  mariadb:
    condition: service_healthy


## docker compose up
Start all services defined in docker-compose.yml in the foreground (logs attached).

## docker compose up -d
Start all services in detached (background) mode.

## docker compose up --build
Force rebuild of images before starting containers.

## docker compose down
Stop and remove containers and networks created by Compose (keeps volumes).

## docker compose down -v
Stop and remove containers, networks, and named volumes (destroys persistent data).

## docker compose ps
Show the status of services (running, exited, unhealthy, ports).

## docker compose logs
Show logs from all services.

## docker compose logs -f
Follow logs in real time.

## docker compose logs -f mariadb
Follow logs only for the mariadb service.

## docker compose exec mariadb sh
Open a shell inside the running mariadb container.

## docker compose exec mariadb mariadb -u root -p
Connect to the MariaDB server from inside the container.

## docker compose run mariadb sh
Start a one-off mariadb container and open a shell (not the running one).

## docker compose build
Build or rebuild images without starting containers.

## docker compose config
Print the fully resolved and validated Compose configuration.

## docker compose stop
Stop running containers without removing them.

## docker compose start
Start previously stopped containers.

## docker volume ls
List all Docker volumes on the system.

## docker volume inspect db-volume
Show details about the named volume db-volume.

## docker volume rm db-volume
Remove the named volume db-volume (permanently deletes data).

## docker compose ls
List Compose projects and their current status.
