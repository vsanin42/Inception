FROM alpine:3.22.2

RUN apk add --no-cache mariadb mariadb-client

# copies and sets permissions on all files in tools folder
COPY ./tools /usr/local/bin
RUN chmod 755 -R /usr/local/bin

ENTRYPOINT [ "/usr/local/bin/mariadb_entrypoint.sh" ]