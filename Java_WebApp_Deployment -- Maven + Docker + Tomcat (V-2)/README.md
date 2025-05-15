# 🚀 Java WebApp Deployment: Maven + Docker + Tomcat

This repository demonstrates an automated build-and-deploy pipeline for a Java servlet-based application using Docker containers. It leverages Maven to build a .war file and a custom Tomcat Docker image to deploy it.

---

### 📦 Features

 - Build Java WAR file using Dockerized Maven

 - Dynamic versioning with timestamped build tags

 - Deploy WAR into a clean, custom Tomcat 8.5.100 container

 - Full automation with a single script (WAR_BUILD.sh)

 - Environment-specific configurations via .env

---

### 📁 Project Layout
```bash
/Java_WebApp_Deployment -- Maven + Docker + Tomcat (V-2)/
├── app/                      # Maven project for building WAR
│   ├── Dockerfile
│   ├── docker-compose.yaml
│   ├── .env
│   ├── pom.xml
│   └── src/
│       └── main/java/...     # Java Servlet source
│       └── main/webapp/...   # JSP and web.xml
│
├── tomcat/                   # Custom Tomcat Docker context
│   ├── Dockerfile
│   ├── docker-compose.yaml
│   ├── .env
│   └── tomcat_war/           # WAR deployment directory
│
└── WAR_BUILD.sh              # Full build+deploy automation script
```

---

### 🔨 How It Works

1. Build Phase

     - Uses Maven Docker image to compile and package the Java Servlet into ```application##<BUILD_TAG>.war```

     - The build artifact is copied from the container to the host

2. Deployment Phase

     - Moves WAR to tomcat/tomcat_war/

     - Builds a fresh custom Tomcat image that includes the WAR

     - Launches Tomcat exposing a specified port

---

### 📥 Quick Start

1. Clone and Enter Project
```
git clone https://github.com/adibakhtab007/Docker_deployment.git
cd Java_WebApp_Deployment\ --\ Maven\ +\ Docker\ +\ Tomcat\ \(V-2\)
```
2. Run the Script
```
chmod +x WAR_BUILD.sh
./WAR_BUILD.sh
```
This will build the WAR, deploy it to Tomcat, and start the container.

3. Access the App
```
# Replace with your port from tomcat/.env
http://HOST-IP:1111/application
http://HOST-IP:1111/application/hello
```
---

### ⚙️ Configuration Overview

app/.env
```
APP_IMAGE=demo_java_hello_app
BUILD_TAG=dynamic_version
WAR_OUTPUT=./war_output
```
tomcat/.env
```
TOMCAT_IMAGE=psl_tomcat-8.5.100
TOMCAT_TAG=2025.05.08.1.0.0
CONTAINER_NAME=psl_tomcat-8.5.100
HOST_PORT=1111
LOG_PATH=/var/log/tomcat_8-5-100_log
```
---

### 🧪 Test the Deployment

```curl http://HOST-IP:1111/application/hello```

Should return:

```<h2>Hello from Java WAR App running on Tomcat 8.5!</h2>```

### 🧼 Cleanup
```
# Remove old WARs
rm -rf tomcat/tomcat_war/*.war

# Tear down Tomcat container
cd tomcat
docker-compose down
```

---

### 👨‍💻 Author

_**Adib Akhtab Faruquee**_  
_**Systems, Network & Security**_  
_📅 Created: May 2025_  
_in/adib-akhtab-faruquee_

### 📝 License

MIT License © 2025 Adib Akhtab Faruquee