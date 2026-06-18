FROM alpine:3.20

RUN apk add --no-cache openssl

COPY docker/certificates/scripts/generate-certificates.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
