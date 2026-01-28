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