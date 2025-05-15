#!/bin/bash

# -------------------------------------------
# | Script Created By: Adib Akhtab Faruquee |
# | Script Created at: 15-05-2025 21:00 PM  |
# -------------------------------------------

set -e

# === Environment ===
export PS4='+ [$(date "+%Y-%m-%d %H:%M:%S")] '
set -x

# === Path Constants ===
PROJECT_ROOT="/root/demo-maven-tomcat-project"
APP_DIR="$PROJECT_ROOT/app"
TOMCAT_DIR="$PROJECT_ROOT/tomcat"
APP_ENV_FILE="$APP_DIR/.env"
WAR_OUTPUT_DIR=$(grep WAR_OUTPUT "$APP_ENV_FILE" | cut -d= -f2)
WAR_OUTPUT_PATH="$APP_DIR/$WAR_OUTPUT_DIR"
WAR_DEST="$TOMCAT_DIR/tomcat_war"

# === Generate BUILD_TAG ===
BUILD_TAG=$(date +'%Y%m%d.%H%M-RND-42')
echo "🔧 Using BUILD_TAG: $BUILD_TAG"

# === Update ./app/.env ===
if grep -q '^BUILD_TAG=' "$APP_ENV_FILE"; then
  sed -i "s/^BUILD_TAG=.*/BUILD_TAG=$BUILD_TAG/" "$APP_ENV_FILE"
else
  echo "BUILD_TAG=$BUILD_TAG" >> "$APP_ENV_FILE"
fi

# === Prepare WAR output directory ===
mkdir -p "$WAR_OUTPUT_PATH"

# === Build Application Image ===
cd "$APP_DIR"
APP_IMAGE=$(grep APP_IMAGE .env | cut -d= -f2)
IMAGE_TAG=$(grep BUILD_TAG .env | cut -d= -f2)

echo "🐳 Building app Docker image: ${APP_IMAGE}:${IMAGE_TAG}"
docker-compose build app

echo "📦 Extracting WAR from image..."
CONTAINER_ID=$(docker create "${APP_IMAGE}:${IMAGE_TAG}")

if ! docker cp "${CONTAINER_ID}:/app/target/application##${IMAGE_TAG}.war" "$WAR_OUTPUT_PATH/"; then
  echo "❌ Failed to copy WAR file from container"
  docker rm "$CONTAINER_ID"
  exit 1
fi
docker rm "$CONTAINER_ID"

# === Clean up app image ===
docker image rm "${APP_IMAGE}:${IMAGE_TAG}" -f || echo "ℹ️ App image not found or already removed"

# === Move WAR file to Tomcat deployment directory ===
WAR_FILE="$WAR_OUTPUT_PATH/application##${BUILD_TAG}.war"

if [ ! -f "$WAR_FILE" ]; then
  echo "❌ WAR file not found at $WAR_FILE"
  exit 1
fi

mkdir -p "$WAR_DEST"
find "$WAR_DEST" -maxdepth 1 -name '*.war' -exec rm -f {} +
mv "$WAR_FILE" "$WAR_DEST/"
rm -rf "$WAR_OUTPUT_PATH"

# === Clean all previous app images ===
echo "🗑️ Removing all versions of demo_java_hello_app"
docker images "demo_java_hello_app" --format "{{.Repository}}:{{.Tag}}" | xargs -r docker rmi -f

# === Optional: Clean up base image if it exists ===
if docker images | grep -q 'maven *3.9.6-eclipse-temurin-8'; then
  docker rmi maven:3.9.6-eclipse-temurin-8 -f
else
  echo "ℹ️ Maven base image not present — nothing to delete"
fi

# === Confirm WAR is deployed ===
echo "✅ WAR file is ready in $WAR_DEST as application##${BUILD_TAG}.war"

# === Clean up old Tomcat container and image ===
echo "🗑️  Removing old Tomcat container and image..."

TOMCAT_IMAGE=$(grep TOMCAT_IMAGE "$TOMCAT_DIR/.env" | cut -d= -f2)
TOMCAT_TAG=$(grep TOMCAT_TAG "$TOMCAT_DIR/.env" | cut -d= -f2)
CONTAINER_NAME=$(grep CONTAINER_NAME "$TOMCAT_DIR/.env" | cut -d= -f2)

# Stop and remove running container
if docker ps -a --format '{{.Names}}' | grep -q "^${CONTAINER_NAME}$"; then
  docker rm -f "$CONTAINER_NAME"
  echo "✅ Removed container: $CONTAINER_NAME"
fi

# Remove old image
if docker images "$TOMCAT_IMAGE:$TOMCAT_TAG" --quiet | grep -q .; then
  docker rmi -f "$TOMCAT_IMAGE:$TOMCAT_TAG"
  echo "✅ Removed image: $TOMCAT_IMAGE:$TOMCAT_TAG"
fi

# === Deploy Tomcat Container ===
echo "🚀 Building and deploying Tomcat container..."
cd "$TOMCAT_DIR"
docker-compose build
docker-compose up -d

# === Optional: Health Check ===
HOST_PORT=$(grep HOST_PORT "$TOMCAT_DIR/.env" | cut -d= -f2)

echo "⏳ Waiting for Tomcat to be ready..."
sleep 5

SERVER_IP=$(hostname -I | awk '{print $1}')

if curl -sf "http://${SERVER_IP}:${HOST_PORT}" >/dev/null; then
  echo "✅ Tomcat responded successfully!"
else
  echo "⚠️ Tomcat is running but did not respond at http://localhost:${HOST_PORT}"
fi

# === Final Summary ===
echo ""
echo "🎉 Build and Deployment Complete!"
echo "🌐 Access your app at: http://${SERVER_IP}:${HOST_PORT}/application"