FROM alpine as certs

RUN apk --update add ca-certificates

FROM gcr.io/kaniko-project/executor:v1.9.1-debug

SHELL ["/busybox/sh", "-c"]

ADD https://github.com/jqlang/jq/releases/download/jq-1.6/jq-linux64 /kaniko/jq
RUN chmod +x /kaniko/jq

ADD https://github.com/genuinetools/reg/releases/download/v0.16.1/reg-linux-386 /kaniko/reg
RUN chmod +x /kaniko/reg

ADD https://github.com/google/go-containerregistry/releases/download/v0.8.0/go-containerregistry_Linux_x86_64.tar.gz /crane.tar.gz
RUN tar -xvzf /crane.tar.gz crane -C /kaniko && \
    rm /crane.tar.gz

COPY entrypoint.sh /
COPY --from=certs /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt

ENTRYPOINT ["/entrypoint.sh"]

LABEL repository="https://github.com/aevea/action-kaniko" \
    maintainer="Alex Viscreanu <alexviscreanu@gmail.com>"
