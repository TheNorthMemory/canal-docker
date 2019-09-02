FROM maven:3.6.1-jdk-8-alpine as builder

ARG GIT_SOURCE_REPO="https://github.com/alibaba/canal.git"
ARG GIT_SOURCE_BRANCH="master"

WORKDIR /canal

RUN set -ex \
  && apk --no-cache add git \
  && git clone --branch ${GIT_SOURCE_BRANCH} --depth 1 --single-branch ${GIT_SOURCE_REPO} /canal \
  && ls -al . \
  && dos2unix \
      ./pom.xml \
      ./deployer/pom.xml \
      ./deployer/src/main/assembly/release.xml \
      ./deployer/src/main/resources/logback.xml \
      ./client-adapter/launcher/pom.xml \
      ./client-adapter/launcher/src/main/assembly/release.xml \
      ./client-adapter/launcher/src/main/resources/logback.xml \
  && { \
    echo '#!/bin/sh'; \
    echo ''; \
    echo 'JAVA_OPTS_EXT="-Djava.awt.headless=true -Djava.net.preferIPv4Stack=true -Dfile.encoding=UTF-8"'; \
    echo 'case ${@} in'; \
    echo '  -a | a | -adapter | adapter)'; \
    echo '    exec java ${JAVA_OPTS} ${JAVA_OPTS_EXT} com.alibaba.otter.canal.adapter.launcher.CanalAdapterApplication'; \
    echo '  ;;'; \
    echo '  -d | d | -deployer | deployer)'; \
    echo '    exec java ${JAVA_OPTS} ${JAVA_OPTS_EXT} com.alibaba.otter.canal.deployer.CanalLauncher'; \
    echo '  ;;'; \
    echo '  -v | v | -version | version)'; \
    echo '    echo "canal version: ${CANAL_VERSION} on java-${JAVA_VERSION}"'; \
    echo '  ;;'; \
    echo '  *)'; \
    echo '    echo "usage: [[-][a[dapter]]|[d[eployer]]|[v[ersion]]]"'; \
    echo '    echo ""'; \
    echo '    echo "  adapter: launch the canal adapter, the workdir must be located in /alibaba/canal-adapter"'; \
    echo '    echo "  deployer: launch the canal deployer, the workdir must be located in /alibaba/canal-deployer"'; \
    echo '    echo "  version: display this build version"'; \
    echo '    echo ""'; \
    echo '    echo "shown this usage manual default"'; \
    echo '  ;;'; \
    echo 'esac'; \
  } > ./canal \
  && chmod +x ./canal \
  && export VERSION=`grep -m1 -E '<version>.*</version>' ./pom.xml | sed 's@.*>\(.*\)<.*@\1@'` \
  && export REVISION=`git --git-dir=./.git rev-parse --short --verify HEAD` \
  && sed -i -e "s@\${CANAL_VERSION}@${VERSION} ${REVISION}@" \
      ./canal \
  && sed -i -e '/<module>example<\/module>$/d;/<module>canal-admin<\/module>$/d' \
      ./pom.xml \
  && sed -i -e 's@<finalName>.*</finalName>@<finalName>canal-deployer</finalName>@' \
      ./deployer/pom.xml \
  && sed -i -e 's@<format>tar.gz</format>@<format>dir</format>@' \
      ./deployer/src/main/assembly/release.xml \
  && sed -i -e 's@<finalName>.*</finalName>@<finalName>canal-adapter</finalName>@' \
      ./client-adapter/launcher/pom.xml \
  && sed -i -e 's@<format>tar.gz</format>@<format>dir</format>@' \
      ./client-adapter/launcher/src/main/assembly/release.xml \
  && sed -i -e 's@\(<appender-ref\s*ref\s*=\)"\(.*\)"\s*\(/>\)@\1"STDOUT"\3@' \
      ./deployer/src/main/resources/logback.xml \
      ./client-adapter/launcher/src/main/resources/logback.xml \
  && sed -i -e '$!N;/^\(.*\)\n\1$/!P;D' \
      ./deployer/src/main/resources/logback.xml \
      ./client-adapter/launcher/src/main/resources/logback.xml \
  && mvn clean package -Dmaven.test.skip=true -Dmaven.javadoc.skip=true -Denv=release

FROM openjdk:8-jdk-alpine

ARG GIT_SOURCE_REPO="https://github.com/alibaba/canal.git"
ARG GIT_SOURCE_BRANCH="master"

LABEL maintainer="James Zhang <thenorthmemory@dingtalk.com>" \
  canal_git_repo="${GIT_SOURCE_REPO}" \
  canal_git_branch="${GIT_SOURCE_BRANCH}"

ENV LANG=en_US.UTF-8 \
  CLASSPATH=./conf:./lib:./conf/*:./lib/*:$CLASSPATH \
  CANAL_GIT_REPO=${GIT_SOURCE_REPO} \
  CANAL_GIT_BRANCH=${GIT_SOURCE_BRANCH}

COPY --from=builder /canal/canal /canal/LICENSE.txt /canal/RELEASE.txt /canal/README.md /alibaba/
COPY --from=builder /canal/target/canal-deployer /alibaba/canal-deployer/
COPY --from=builder /canal/target/canal-adapter /alibaba/canal-adapter/

ENTRYPOINT ["/alibaba/canal"]

#11111=canal-deployer;11112=metrics;8081=canal-adapter
EXPOSE 11111 11112 8081
