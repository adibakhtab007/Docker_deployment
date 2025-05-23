# Deploy java-webapp with Docker

[![License: MIT](https://img.shields.io/badge/license-MIT-blue)](./LICENSE)
[![Tomcat](https://img.shields.io/badge/tomcat-8.5.100-orange)](https://tomcat.apache.org/)
[![Java](https://img.shields.io/badge/java-21-blueviolet)](https://openjdk.org/)
[![Maven](https://img.shields.io/badge/maven-3.9.6-critical)](https://maven.apache.org/)
![Bash](https://img.shields.io/badge/shell-bash-1f425f.svg)

> A Maven-based Java web application deployed to a custom Dockerized Tomcat environment with versioned WARs, isolated logging, and container redundancy.

---

## 📂 Repository Structure

| Script | Description | Key Tools | License |
|--------|-------------|-----------|---------|
| [Build_Custom_Tomcat](./Build_Custom_Tomcat) | Build Custom Tomcat with Docker | `tomcat`, `tar.gz`, `curl`, `sed`, `docker build`, `docker run` | MIT |
| [JAVA-Maven Docker Deployment - V.1](<./Java_WebApp_Deployment -- Maven + Docker + Tomcat (V-1)>) | Deploy JAVA (Maven) project with Docker | `mvn`, `tomcat`, `tar.gz`, `curl`, `sed`, `docker build`, `docker run` | MIT |
| [JAVA-Maven Docker Deployment - V.2](<./Java_WebApp_Deployment -- Maven + Docker + Tomcat (V-2)>) | Deploy JAVA (Maven) project with Docker | `mvn`, `tomcat`, `tar.gz`, `curl`, `sed`, `docker build`, `docker run` | MIT |

## 📄 License
This project is licensed under the MIT License. See LICENSE for details.

---

These badges are purely for visual clarity and readability. If you later push to Docker Hub or GitHub Actions CI, you can replace these with dynamic status/image size/download count badges.