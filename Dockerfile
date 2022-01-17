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
FROM alpine:3
#FROM --platform=linux/amd64 amazonlinux:2  # pin current version - safer than 'latest' which may upgrade and break build unexpectedly

ARG NAME_VERSION

ENV PATH $PATH:/NAME/bin

# stops Python generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE 1

# flush stdout immediately for more real-time container logging
ENV PYTHONUNBUFFERED 1

LABEL Description="NAME" \
      "NAME Version"="$NAME_VERSION" \
      org.opencontainers.image.description="NAME" \
      org.opencontainers.image.version="$NAME_VERSION" \
      org.opencontainers.image.authors="Hari Sekhon (https://www.linkedin.com/in/HariSekhon)" \
      org.opencontainers.image.url="https://ghcr.io/HariSekhon/REPO" \
      org.opencontainers.image.source="https://github.com/HariSekhon/REPO"
      # on GHCR the image source label links to the GitHub repo so it appears in repo's packages and uses its README - then set the package to public

WORKDIR /

# Alpine / sh
#SHELL ["/bin/sh", "-eux", "-c"]
#
SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

#COPY NAME.repo /etc/yum.repos.d

# ============================================================================ #
#                       GitHub Incremental Update Pattern
# ============================================================================ #

# Hari: good for incremental builds from GitHub

#COPY build.sh /
ADD https://raw.githubusercontent.com/HariSekhon/DevOps-Bash-tools/master/setup/docker_bootstrap.sh /build.sh

RUN chmod +x /build.sh && /build.sh

# Cache Bust upon new commits
ADD https://api.github.com/repos/HariSekhon/DevOps-Python-tools/git/refs/heads/master /.git-hashref

# 2nd run is almost a noop without cache, and only an incremental update upon cache bust
RUN /build.sh

# ============================================================================ #

# ===============
# Alpine
RUN set -eux && \
    apk add --no-cache bash git make

RUN apk add --no-cache curl wget && \
    wget ... && \
    curl -sS https://raw.githubusercontent.com/HariSekhon/DevOps-Bash-tools/master/clean_caches.sh | sh && \
    apk del curl wget && \
    rm -fr /etc/apk/cache /var/cache/apk

# ===============
# CentOS
#RUN curl http://URL/NAME.repo /etc/yum.repos.d/NAME.repo && \
RUN yum install -y curl && \
    curl -sS https://raw.githubusercontent.com/HariSekhon/DevOps-Bash-tools/master/clean_caches.sh | sh && \
    yum remove -y curl && \
    yum autoremove -y && \
    yum clean all && \
    rm -rf /var/cache/yum  # to also free up space taken by orphaned data from disabled or removed repos

# ===============
# Debian / Ubuntu
RUN apt-get update && \
    apt-get install -y curl --no-install-recommends && \
    curl -sS https://raw.githubusercontent.com/HariSekhon/DevOps-Bash-tools/master/clean_caches.sh | sh && \
    apt-get purge -y curl && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -fr /var/cache/apt/* /var/lib/apt/lists/* \

COPY --from=aquasec/trivy:latest /usr/local/bin/trivy /usr/local/bin/trivy
RUN trivy rootfs --no-progress / && rm /usr/local/bin/trivy  # checks everything on the filesystem, catching intermediate image vulnerabilities

COPY file.txt /file.txt
EXPOSE 8080

#CMD "shell command"
CMD ["/some/command","arg1"]
ENTRYPOINT ["/entrypoint.sh"]

#ADD http://date.jsontest.com /etc/builddate
#ADD http://worldclockapi.com/api/json/utc/now /etc/builddate

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
