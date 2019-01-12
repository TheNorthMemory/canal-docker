FROM openjdk:8-jdk-alpine

ARG CANAL_RELEASE="https://github.com/alibaba/canal/releases/download"
ARG CANAL_VERSION="1.1.2"

LABEL maintainer="James Zhang <thenorthmemory@dingtalk.com>" canal_version="${CANAL_VERSION}"

ENV LANG=en_US.UTF-8 \
  CLASSPATH=./conf:./lib:./conf/*:./lib/*:$CLASSPATH \
  CANAL_RELEASE="${CANAL_RELEASE}" \
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

RUN set -ex \
  && { \
    echo '#!/bin/sh'; \
    echo ''; \
    echo 'case ${@} in'; \
    echo '  -a | -adapter | adapter)'; \
    echo '    exec java com.alibaba.otter.canal.adapter.launcher.CanalAdapterApplication'; \
    echo '  ;;'; \
    echo '  -d | -deployer | deployer)'; \
    echo '    exec java com.alibaba.otter.canal.deployer.CanalLauncher'; \
    echo '  ;;'; \
    echo '  -v | -version | version)'; \
    echo '    echo "canal version: ${CANAL_VERSION} on java-${JAVA_VERSION}"'; \
    echo '  ;;'; \
    echo '  *)'; \
    echo '    echo "usage: [[-][[a]dapter]|[[d]eployer]|[[v]ersion]]"'; \
    echo '    echo ""'; \
    echo '    echo "  adapter: launch the canal adapter, the workdir must be located in /alibaba/canal-adapter"'; \
    echo '    echo "  deployer: launch the canal deployer, the workdir must be located in /alibaba/canal-deployer"'; \
    echo '    echo "  version: display this build version"'; \
    echo '    echo ""'; \
    echo '    echo "shown this usage manual default"'; \
    echo '  ;;'; \
    echo 'esac'; \
  } > /alibaba/canal \
  && chmod +x /alibaba/canal \
  && /alibaba/canal version && /alibaba/canal help

ENTRYPOINT ["/alibaba/canal"]

EXPOSE 11111 11112 8081

STOPSIGNAL SIGQUIT
