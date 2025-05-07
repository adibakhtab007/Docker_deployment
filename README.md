# Deploy java_maven-webapp with Docker

![Build Status](https://github.com/adibakhtab007/Docker_deployment/actions/workflows/build.yml/badge.svg)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue)](./LICENSE)
[![Tomcat](https://img.shields.io/badge/tomcat-8.5.100-orange)](https://tomcat.apache.org/)
[![Java](https://img.shields.io/badge/java-21-blueviolet)](https://openjdk.org/)
[![Maven](https://img.shields.io/badge/maven-3.9.6-critical)](https://maven.apache.org/)

> A Maven-based Java web application deployed to a custom Dockerized Tomcat environment with versioned WARs, isolated logging, and container redundancy.

---

### 📂 Project Structure

```bash
demo-java_maven-webapp/
├── .github/workflows/build.yml
├── Dockerfile
├── pom.xml
└── src/
└── main/
├── java/
│   └── com/example/HelloServlet.java
└── webapp/
├── index.jsp
└── WEB-INF/web.xml
```

---

### 🧱 Build

```bash
docker build --no-cache \
  --build-arg BUILD_TAG=$(date +'%Y%m%d.%H%M-RND-42') \
  -t demo-java_maven-tomcat-8.5.100:2025.05.06.1.0.0 .
```
---

### 🚀 Run Containers

#### Instance 1

```bash
docker run -d -p 1111:8080 \
  --name demo_java_hello_app_1 \
  -v /var/log/java_mvn_app-1_log:/usr/share/tomcat-8.5.100-8080/logs \
  demo-java_maven-tomcat-8.5.100:2025.05.06.1.0.0
```

#### Instance 2

```bash
docker run -d -p 2222:8080 \
  --name demo_java_hello_app_2 \
  -v /var/log/java_mvn_app-2_log:/usr/share/tomcat-8.5.100-8080/logs \
  demo-java_maven-tomcat-8.5.100:2025.05.06.1.0.0
```

---

### 🌐 Access

- http://localhost:1111/application/
- http://localhost:2222/application/

### 🔐 Tomcat Manager

Username: admin
Password: 1234

### Access:
- http://localhost:1111/manager/html
- http://localhost:2222/manager/html

### 📦 Version Format

```
DOCKER_PROJECT_NAME=demo-java_maven-tomcat-8.5.100
DOCKER_PROJECT_VERSION=YYYY.MM.DD.MAJOR.MINOR.PATCH
```

### Example:

```
demo-java_maven-tomcat-8.5.100:2025.05.06.1.0.0
```

---

### 📄 License
This project is licensed under the MIT License. See LICENSE for details.

---

These badges are purely for visual clarity and readability. If you later push to Docker Hub or GitHub Actions CI, you can replace these with dynamic status/image size/download count badges.