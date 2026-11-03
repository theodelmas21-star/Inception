*This project has been created as part of the 42 curriculum by tdelmas2.*

# Inception - Virtualization & Infrastructure

## Description

The **Inception** project aims to broaden knowledge of system administration using Docker. The goal is to set up a complete, secure infrastructure composed of several services isolated within independent Docker containers, orchestrated using **Docker Compose** on a dedicated Debian VM.

The infrastructure consists of a LEMP-like stack featuring:
* **NGINX**: Acts as the sole TLS v1.2/v1.3 entry point on port 443.
* **WordPress + PHP-FPM**: Serves the website dynamically on port 9000 (internal network).
* **MariaDB**: Stores the site's relational database on port 3306 (internal network).

All services are built from custom Dockerfiles using base images (Debian/Alpine) without pre-made container solutions.

---

## Instructions

### 1. Prerequisites
* A Debian Virtual Machine with docker, docker-compose-plugin, and make installed.
* Local domain mapping set in /etc/hosts:
  127.0.0.1 tdelmas2.42.fr

### 2. Configuration (.env)
Create a .env file inside the srcs/ directory containing your credentials:

DOMAIN_NAME=tdelmas2.42.fr

MYSQL_DATABASE=wordpress
MYSQL_USER=wp_user
MYSQL_PASSWORD=user_password_123
MYSQL_ROOT_PASSWORD=root_password_123

WP_TITLE=Inception 42
WP_ADMIN_USER=tdelmas2_a
WP_ADMIN_PASSWORD=tdelmas2_a_123
WP_ADMIN_EMAIL=tdelmas2_a@student.42.fr

WP_USER=author_user
WP_PASSWORD=author_password_123
WP_EMAIL=author@tdelmas2.42.fr

### 3. Execution Commands
Run all commands from the root directory where the Makefile is located:

* Start the infrastructure:
  make

* Stop containers:
  make down

* Clean Docker objects (images, containers, networks):
  make clean

* Full wipe (containers, networks, images, and data directories):
  make fclean

* Rebuild everything:
  make re

### 4. Accessing the Infrastructure
Once the containers are running, navigate to:
https://tdelmas2.42.fr (Accept the self-signed SSL warning)

---

## Project Description & Technical Choices

### Docker Architecture Overview
This project leverages Docker to achieve lightweight process isolation. Each service runs in its own dedicated container based on lightweight base distributions (Debian/Alpine) to minimize attack surface and resource usage.

### Technical Comparisons

#### 1. Virtual Machines vs Docker
* Virtual Machines: Virtualize entire hardware stacks and run full guest operating systems on top of a hypervisor. They are heavy, resource-intensive, and slow to boot, but provide hard isolation boundaries.
* Docker: Uses containerization to share the host kernel while isolating user space processes using Linux namespaces and cgroups. They are lightweight, start instantly, and consume significantly fewer resources.

#### 2. Secrets vs Environment Variables
* Environment Variables: Easily passed into containers (e.g., via .env or docker-compose.yml), making them ideal for non-sensitive system settings. However, they can be inspected easily via docker inspect or process tree listings.
* Secrets: Secure mechanisms designed to store sensitive data (passwords, keys, tokens). They are mounted in-memory or encrypted at rest, preventing credentials from leaking into container images or logs.

#### 3. Docker Network vs Host Network
* Host Network: Removes network isolation between the container and the host machine, causing the container to bind directly to the host's network interfaces (risking port conflicts).
* Docker Network (Bridge): Creates an isolated, private virtual network where containers communicate securely using internal DNS aliases. Only explicitly exposed ports are accessible outside the bridge network.

#### 4. Docker Volumes vs Bind Mounts
* Docker Volumes: Fully managed by Docker inside /var/lib/docker/volumes/. They offer higher performance, seamless backup options, and platform independence.
* Bind Mounts: Directly mount a specific folder from the host filesystem (e.g., /home/tdelmas2/data/) into the container. They provide transparent, persistent access on the host system.

---

## Resources

### Documentation & References
* Docker Official Documentation: https://docs.docker.com/
* Docker Compose Specification: https://docs.docker.com/compose/
* NGINX Documentation: https://nginx.org/en/docs/beginners_guide.html
* WordPress CLI Reference: https://developer.wordpress.org/cli/commands/
* MariaDB Knowledge Base: https://mariadb.com/kb/en/

### Use of AI Assistance
In accordance with 42 guidelines, AI tools (Gemini) were utilized during the project for:
1. Troubleshooting & Debugging: Diagnosing network routing errors, browser SSL certificate exceptions, and permission issues related to docker.sock.
2. Drafting Documentation: Structuring, formatting, and refining this README.md file to meet all required project standards and evaluation guidelines.
