FROM        sdurrheimer/alpine-glibc
MAINTAINER  The Prometheus Authors <prometheus-developers@googlegroups.com>

WORKDIR /gopath/src/github.com/prometheus/alertmanager
COPY    . /gopath/src/github.com/prometheus/alertmanager

RUN apk add --update -t build-deps tar openssl git make bash \
    && source ./scripts/goenv.sh /go /gopath \
    && CGO_ENABLED=0 make build \
    && cp alertmanager /bin/ \
    && mkdir -p /etc/alertmanager/template \
    && mv ./doc/examples/simple.yml /etc/alertmanager/config.yml \
    && apk del --purge build-deps \
    && rm -rf /go /gopath /var/cache/apk/*

EXPOSE     9093
VOLUME     [ "/alertmanager" ]
WORKDIR    /alertmanager
ENTRYPOINT [ "/bin/alertmanager" ]
CMD        [ "-config.file=/etc/alertmanager/config.yml", \
             "-storage.path=/alertmanager" ]
