#  vim:ts=4:sts=4:sw=4:et
#
#  Author: Hari Sekhon
#  Date: [% DATE # 2015-10-25 20:50:22 +0000 (Sun, 25 Oct 2015) %]
#
#  [% URL %]
#
#  [% MESSAGE %]
#
#  [% LINKEDIN %]
#

#FROM scatch
#FROM busybox:latest
#FROM ubuntu:20.04
#FROM debian:10  # aka buster
#FROM centos:8
FROM alpine:latest
#FROM --platform=linux/amd64 amazonlinux:2  # pin current version - safer than 'latest' which may upgrade and break build unexpectedly
MAINTAINER Hari Sekhon (https://www.linkedin.com/in/harisekhon)

ARG NAME_VERSION

ENV PATH $PATH:/NAME/bin

# stops Python generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE 1

# flush stdout immediately for more real-time container logging
ENV PYTHONUNBUFFERED 1

LABEL Description="NAME", \
      "NAME Version"="$NAME_VERSION"

WORKDIR /

#COPY NAME.repo /etc/yum.repos.d

# ===============
# Alpine
RUN set -eux && \
    apk add --no-cache bash git make

RUN bash -c ' \
    set -euxo pipefail && \
    apk add --no-cache curl wget && \
    wget ... && \
    curl -sS https://raw.githubusercontent.com/HariSekhon/DevOps-Bash-tools/master/clean_caches.sh | sh && \
    apk del curl wget && \
    rm -fr /etc/apk/cache /var/cache/apk
    '

# ===============
# CentOS
#RUN curl http://URL/NAME.repo /etc/yum.repos.d/NAME.repo && \
RUN set -euxo pipefail && \
    yum install -y curl && \
    curl -sS https://raw.githubusercontent.com/HariSekhon/DevOps-Bash-tools/master/clean_caches.sh | sh && \
    yum remove -y curl && \
    yum autoremove -y && \
    yum clean all && \
    rm -rf /var/cache/yum  # to also free up space taken by orphaned data from disabled or removed repos

# ===============
# Debian / Ubuntu
RUN bash -c ' \
    set -euxo pipefail && \
    apt-get update && \
    apt-get install -y curl && \
    curl -sS https://raw.githubusercontent.com/HariSekhon/DevOps-Bash-tools/master/clean_caches.sh | sh && \
    apt-get purge -y curl && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -fr /var/cache/apt /var/lib/apt/lists \
    '


COPY file.txt /file.txt
EXPOSE 8080

CMD ["/some/command","arg1"]
CMD "shell command"
ENTRYPOINT ["/entrypoint.sh"]

# ============================================================================ #
#                             Golang Builder Pattern
# ============================================================================ #

FROM golang:1.15 as builder

COPY main.go .

# `skaffold debug` sets SKAFFOLD_GO_GCFLAGS to disable compiler optimizations
ARG SKAFFOLD_GO_GCFLAGS

RUN go build -gcflags="${SKAFFOLD_GO_GCFLAGS}" -o /app main.go

# ============
#FROM alpine:3
FROM scratch

COPY --from=builder /app .

# Define GOTRACEBACK to mark this container as using the Go language runtime
# for `skaffold debug` (https://skaffold.dev/docs/workflows/debug/)
ENV GOTRACEBACK=single

CMD ["./app"]
