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
#FROM ubuntu:14.04
#FROM debian:jessie
#FROM centos:6
FROM alpine:latest
MAINTAINER Hari Sekhon (https://www.linkedin.com/in/harisekhon)

ARG NAME_VERSION

ENV PATH $PATH:/NAME/bin

LABEL Description="NAME", \
      "NAME Version"="$NAME_VERSION"

WORKDIR /

#COPY NAME.repo /etc/yum.repos.d

RUN \
    apk add --no-cache bash git make

RUN \
    apk add --no-cache wget && \
    wget ...
    apk del wget

#RUN curl http://URL/NAME.repo /etc/yum.repos.d/NAME.repo && \
RUN \
    yum install -y && \
    yum remove -y && \
    yum autoremove -y && \
    yum clean all

RUN \
    apt-get update && \
    apt-get install -y && \
    apt-get purge -y && \
    apt-get autoremove -y && \
    apt-get clean

COPY file.txt /file.txt
EXPOSE 8080

CMD ["/some/command","arg1"]
CMD "shell command"
ENTRYPOINT ["/entrypoint.sh"]
