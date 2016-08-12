FROM centos:centos7

MAINTAINER Aaron Weitekamp <aweiteka@redhat.com> Lindani Phiri <lphiri@redhat.com>

RUN echo -e "[epel]\nname=epel\nenabled=1\nbaseurl=https://dl.fedoraproject.org/pub/epel/7/x86_64/\ngpgcheck=0" > /etc/yum.repos.d/epel.repo

RUN yum install -y --setopt=tsflags=nodocs npm && \
    yum clean all

WORKDIR /opt/dockerfile_lint
ADD . .
RUN npm install && \
    ln -s /opt/dockerfile_lint/bin/dockerfile_lint /usr/bin/dockerfile_lint

WORKDIR /root/
LABEL RUN docker run -it --rm --privileged -v `pwd`:/root/ -v /var/run/docker.sock:/var/run/docker.sock --name NAME -e NAME=NAME -e IMAGE=IMAGE IMAGE dockerfile_lint

ENTRYPOINT ["dockerfile_lint", "-f", "/root/scan/Dockerfile", "-r", "/opt/dockerfile_lint/config/default_rules.yaml"]
