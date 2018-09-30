FROM ubuntu:xenial

RUN apt-get update && apt-get install -y openjdk-8-jdk maven zip
WORKDIR /src/agilefant
ADD . .
RUN third-party/install.sh
RUN MAVEN_OPTS="-Djava.awt.headless=true" ./build-release.sh
RUN cd distribution/target && unzip *.zip && mkdir agilefant && cd agilefant && unzip ../agilefant.war

FROM tomcat:9-jre8-slim
ENV JAVA_OPTS "-Djava.awt.headless=true -Djavax.accessibility.assistive_technologies=' ' $JAVA_OPTS"
COPY --from=0 /src/agilefant/distribution/target/agilefant /usr/local/tomcat/webapps/agilefant
RUN sed -i 's/localhost/db/g' /usr/local/tomcat/webapps/agilefant/WEB-INF/agilefant.conf

