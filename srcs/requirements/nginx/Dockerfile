FROM alpine:3.22.2

RUN apk add --no-cache sed wget nginx

COPY --chmod=755 ./tools/nginx_entrypoint.sh /usr/local/bin/nginx_entrypoint.sh
COPY --chmod=644 ./tools/owowow-cert.pem /etc/ssl/certs/owowow-cert.pem
COPY --chmod=640 ./tools/owowow-private.key /etc/ssl/private/owowow-private.key

HEALTHCHECK --interval=10s --timeout=3s --retries=3 --start-period=30s \
  CMD wget --no-check-certificate -qO /dev/null https://vsanin.42.fr || exit 1

ENTRYPOINT [ "/usr/local/bin/nginx_entrypoint.sh" ]