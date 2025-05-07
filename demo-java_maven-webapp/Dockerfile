# -----------------------------
# Stage 1: Build WAR with Maven
# -----------------------------
FROM maven:3.9.6-eclipse-temurin-21 AS builder

WORKDIR /app

# Copy and prepare Maven dependencies
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source and build
COPY src ./src
RUN mvn clean package

# ----------------------------------
# Stage 2: Setup Tomcat + Deploy WAR
# ----------------------------------
FROM eclipse-temurin:21-jdk

# Accept external build tag for renaming WAR
ARG BUILD_TAG=default
ENV BUILD_TAG=${BUILD_TAG}

# Set environment variables
ENV TOMCAT_VERSION=8.5.100
ENV TOMCAT_PORT=8080
ENV CATALINA_HOME=/usr/share/tomcat-${TOMCAT_VERSION}-${TOMCAT_PORT}
ENV PATH=$CATALINA_HOME/bin:$PATH

WORKDIR /usr/local/src/

# Download and extract Tomcat
RUN curl -fSL https://archive.apache.org/dist/tomcat/tomcat-8/v${TOMCAT_VERSION}/bin/apache-tomcat-${TOMCAT_VERSION}.tar.gz -o tomcat.tar.gz && \
    mkdir -p $CATALINA_HOME && \
    tar -xvzf tomcat.tar.gz --strip-components=1 -C $CATALINA_HOME && \
    rm tomcat.tar.gz

# Configure Tomcat admin user
RUN echo '<?xml version="1.0" encoding="UTF-8"?>\
<tomcat-users xmlns="http://tomcat.apache.org/xml"\
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"\
              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"\
              version="1.0">\
  <role rolename="manager-gui"/>\
  <user username="admin" password="1234" roles="manager-gui,manager-script,manager-jmx,manager-status"/>\
</tomcat-users>' > $CATALINA_HOME/conf/tomcat-users.xml

# Disable IP restriction for manager and host-manager
RUN sed -i 's/<Valve/\<!-- <Valve/' $CATALINA_HOME/webapps/manager/META-INF/context.xml && \
    sed -i 's@/>@/> -->@' $CATALINA_HOME/webapps/manager/META-INF/context.xml && \
    sed -i 's/<Valve/\<!-- <Valve/' $CATALINA_HOME/webapps/host-manager/META-INF/context.xml && \
    sed -i 's@/>@/> -->@' $CATALINA_HOME/webapps/host-manager/META-INF/context.xml

# Clean default apps
RUN rm -rf $CATALINA_HOME/webapps/docs \
           $CATALINA_HOME/webapps/examples \
           $CATALINA_HOME/webapps/ROOT

# Copy and rename WAR from builder
COPY --from=builder /app/target/application.war /tmp/

# Rename dynamically using BUILD_TAG
RUN bash -c 'mv /tmp/application.war $CATALINA_HOME/webapps/application##${BUILD_TAG}.war'

# Expose port
EXPOSE 8080

# Healthcheck for Tomcat app context
HEALTHCHECK CMD curl --fail http://localhost:8080/application/ || exit 1

# Start Tomcat
CMD ["catalina.sh", "run"]