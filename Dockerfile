FROM openjdk:8-jdk-alpine

ARG CANAL_VERSION="1.1.2"

LABEL maintainer="James Zhang <thenorthmemory@dingtalk.com>" canal_version="${CANAL_VERSION}"

ENV LANG=en_US.UTF-8 \
  CLASSPATH=./conf:./lib:./conf/*:./lib/*:$CLASSPATH \
  CANAL_RELEASE=https://github.com/alibaba/canal/releases/download \
  CANAL_VERSION="${CANAL_VERSION}"

RUN set -ex \
  && mkdir -p /alibaba/canal-adapter \
  && wget ${CANAL_RELEASE}/canal-${CANAL_VERSION}/canal.adapter-${CANAL_VERSION/-*/-SNAPSHOT}.tar.gz -O- | tar -xzvC /alibaba/canal-adapter \
  && echo "canal.adapter-${CANAL_VERSION} downloaded!" \
  && mkdir -p /alibaba/canal-deployer \
  && wget ${CANAL_RELEASE}/canal-${CANAL_VERSION}/canal.deployer-${CANAL_VERSION/-*/-SNAPSHOT}.tar.gz -O- | tar -xzvC /alibaba/canal-deployer \
  && sed -i 's@\(<appender-ref\s*ref\s*=\)"\(.*\)"\s*\(/>\)@\1"STDOUT"\3@' /alibaba/canal-deployer/conf/logback.xml \
  && sed -i '$!N;/^\(.*\)\n\1$/!P;D' /alibaba/canal-deployer/conf/logback.xml \
  && echo "canal.deployer-${CANAL_VERSION} downloaded!"

EXPOSE 11111 11112 8081

STOPSIGNAL SIGQUIT
