# Build_Custom_Tomcat

A lightweight, customizable Apache Tomcat 8.5.100 Docker image built from scratch using Alpine Linux and OpenJDK 8. This project allows seamless deployment of Tomcat containers with web access to the `manager` and `host-manager` apps, simplified user authentication, and port/log customization via environment variables.

---

### 🧱 Project Structure
```
Build_Custom_Tomcat/
├── Dockerfile 			  # Custom Dockerfile to build Tomcat from source
├── docker-compose.yaml   # Compose file to manage container lifecycle
└── .env 				  # Environment variables for configuration
```

---

### 🚀 Features

- **Tomcat 8.5.100** built from official source.
- **OpenJDK 8** (Alpine-based image for minimal size).
- **Web management** via `manager-gui` and `host-manager` with unrestricted access (suitable for internal dev environments).
- **Custom admin credentials** (default: `admin` / `1234`).
- **Clean webapps**: Unused apps like `docs`, `examples`, and `ROOT` are removed.
- **Mapped logs** to a host volume.
- **Environment-driven configuration** for easy reuse.

---

### ⚙️ Configuration (.env)

Customize your build and runtime parameters through `.env`:

```ini
# Image details
TOMCAT_IMAGE=psl_tomcat-8.5.100
TOMCAT_TAG=2025.05.08.1.0.0

# Container name and exposed port
CONTAINER_NAME=psl_tomcat-8.5.100
HOST_PORT=1111

# Host log volume path
LOG_PATH=/var/log/tomcat_8-5-100_log
```

---

### 📦 How to Build and Run
 1. Clone the repository:

```bash

git clone <your-repo-url>
cd Build_Custom_Tomcat
```
 2. Ensure .env values are set correctly.

Build and run using Docker Compose:

```bash

docker-compose up -d --build
```
 3. Access Tomcat:

```arduino

http://localhost:1111
```
Login credentials for manager/host-manager:

  - Username: admin

  - Password: 1234

---

Logs from the Tomcat container are persisted at the location defined in LOG_PATH. For example:

```bash

/var/log/tomcat_8-5-100_log
```

### 🛑 Stopping the Container
```bash

docker-compose down
```
### 🔐 Security Notice
  - This image disables IP-based access restrictions to Tomcat’s management applications.

  - Default credentials are used.

  - Not recommended for production environments without additional hardening.

### 📄 License
This project is released under the MIT License.

### 🙌 Acknowledgments
Apache Tomcat
Docker
Alpine Linux