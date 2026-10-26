FROM alpine/minio:RELEASE.2025-10-15T17-29-55Z@sha256:cf23643a6cf9ce159c57643ceb88279e431262282428c9e0bf3a7ef1a97e84b4

ARG TARGETARCH

USER root

RUN wget -q -O /usr/local/bin/mc \
    "https://github.com/minio/mc/releases/download/RELEASE.2025-08-13T08-35-41Z/mc.linux-${TARGETARCH}.RELEASE.2025-08-13T08-35-41Z" \
    && chmod +x /usr/local/bin/mc

WORKDIR /usr/local/bin/

COPY docker/minio/scripts/entrypoint.sh .

RUN chmod +x entrypoint.sh

USER minio

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["server", "/data", "--console-address", ":9001"]
