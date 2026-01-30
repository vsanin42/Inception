FROM alpine:3.22.2

# --no-cache - problematic or not?
RUN apk add --no-cache mariadb mariadb-client

# copies and sets permissions on all files in tools folder
COPY ./tools /usr/local/bin

# remove skip networking to allow port connections + make scripts executable + change config
RUN sed -i '/^[[:space:]]*skip-networking[[:space:]]*$/d' /etc/my.cnf.d/mariadb-server.cnf && \
    chmod 755 -R /usr/local/bin && \
    printf '%s\n' \
    '[mysqld]' \
    'bind-address=0.0.0.0' \
    'port=3306' \
    > /etc/my.cnf.d/99-docker.cnf

# healthcheck
HEALTHCHECK --interval=10s --timeout=5s --retries=5 --start-period=30s \
  CMD mariadb-admin ping --socket=/run/mysqld/mysqld.sock -uroot -p"$DB_ROOTPASS" >/dev/null 2>&1 || exit 1

ENTRYPOINT [ "/usr/local/bin/mariadb_entrypoint.sh" ]