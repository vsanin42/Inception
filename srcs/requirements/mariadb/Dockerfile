FROM alpine:3.22.2

# --no-cache - problematic or not?
RUN apk add --no-cache mariadb mariadb-client

# copies and sets permissions on all files in tools folder
COPY ./tools /usr/local/bin
RUN chmod 755 -R /usr/local/bin

HEALTHCHECK --interval=10s --timeout=5s --retries=5 --start-period=30s \
  CMD mariadb -e 'SELECT @@datadir;' || exit 1
ENTRYPOINT [ "/usr/local/bin/mariadb_entrypoint.sh" ]