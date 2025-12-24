# 42 Inception - DevOps Project
**Author:** oel-hadr
**Domain:** oel-hadr.42.fr

## 🗺️ Project Overview
This project aims to broaden knowledge of system administration by using DockerWe must set up a small infrastructure composed of different services under specific rules
---

## ✅ Phase 1: Infrastructure & Setup (The Foundation)
- [x] **Virtual Machine Setup**
    - [x] Install Debian 12 (Stable/Old Stable).
    - [x] Enable SSH access.
    - [x] Configure "Bridged Adapter" network.
    - [x] Install Docker Engine & Docker Compose (v2).
    - [x] Add user `oel-hadr` to `sudo` and `docker` groups.
- [x] **Folder Structure**
    - [x] Create `Makefile` at root.
    - [x] Create `srcs/` directory.
    - [x] Create `srcs/requirements/mariadb/` (conf, tools, Dockerfile).
    - [x] Create `srcs/requirements/nginx/` (conf, tools, Dockerfile).
    - [x] Create `srcs/requirements/wordpress/` (conf, tools, Dockerfile).
- [x] **System Volumes**
    - [x] Create `/home/oel-hadr/data/mariadb`.
    - [x] Create `/home/oel-hadr/data/wordpress`.
- [x] **Domain Configuration**
    - [x] Edit `/etc/hosts` on VM: map `127.0.0.1` to `oel-hadr.42.fr`.
    - [ ] Edit hosts on Windows: map `VM_IP` to `oel-hadr.42.fr` (Optional but recommended).

---

## 🛠️ Phase 2: The Skeleton
- [x] **Environment Variables**
    - [x] Create `srcs/.env` file.
    - [x] Define variables: `DOMAIN_NAME`, `MYSQL_ROOT_PASSWORD`, `MYSQL_USER`, `MYSQL_PASSWORD`, etc.
    - [ ] **Security Rule:** No passwords stored in Dockerfiles
    - [x] **Docker Compose** 
    - [x] Create `srcs/docker-compose.yml`.
    - [x] Define 3 services: `mariadb`, `wordpress`, `nginx`.
    - [x] Define 2 volumes: `db-volume`, `wp-volume`.
    - [x] Define 1 private network.
    - [x] **Rule:** Restart policy must be set to `always` or `on-failure`.

---

## 🚀 Phase 3: NGINX (The Gatekeeper)
- [x] **Dockerfile**
    - [x] Base image: Debian or Alpine (must match others).
    - [x] Install `nginx` and `openssl`.
- [ ] **Configuration**
    - [x] Generate self-signed SSL certificate (TLSv1.2 or TLSv1.3 mandatory).
    - [x] Configure NGINX to listen on port 443 only
    - [x] **Rule:** It must be the *only* entry point to the infrastructure
    - [x] Test: Access `https://oel-hadr.42.fr` (should show 404 or Welcome page).

---

## 🗄️ Phase 4: MariaDB (The Database)
- [ ] **Dockerfile**
    - [ ] Base image: Debian or Alpine.
    - [ ] Install `mariadb-server`.
- [ ] **Configuration**
    - [ ] Configure `50-server.cnf` to listen on `0.0.0.0` (remote access within docker network).
    - [ ] Write `entrypoint.sh` script to:
        - [ ] Start MySQL service safely.
        - [ ] Create database (if missing).
        - [ ] Create user and grant privileges.
        - [ ] Set root password.
        - [ ] **Rule:** Don't use `tail -f` or loop hacks; keep the process running correctly
---

## 📝 Phase 5: WordPress (The Application)
- [ ] **Dockerfile**
    - [ ] Base image: Debian or Alpine.
    - [ ] Install `php-fpm`, `php-mysql`, `wget` (for WP-CLI).
    - [ ] **Rule:** Do NOT install NGINX in this container- [ ] **Configuration**
    - [ ] Configure `www.conf` to listen on port 9000 (standard for PHP-FPM).
    - [ ] Write `entrypoint.sh` using **WP-CLI** to:
        - [ ] Download WordPress core.
        - [ ] Create `wp-config.php`.
        - [ ] Install WordPress (set title, admin user, etc.).
        - [ ] Create a second user (editor/author).

---

## 🔍 Verification & Quality Control (The Defense)
- [ ] **Forbidden Functions Check**
    - [ ] Ensure NO `network: host` in docker-compose    - [ ] Ensure NO `--link` or `links:` used    - [ ] Ensure NO infinite loops (`tail -f`, `sleep infinity`) in scripts    - [ ] Ensure NO passwords hardcoded in Dockerfiles- [ ] **Functionality Check**
    - [ ] Does `make` build and start everything?
    - [ ] Does `make down` stop and remove containers?
    - [ ] Does `docker volume ls` show the 2 volumes?
    - [ ] Can you access the site via `https://oel-hadr.42.fr`?
    - [ ] Is the connection secure (TLS check)?
- [ ] **Persistence Check**
    - [ ] Create a post on WordPress.
    - [ ] Run `docker-compose down` and then `up`.
    - [ ] Is the post still there? (Database persistence).
- [ ] **Documentation**
    - [ ] Is `README.md` present and clear?.