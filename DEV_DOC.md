# Developer Documentation — Inception Infrastructure Stack

This document provides technical guidelines for developers maintaining or expanding the Inception infrastructure.

---

## 1. Environment Setup & Prerequisites

### Prerequisites
* Operating System: Linux distribution (Debian or Ubuntu recommended).
* Software dependencies installed on the host:
  * docker (version 20.10 or higher)
  * docker compose plugin (version 2.0 or higher)
  * make
  * openssl

### Host Configuration
1. Domain Name Resolution:
   Add your evaluation domain mapping to /etc/hosts on the host machine:
   echo "127.0.0.1 login.42.fr" | sudo tee -a /etc/hosts
   (Replace login with your actual 42 username, e.g., tdelmas2.42.fr).

2. Configuration Files & Secrets:
   Create the environment configuration file at srcs/.env based on the following template:

   DOMAIN_NAME=login.42.fr
   MYSQL_ROOT_PASSWORD=super_root_password
   MYSQL_DATABASE=wordpress
   MYSQL_USER=wp_user
   MYSQL_PASSWORD=wp_password
   WP_ADMIN_USER=site_admin
   WP_ADMIN_PASSWORD=admin_password_123
   WP_ADMIN_EMAIL=admin@login.42.fr
   WP_USER=regular_user
   WP_USER_PASSWORD=user_password_123
   WP_USER_EMAIL=user@login.42.fr

---

## 2. Build and Launching the Project

The infrastructure build pipeline is automated via the root Makefile which interfaces with Docker Compose.

### Directory Structure Overview
.
├── Makefile
├── USER_DOC.md
├── DEV_DOC.md
└── srcs/
    ├── .env
    ├── docker-compose.yml
    └── requirements/
        ├── mariadb/
        ├── nginx/
        └── wordpress/

### Build & Execution Commands
* Build images and start all containers:
  make

  This command executes:
  1. Directory creation for persistent volumes (/home/login/data/mariadb and /home/login/data/wordpress).
  2. Building of Docker images without cache issues.
  3. Starting of container stack in detached mode via docker compose -f srcs/docker-compose.yml up -d --build.

* Stop the containers:
  make down

* Rebuild and restart the containers:
  make re

---

## 3. Container and Volume Management Commands

Useful developer commands for debugging, monitoring, and inspecting active services:

* List running containers:
  docker compose -f srcs/docker-compose.yml ps

* Inspect internal bridge network:
  docker network inspect inception_network

* Access container interactive shell:
  docker exec -it nginx bash
  docker exec -it wordpress bash
  docker exec -it mariadb bash

* Database inspection:
  docker exec -it mariadb mysql -u wp_user -pwordpress

* WP-CLI operational check:
  docker exec -it wordpress wp core check-update --allow-root --path=/var/www/wordpress

* View individual service logs:
  docker compose -f srcs/docker-compose.yml logs -f nginx
  docker compose -f srcs/docker-compose.yml logs -f wordpress
  docker compose -f srcs/docker-compose.yml logs -f mariadb

---

## 4. Data Storage and Persistence Architecture

### Bind Mount Strategy
In compliance with project specifications, persistent storage uses host Bind Mounts directly mapped to explicit filesystem locations rather than standard named volumes.

Host Storage Location:
* Database files: /home/login/data/mariadb
* Website files: /home/login/data/wordpress

Docker Compose Mapping (srcs/docker-compose.yml):
* MariaDB: /home/login/data/mariadb is mapped to /var/lib/mysql inside the mariadb container.
* WordPress: /home/login/data/wordpress is mapped to /var/www/wordpress inside the wordpress container.

### Persistence Mechanism
1. MariaDB:
   During initialization, the database entrypoint script checks if the directory /var/lib/mysql/wordpress exists. If it exists, initialization is skipped to avoid overwriting database state across container restarts.

2. WordPress:
   The entrypoint script verifies the existence of /var/www/wordpress/wp-config.php. If present, it skips core download and installation, directly executing php-fpm.

3. Complete Data Reset:
   Running 'make fclean' will completely remove containers, networks, images, and wipe the /home/login/data/ directories.
