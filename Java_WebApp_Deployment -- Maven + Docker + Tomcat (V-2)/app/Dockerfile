FROM maven:3.9.6-eclipse-temurin-8

WORKDIR /app

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src

# Use ARG to inject version
ARG BUILD_TAG=default

RUN mvn clean package && \
    mv target/application.war target/application##${BUILD_TAG}.war