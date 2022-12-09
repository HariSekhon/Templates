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

# ============================================================================ #
#                              D o c k e r f i l e
# ============================================================================ #

# https://docs.docker.com/engine/reference/builder/
#
# https://docs.docker.com/develop/develop-images/dockerfile_best-practices/
#
# https://docs.docker.com/develop/dev-best-practices/

# Put steps with more variability as far down as you can to avoid cache bust on layers that don't change much

#FROM scatch
#FROM busybox:latest
#FROM ubuntu:20.04
#FROM debian:10  # aka buster
#FROM centos:8
# nosemgrep: dockerfile.audit.dockerfile-source-not-pinned.dockerfile-source-not-pinned
FROM alpine:3
#FROM --platform=linux/amd64 amazonlinux:2  # pin current version - safer than 'latest' which may upgrade and break build unexpectedly

# Catch Errors Early in RUN commands
#
# Alpine / sh
#SHELL ["/bin/sh", "-eux", "-c"]
#
SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

# put ENV/ARGs that may change as far down as you can as they can break your Docker layer caching from this point onwards
ARG NAME_VERSION

ENV PATH $PATH:/NAME/bin

ENV PYTHONPATH /app

# stops Python generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE 1

# flush stdout immediately for more real-time container logging
ENV PYTHONUNBUFFERED 1

LABEL org.opencontainers.image.description="NAME" \
      org.opencontainers.image.version="$NAME_VERSION" \
      org.opencontainers.image.authors="Hari Sekhon (https://www.linkedin.com/in/HariSekhon)" \
      org.opencontainers.image.url="https://ghcr.io/HariSekhon/REPO" \
      org.opencontainers.image.documentation="https://hub.docker.com/r/harisekhon/REPO" \
      org.opencontainers.image.source="https://github.com/HariSekhon/Dockerfiles"
      # on GHCR the image source label links to the GitHub repo so it appears in repo's packages and uses its README - then set the package to public
      # otherwise set it to DockerHub, must be lowercase or will get a 404 error
      #org.opencontainers.image.url="https://hub.docker.com/r/harisekhon/REPO" \

WORKDIR /

#COPY NAME.repo /etc/yum.repos.d


# ============================================================================ #
#                             O S   P a c k a g e s
# ============================================================================ #
#
# Install Packages for your OS as high up as you can to CACHE them and skip these steps in future
#
# ===============
# Alpine
RUN apk add --no-cache bash git make

RUN apk add --no-cache curl && \
    curl -sS https://raw.githubusercontent.com/HariSekhon/DevOps-Bash-tools/master/clean_caches.sh | sh && \
    apk del curl && \
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


# ============================================================================ #
#               P y t h o n   +   A W S   C o d e A r t i f a c t
# ============================================================================ #

# ARG changes BREAK CACHE for everything below
#
# Generated externally in CI/CD system and passed to docker as a --build-arg - this ARG BREAKS CACHE for everything below
#
# XXX: to minimize cache-busting on same day, regenerate this once every 12 hours (max token life) and insert into a CI/CD secret to reuse between workflow runs eg.
#
#   https://github.com/HariSekhon/GitHub-Actions/blob/master/.github/workflows/codeartifact_secret.yaml
#
ARG CODARTIFACT_AUTH_TOKEN

# Python Install Dependencies from AWS CodeArtifact
#
# don't bother with virtualenv in docker
RUN poetry config http-basic.MYREPO aws "$CODEARTIFACT_AUTH_TOKEN" && \
    poetry config virtualenvs.create false && \
    poetry install --no-root "${NO_DEV:+--no-dev}"
    #if [ "${NO_DEV:-}" = 'true' ]; then \
    #    poetry install --no-root --no-dev; \
    #else \
    #    poetry install --no-root; \
    #fi


# ============================================================================ #
#       G i t H u b   I n c r e m e n t a l   U p d a t e   P a t t e r n
# ============================================================================ #

# Hari: good for incremental builds from GitHub repos

#COPY build.sh /
# need ADD tpo source latest boostrap from github
# nosemgrep: dockerfile.best-practice.prefer-copy-over-add.prefer-copy-over-add
ADD https://raw.githubusercontent.com/HariSekhon/DevOps-Bash-tools/master/setup/docker_bootstrap.sh /build.sh

RUN chmod +x /build.sh && /build.sh

# Cache Bust upon new commits
# nosemgrep: dockerfile.best-practice.prefer-copy-over-add.prefer-copy-over-add
ADD https://api.github.com/repos/HariSekhon/DevOps-Python-tools/git/refs/heads/master /.git-hashref

# 2nd run is almost a noop without cache, and only an incremental update upon cache bust
RUN /build.sh

# ============================================================================ #
#                  C a c h e   B u s t   O n c e   a   W e e k
# ============================================================================ #

# Wrap your docker build in a Makefile or CI/CD step which does
#
#   date '+%W' > week_of_year.txt
#
# before the docker build step and then do this to have the cache break once a week:
COPY week_of_year.txt /etc/

# ============================================================================ #

# false positive: COPY --from should reference a previously defined FROM alias
# hadolint ignore=DL3022
COPY --from=aquasec/trivy:latest /usr/local/bin/trivy /usr/local/bin/trivy
RUN trivy rootfs --no-progress / && rm /usr/local/bin/trivy  # checks everything on the filesystem, catching intermediate image vulnerabilities

COPY file.txt /file.txt

EXPOSE 8080

# XXX: create this and set permissions in prior RUN step
USER myuser

HEALTHCHECK --interval=10s --timeout=10s --start-period=10s --retries=3 CMD ["curl", "-f", "http://localhost/"]

#CMD "shell command"
CMD ["/some/command","arg1"]
ENTRYPOINT ["/entrypoint.sh"]

#ADD http://date.jsontest.com /etc/builddate
#ADD http://worldclockapi.com/api/json/utc/now /etc/builddate


# ============================================================================ #
#                  G o l a n g   B u i l d e r   P a t t e r n
# ============================================================================ #

# nosemgrep: dockerfile.audit.dockerfile-source-not-pinned.dockerfile-source-not-pinned
FROM golang:1.15 as builder

COPY main.go .

# `skaffold debug` sets SKAFFOLD_GO_GCFLAGS to disable compiler optimizations
ARG SKAFFOLD_GO_GCFLAGS

RUN go build -gcflags="${SKAFFOLD_GO_GCFLAGS}" -o /app main.go

# ============
#FROM alpine:3
# workaround for : https://github.com/returntocorp/semgrep/issues/5315
# nosemgrep: dockerfile.best-practice.missing-image-version.missing-image-version
FROM scratch
# or distroless - https://github.com/GoogleContainerTools/distroless
FROM gcr.io/distroless/base-debian10

COPY --from=builder /app .
#COPY --from=build /app/bin/main /

# Define GOTRACEBACK to mark this container as using the Go language runtime
# for `skaffold debug` (https://skaffold.dev/docs/workflows/debug/)
ENV GOTRACEBACK=single

CMD ["/app"]
#CMD ["/main"]
