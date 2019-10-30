FROM golang:1.11 AS build

COPY go.mod /src/
COPY go.sum /src/
COPY pause.go /src/

WORKDIR /src

RUN set -eux \
	&& env CGO_ENABLED=0 go build -a \
	&& strip -s pause \
	&& ls -l /src/

FROM alpine:3.8

RUN set -eux \
	&& apk add --no-cache \
	bind-tools \
	busybox-extras \
	curl \
	iputils \
	netcat-openbsd \
	openssh-client \
	procps \
	tcpdump

COPY --from=build /src/pause /sbin/pause

ENTRYPOINT ["/sbin/pause"]
