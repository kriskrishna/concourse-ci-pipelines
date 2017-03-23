FROM       art-phx-prod02.vmpc1.cloud.boeing.com:5000/openjdk:8
MAINTAINER David A. Ibanez <david.a.ibanez@boeing.com>

ARG GRADLE_VERSION=3.2.1

WORKDIR /usr/bin
RUN curl -sLO java.web.boeing.com/artifactory/ProgrammingLanguages/Gradle/${GRADLE_VERSION}/all/gradle-${GRADLE_VERSION}-all.zip && \
  unzip gradle-${GRADLE_VERSION}-all.zip && \
  ln -s gradle-${GRADLE_VERSION} gradle && \
  rm gradle-${GRADLE_VERSION}-all.zip

COPY ./cacerts /etc/ssl/certs/java

ENV GRADLE_HOME /usr/bin/gradle
ENV PATH $PATH:$GRADLE_HOME/bin
