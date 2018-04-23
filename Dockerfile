FROM golang:alpine as builder

RUN apk --no-cache add curl git make perl gcc libc-dev
COPY . /go/src/github.com/larseen/pgbouncer_exporter
RUN go get -u github.com/kardianos/govendor
RUN cd /go/src/github.com/larseen/pgbouncer_exporter && govendor sync
RUN cd /go/src/github.com/larseen/pgbouncer_exporter && make

FROM alpine:3.4

EXPOSE 9127

COPY --from=builder /go/src/github.com/larseen/pgbouncer_exporter/pgbouncer_exporter /pgbouncer_exporter

ENTRYPOINT [ "/pgbouncer_exporter" ]
