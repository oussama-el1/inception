### **Developer Documentation**

This document outlines the technical details required to set up, build, manage, and understand the architecture of the **Inception** infrastructure.

## 1. Environment Setup
To build this project from scratch, your development environment must meet the following requirements.

### Prerequisites
* **Operating System:** Linux (Debian 12 Bookworm or Bookworm recommended) running in a Virtual Machine.
* **Docker Engine:** Installed and running.
* **Docker Compose:** Version v2.0 or higher.
* **Make:** GNU Make utility.
* **Permissions:** Current user must be part of the `docker` and `sudo` groups.

### Network Configuration (DNS)
The project requires a local DNS mapping to route the domain to your local infrastructure.
1.  Open your hosts file:
    ```bash
    sudo nano /etc/hosts
    ```
2.  Add the following line mapping local loopback to the project domain:
    ```text
    127.0.0.1   oel-hadr.42.fr
    ```

### Secrets Configuration (.env)
The `docker-compose.yml` relies on environment variables for sensitive data. These are **not** committed to Git.
1.  Create `srcs/.env` and fill in the required variables (ensure strong passwords):
    ```ini
    DOMAIN_NAME=oel-hadr.42.fr
    MYSQL_DATABASE=wordpress
    MYSQL_USER=user
    MYSQL_PASSWORD=secure_password
    MYSQL_ROOT_PASSWORD=secure_root_password
    WP_ADMIN_USER=supervisor
    WP_ADMIN_PASSWORD=secure_admin_password
    ...
    ```

## 2. Build and Launch
We use a `Makefile` to abstract complex Docker Compose commands and manage the directory structure.

### Standard Workflow
* **Build and Start:**
    Compiles the Dockerfiles, creates the networks, and starts containers in detached mode.
    ```bash
    make up
    ```
    *Under the hood:* Creates data directories at `/home/oel-hadr/data/` and runs `docker compose -f srcs/docker-compose.yml up -d --build`.

* **Stop and Remove:**
    Stops all running containers and removes the network.
    ```bash
    make down
    ```

* **Rebuild from Scratch:**
    Useful if you modified a Dockerfile or configuration file.
    ```bash
    make re
    ```

## 3. Container & Volume Management
This project relies on `make` for high-level orchestration, but standard Docker commands are essential for deeper management and debugging.

### Managing Containers
* **Check Status:** Verify uptime and port mapping.
    ```bash
    docker ps -a
    ```
* **View Real-time Logs:** Essential for debugging startup scripts (e.g., WordPress installation errors).
    ```bash
    docker logs -f wordpress
    docker logs -f mariadb
    docker logs -f nginx
    ```
* **Access Container Shell:** Open an interactive bash session inside a container.
    ```bash
    docker exec -it <container_name> /bin/bash
    ```
* **Restart a Specific Service:**
    ```bash
    docker restart <container_name>
    ```

### Managing Volumes
* **List Project Volumes:** Verify that `mariadb_data` and `wordpress_data` exist.
    ```bash
    docker volume ls
    ```
* **Inspect Volume Config:** Confirm that the volume is correctly mapped to the host folder.
    ```bash
    docker volume inspect inception_mariadb_data
    ```
* **Clean Up Volumes:** To completely wipe data and start fresh (Warning: Destructive).
    ```bash
    make fclean
    # Or manually:
    docker volume rm inception_mariadb_data inception_wordpress_data
    ```

## 4. Data Storage & Persistence
The project mandates that data must persist even if the containers are deleted or the system is rebooted. We achieve this using **Bind Mounts** disguised as Docker Volumes to strictly adhere to the subject's directory requirements.

### Storage Architecture
Data is stored directly on the Host VM in the user's home directory. These folders are mapped into the containers at runtime.

| Service | Host Path (VM) | Container Path | Content |
| :--- | :--- | :--- | :--- |
| **MariaDB** | `/home/oel-hadr/data/mariadb` | `/var/lib/mysql` | Database files, user credentials, and table structures. |
| **WordPress** | `/home/oel-hadr/data/wordpress` | `/var/www/html` | PHP source files, plugins, themes, and uploaded media. |

### Verifying Persistence
To validate that the persistence architecture is working:

 - **Create Data:** Log into WordPress and create a post, or create a custom file inside /var/lib/mysql.
 - **Destroy Containers:** Run make down (this removes the containers and network).
 - **Verify Host Data:** Check the /home/oel-hadr/data directory; the files should remain.
 - **Rebuild:** Run make up. The WordPress post should still be visible on the website.