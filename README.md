*This project has been created as part of the 42 curriculum by oel-hadr.*

## Description
Inception is a System Administration project that aims to deepen the understanding of containerization using **Docker**. The goal is to set up a complete microservices infrastructure on a Linux Virtual Machine.

Instead of pulling ready-made images, we build our own Docker images from scratch (using Debian Bullseye) to orchestrate a secure network connecting three distinct services:
1.  **NGINX:** Acts as the secure entry point (TLSv1.2/1.3) and web server.
2.  **WordPress:** Runs the PHP-FPM application processor.
3.  **MariaDB:** Stores the application data.

These services run in isolated containers but communicate seamlessly via a dedicated Docker network, ensuring a robust and modular architecture.

## Instructions

### Prerequisites
* **OS:** Linux (Debian/Ubuntu) or a Virtual Machine.
* **Tools:** Docker Engine, Docker Compose, Make, Git.
* **Permissions:** Root or `sudo` privileges are required to manage Docker.

### Installation & Execution
1.  **Setup Environment Variables:**
    Copy the example template and fill in your secrets.
    ```bash
    vi srcs/.env
    # Define: DOMAIN_NAME, MYSQL_ROOT_PASSWORD, WP_ADMIN_PASSWORD, etc.
    ```

2.  **Configure Host:**
    Map the domain name to your local IP in `/etc/hosts`:
    ```bash
    127.0.0.1   oel-hadr.42.fr
    ```

3.  **Run the Project:**
    Build and start the infrastructure using the Makefile:
    ```bash
    make up
    ```

4.  **Access:**
    Open your browser and visit: `https://oel-hadr.42.fr`

### Clean Up
* Stop containers: `make down`
* Deep clean (removes data volumes): `make fclean`


## Project Description & Technical Choices
This project uses **Docker Compose** to orchestrate services. Below are the key technical comparisons justifying our design choices:

### 1. Virtual Machines vs Docker
* **Virtual Machines (VMs):** Emulate an entire hardware stack (CPU, RAM, Storage) and run a full Operating System (Guest OS) on top of a Hypervisor. They are heavy, slow to boot, and resource-intensive.
* **Docker (Containers):** Virtualize the *Operating System* only. They share the Host OS kernel and binaries. This makes them lightweight (MBs vs GBs), instant to start, and highly portable.
* **Choice:** We use Docker to create lightweight, isolated environments for each service without the overhead of running 3 separate VMs.

### 2. Secrets vs Environment Variables
* **Environment Variables:** Stored in plaintext `.env` files and injected into containers at runtime. Easier to set up but less secure if the `.env` file leaks.
* **Docker Secrets:** Encrypted data stored in the Docker Swarm manager, mounted as files (`/run/secrets/my_pass`) inside the container.
* **Choice:** For this project, we use **Environment Variables** (`.env`) as it is the standard for Docker Compos in non-swarm environments, provided the `.env` file is included in `.gitignore`.

### 3. Docker Network vs Host Network
* **Host Network:** The container shares the host's IP and port space directly. If NGINX listens on 443, it occupies port 443 on the actual machine. No isolation.
* **Docker Network (Bridge):** Creates a private internal network. Containers get their own internal IPs and can talk to each other by name (DNS). Only specific ports are "published" to the outside world.
* **Choice:** We use a **Custom Bridge Network**. This allows MariaDB and WordPress to talk privately (secure) while only exposing NGINX to the host.

### 4. Docker Volumes vs Bind Mounts
* **Docker Volumes:** Managed entirely by Docker (`/var/lib/docker/volumes/`). Easier to back up and migrate, but harder to access directly from the host shell.
* **Bind Mounts:** Map a specific file/folder on the Host Machine directly to the container.
* **Choice:** We use **Bind Mounts** to store data in `/home/oel-hadr/data/`. This strictly follows the subject requirement to have data accessible at a specific path on the VM.


## Resources

### References
* [Docker Deep Dive by Nigel Poulton ](https://z-library.ec/book/117959992/c24fe3?ts=0745) - Docker Deep Dive: Zero to Docker in a Single Book.
* [Docker Documentation](https://docs.docker.com/) - The official guide for Dockerfiles and Compose.
* [WP-CLI Handbook](https://make.wordpress.org/cli/handbook/) - For automating WordPress installation.
* [php-fpm with nginx](https://www.digitalocean.com/community/tutorials/php-fpm-nginx) use the php-fpm with nginx
* [NGINX Documentation](https://nginx.org/en/docs/) - For configuring TLS and FastCGI.

### AI Usage
* **Debugging:** Identifying syntax errors in NGINX configuration files and Docker Compose YAML indentation issues.
* **Documentation:** assisting in structuring this README to ensure all technical comparisons (VM vs Docker, etc.) were accurate and clear.
* **Refactoring:** Converting complex shell commands into cleaner, readable scripts for the `tools/` directories.
