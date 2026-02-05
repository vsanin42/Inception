FROM alpine:3.22.2

RUN apk add --no-cache nginx

COPY ./tools /usr/local/bin

RUN chmod 755 -R /usr/local/bin

# HEALTHCHECK

ENTRYPOINT [ "/usr/local/bin/nginx_entrypoint.sh" ]