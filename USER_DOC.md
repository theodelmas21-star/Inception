# User Documentation — Inception Infrastructure Stack

This documentation guides users and system administrators on how to run, manage, access, and verify the services provided by this infrastructure.

---

## 1. Provided Services

The infrastructure runs as a set of isolated services interconnected through a private Docker bridge network:

* NGINX: The primary web server and single entry point to the infrastructure. It ensures secure HTTPS communication over TLS v1.2 / TLS v1.3 on port 443.
* WordPress: The website application server, executing PHP scripts via php-fpm. It is isolated and not directly accessible from outside the network (internal port 9000).
* MariaDB: The relational database management system storing all WordPress content and configuration settings. It is strictly isolated and accessible only internally by WordPress (internal port 3306).

---

## 2. Starting and Stopping the Project

All service management commands are executed from the root of the repository using the provided Makefile.

* Start the infrastructure:
  make

  (This builds the Docker images, creates the host volume directories, and starts all containers in detached mode).

* Stop the infrastructure:
  make down

  (This stops and removes running containers while preserving persistent database and website files).

* Restart the infrastructure:
  make restart

* Clean everything up:
  make fclean

  (This stops the stack and deletes containers, networks, images, and host persistent data directories).

---

## 3. Accessing the Website and Administration Panel

Before accessing the site, ensure your domain (e.g., login.42.fr) points to 127.0.0.1 in your local /etc/hosts file.

* Public Website:
  Navigate to the following URL in your browser:
  https://login.42.fr

  (Replace login with your actual username, e.g., https://tdelmas2.42.fr)

* WordPress Administration Panel:
  Navigate to:
  https://login.42.fr/wp-admin

Note on Security Warning: Since the infrastructure uses a self-signed TLS certificate for local evaluation, your browser will display a security alert. Click Advanced and choose to proceed.

---

## 4. Locating and Managing Credentials

All environment settings, database passphrases, and WordPress user credentials are stored in the .env configuration file:

* File Location: srcs/.env

Managed Credentials:
Within srcs/.env, you can locate and adjust:
* Database Credentials: MYSQL_ROOT_PASSWORD, MYSQL_USER, MYSQL_PASSWORD, and MYSQL_DATABASE.
* WordPress Administrator Account: WP_ADMIN_USER, WP_ADMIN_PASSWORD, and WP_ADMIN_EMAIL.
* WordPress Regular User Account: WP_USER, WP_USER_PASSWORD, and WP_USER_EMAIL.

Security Note: Never commit the .env file to a public repository or shared environment.

---

## 5. Checking Service Health and Status

You can verify that all components are running properly using the following methods:

* Check Running Containers:
  Run the following command from the repository root:
  docker compose -f srcs/docker-compose.yml ps

  Or use the Makefile shortcut:
  make status

  (Verify that nginx, wordpress, and mariadb all show the status Up).

* Check Live Service Logs:
  To view logs from all containers:
  make logs

  To inspect a specific container logs:
  docker compose -f srcs/docker-compose.yml logs -f nginx
  docker compose -f srcs/docker-compose.yml logs -f wordpress
  docker compose -f srcs/docker-compose.yml logs -f mariadb

* Check TLS Security Standard:
  Verify that NGINX strictly accepts allowed TLS protocols using openssl:
  openssl s_client -connect localhost:443 -tls1_2
  openssl s_client -connect localhost:443 -tls1_3
