# Inception — Commands Guide

## Table of Contents

* [Project Overview](#project-overview)
* [Prerequisites](#prerequisites)
* [Makefile Commands](#makefile-commands)
* [Docker Commands](#docker-commands)
* [Docker Compose Commands](#docker-compose-commands)
* [Container Commands](#container-commands)
* [Image Commands](#image-commands)
* [Volume Commands](#volume-commands)
* [Network Commands](#network-commands)
* [Logs and Debugging](#logs-and-debugging)
* [Useful Commands](#useful-commands)
* [Cleaning Everything](#cleaning-everything)

---

# Project Overview

**Inception** is a Docker-based infrastructure project.

The goal is to build a small infrastructure composed of several services running inside separate Docker containers.

A typical Inception setup contains:

```text
                    ┌──────────────┐
                    │    Browser   │
                    └──────┬───────┘
                           │
                         HTTPS
                           │
                           ▼
                  ┌─────────────────┐
                  │     NGINX       │
                  │   Web Server    │
                  └────────┬────────┘
                           │
                           ▼
                  ┌─────────────────┐
                  │    WordPress    │
                  │     PHP-FPM     │
                  └────────┬────────┘
                           │
                           ▼
                  ┌─────────────────┐
                  │     MariaDB     │
                  │    Database     │
                  └─────────────────┘
```

Each service runs in its own container.

Docker provides:

* **Images** → templates used to create containers
* **Containers** → running instances of images
* **Networks** → communication between containers
* **Volumes** → persistent storage
* **Docker Compose** → manages multiple containers together

---

# Prerequisites

Check that Docker is installed:

```bash
docker --version
```

Check Docker Compose:

```bash
docker compose version
```

Check that Docker is running:

```bash
docker info
```

---

# Makefile Commands

If the project contains a `Makefile`, the main commands are usually:

## Build

```bash
make
```

or:

```bash
make build
```

Builds the Docker images required by the project.

---

## Start the project

```bash
make up
```

Starts the infrastructure.

Equivalent to something similar to:

```bash
docker compose up -d
```

The `-d` means **detached mode**, so the containers run in the background.

---

## Stop the project

```bash
make down
```

Stops and removes the containers created by Docker Compose.

Equivalent to:

```bash
docker compose down
```

---

## Rebuild

```bash
make re
```

Usually performs a complete rebuild.

For example:

```bash
make down
make build
make up
```

The exact behavior depends on the project's `Makefile`.

---

# Docker Commands

## Show Docker version

```bash
docker --version
```

Displays the installed Docker version.

---

## Show Docker information

```bash
docker info
```

Displays information about the Docker installation, including:

* containers
* images
* storage driver
* networks
* Docker version
* running containers

---

## Show Docker help

```bash
docker --help
```

Displays available Docker commands.

---

# Docker Compose Commands

Docker Compose is used to manage multiple containers defined in:

```text
docker-compose.yml
```

or:

```text
compose.yml
```

---

## Start all services

```bash
docker compose up
```

Starts all services and displays their output in the terminal.

---

## Start in background

```bash
docker compose up -d
```

Starts all services in detached mode.

---

## Build and start

```bash
docker compose up --build
```

Rebuilds the images before starting the containers.

Useful after changing a `Dockerfile`.

---

## Stop and remove containers

```bash
docker compose down
```

Stops and removes the containers created by Compose.

---

## Stop and remove containers + networks

```bash
docker compose down
```

By default, Compose removes the containers and networks it created.

---

## List Compose containers

```bash
docker compose ps
```

Shows the containers belonging to the current Compose project.

---

## View logs

```bash
docker compose logs
```

Shows logs from all services.

For a specific service:

```bash
docker compose logs nginx
```

or:

```bash
docker compose logs wordpress
```

or:

```bash
docker compose logs mariadb
```

---

## Follow logs

```bash
docker compose logs -f
```

The `-f` means **follow**.

It continuously displays new log output.

---

## Restart services

```bash
docker compose restart
```

Restarts the services.

---

# Container Commands

## List running containers

```bash
docker ps
```

Example:

```text
CONTAINER ID   IMAGE        STATUS
abc123         nginx        Up 10 minutes
def456         wordpress    Up 10 minutes
ghi789         mariadb      Up 10 minutes
```

---

## List all containers

```bash
docker ps -a
```

Unlike `docker ps`, this also shows stopped containers.

---

## Start a container

```bash
docker start <container>
```

Example:

```bash
docker start nginx
```

---

## Stop a container

```bash
docker stop <container>
```

Example:

```bash
docker stop nginx
```

---

## Restart a container

```bash
docker restart <container>
```

---

## Remove a container

```bash
docker rm <container>
```

A running container usually needs to be stopped first.

```bash
docker stop <container>
docker rm <container>
```

You can force removal with:

```bash
docker rm -f <container>
```

---

# Enter a Container

One of the most useful commands for debugging.

```bash
docker exec -it <container> bash
```

Example:

```bash
docker exec -it nginx bash
```

If the container does not contain `bash`, use:

```bash
docker exec -it <container> sh
```

### Meaning

```text
docker exec
```

Execute a command inside a running container.

```text
-it
```

Interactive terminal.

```text
bash
```

Start a Bash shell.

---

## Execute a single command

You don't need to open a shell.

For example:

```bash
docker exec nginx ls
```

Or:

```bash
docker exec wordpress php -v
```

---

# Container Logs

## Show logs

```bash
docker logs <container>
```

Example:

```bash
docker logs nginx
```

---

## Follow logs

```bash
docker logs -f <container>
```

Useful when debugging services that are crashing or refusing connections.

---

# Inspect Containers

```bash
docker inspect <container>
```

Displays detailed information about a container.

It can show:

* IP address
* environment variables
* mounts
* networks
* configuration
* image
* ports

For example:

```bash
docker inspect nginx
```

---

# Image Commands

Docker images are templates used to create containers.

## List images

```bash
docker images
```

or:

```bash
docker image ls
```

---

## Build an image

```bash
docker build -t my-image .
```

### Explanation

```text
docker build
```

Build an image.

```text
-t my-image
```

Give the image a name.

```text
.
```

Use the current directory as the build context.

---

## Remove an image

```bash
docker rmi <image>
```

Example:

```bash
docker rmi nginx
```

Force removal:

```bash
docker rmi -f <image>
```

---

## Inspect an image

```bash
docker image inspect <image>
```

Displays detailed information about an image.

---

# Volume Commands

Volumes are used to persist data outside the container's writable layer.

This is especially important for:

* MariaDB database files
* WordPress files

Without persistent storage, deleting a container could result in losing the data stored only inside that container.

---

## List volumes

```bash
docker volume ls
```

---

## Inspect a volume

```bash
docker volume inspect <volume>
```

Shows information such as where the volume is stored.

---

## Remove a volume

```bash
docker volume rm <volume>
```

Be careful: removing a volume can delete persistent data.

---

## Remove unused volumes

```bash
docker volume prune
```

Docker asks for confirmation before removing unused volumes.

---

# Network Commands

Containers need networks to communicate with each other.

For example:

```text
NGINX
  │
  │ HTTP
  ▼
WordPress
  │
  │ MySQL/MariaDB
  ▼
MariaDB
```

---

## List networks

```bash
docker network ls
```

---

## Inspect a network

```bash
docker network inspect <network>
```

This shows:

* connected containers
* network configuration
* container IP addresses
* network driver

---

## Remove a network

```bash
docker network rm <network>
```

---

# Logs and Debugging

When something doesn't work, start with:

```bash
docker compose ps
```

Check whether the containers are running.

Then:

```bash
docker compose logs
```

Check the logs.

For a specific service:

```bash
docker compose logs nginx
```

Then inspect the container:

```bash
docker inspect nginx
```

And enter it:

```bash
docker exec -it nginx bash
```

or:

```bash
docker exec -it nginx sh
```

---

# Checking Services

## Check NGINX

Inside the NGINX container:

```bash
nginx -t
```

This tests the NGINX configuration.

---

## Check PHP-FPM

Inside the WordPress container:

```bash
php-fpm
```

The exact command depends on the installed PHP version and image configuration.

---

## Check MariaDB

Inside the MariaDB container:

```bash
mysql -u root -p
```

Then enter the MariaDB root password.

You can check databases with:

```sql
SHOW DATABASES;
```

Check users:

```sql
SELECT User, Host FROM mysql.user;
```

---

# Useful Docker Commands

## Show running processes inside a container

```bash
docker top <container>
```

Example:

```bash
docker top nginx
```

---

## Show resource usage

```bash
docker stats
```

Displays:

* CPU usage
* memory usage
* network I/O
* block I/O
* processes

For a specific container:

```bash
docker stats nginx
```

---

## Show container port mappings

```bash
docker port <container>
```

Example:

```bash
docker port nginx
```

---

## Copy files from a container

```bash
docker cp <container>:/path/file .
```

Example:

```bash
docker cp nginx:/etc/nginx/nginx.conf .
```

---

## Copy files into a container

```bash
docker cp file.txt <container>:/path/
```

---

# Cleaning Everything

## Remove stopped containers

```bash
docker container prune
```

---

## Remove unused images

```bash
docker image prune
```

Remove all unused images:

```bash
docker image prune -a
```

Be careful with `-a`.

---

## Remove unused networks

```bash
docker network prune
```

---

## Remove unused volumes

```bash
docker volume prune
```

Volumes can contain important persistent data, so be careful.

---

## Complete Docker cleanup

A more aggressive cleanup is:

```bash
docker system prune
```

For unused images as well:

```bash
docker system prune -a
```

For volumes too:

```bash
docker system prune -a --volumes
```

**WARNING:** These commands can remove Docker resources that are not currently being used. Do not run the most aggressive version unless you understand what data you may lose.

---

# Useful Inception Workflow

A normal workflow when working on the project:

## 1. Build

```bash
make
```

## 2. Start

```bash
make up
```

## 3. Check containers

```bash
docker compose ps
```

## 4. Check logs

```bash
docker compose logs
```

## 5. Enter a container

```bash
docker exec -it <container> bash
```

## 6. Stop the project

```bash
make down
```

## 7. Rebuild after configuration changes

```bash
make re
```

---

# Quick Cheat Sheet

| Command                            | Purpose                            |
| ---------------------------------- | ---------------------------------- |
| `make`                             | Build the project                  |
| `make up`                          | Start the infrastructure           |
| `make down`                        | Stop the infrastructure            |
| `make re`                          | Rebuild the project                |
| `docker ps`                        | Show running containers            |
| `docker ps -a`                     | Show all containers                |
| `docker images`                    | Show images                        |
| `docker volume ls`                 | Show volumes                       |
| `docker network ls`                | Show networks                      |
| `docker compose up -d`             | Start Compose in background        |
| `docker compose down`              | Stop and remove Compose containers |
| `docker compose ps`                | Show Compose containers            |
| `docker compose logs`              | Show service logs                  |
| `docker logs <container>`          | Show container logs                |
| `docker exec -it <container> bash` | Enter a container                  |
| `docker inspect <container>`       | Inspect a container                |
| `docker stats`                     | Show resource usage                |
| `docker system prune`              | Remove unused Docker resources     |

---

# Important Concepts

The most important thing to understand in Inception is the relationship between these components:

```text
Dockerfile
    │
    ▼
  IMAGE
    │
    ▼
CONTAINER
    │
    ├────────── NETWORK ──────────┐
    │                            │
    ▼                            ▼
 VOLUME                       SERVICES
```

### Dockerfile

Instructions used to build an image.

### Image

A packaged template containing everything needed to create a container.

### Container

A running instance of an image.

### Volume

Persistent storage that survives container recreation.

### Network

Allows containers to communicate with each other.

### Docker Compose

Defines and manages the complete multi-container infrastructure.

---

# The Most Important Commands to Remember

If you only remember a few commands, remember these:

```bash
# Start
docker compose up -d

# Stop
docker compose down

# Check containers
docker compose ps

# Check logs
docker compose logs

# Follow logs
docker compose logs -f

# Enter a container
docker exec -it <container> bash

# List containers
docker ps -a

# List images
docker images

# List volumes
docker volume ls

# List networks
docker network ls

# Rebuild
docker compose up -d --build


```
