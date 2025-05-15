# Use Alpine base with OpenJDK 8 (Java 1.8)
FROM openjdk:8-jdk-alpine

# Install necessary tools
RUN apk add --no-cache curl tar bash sed

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

# Clean default Tomcat webapps
RUN rm -rf $CATALINA_HOME/webapps/docs \
           $CATALINA_HOME/webapps/examples \
           $CATALINA_HOME/webapps/ROOT

# Expose port
EXPOSE 8080

# Start Tomcat in foreground
CMD ["catalina.sh", "run"]