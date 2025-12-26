### **User Documentation**

## 1. Introduction
This project provides a fully functional **WordPress website** running on a secure, containerized infrastructure. It is designed to be easy to deploy and manage without needing to install web servers or databases manually on your machine.

### What's inside the stack?
* **Website (WordPress):** A content management system to create and manage your website pages and posts.
* **Web Server (NGINX):** A secure gatekeeper that handles visitors and encrypts the connection (HTTPS).
* **Database (MariaDB):** A secure vault that stores all your website data (users, posts, comments).

## 2. How to Start & Stop
We have provided simple commands to control the system. Open your terminal in the project folder.

### Start the Project
To turn everything on, run:
```bash
make up
```

### Stop the Project

```bash
make down
```

## 3. How to Access the Website
Once the project is running (you can check with `docker ps`), open your web browser.

### The Public Website

- URL: https://oel-hadr.42.fr

### The Administration Panel

- URL: https://oel-hadr.42.fr/wp-admin
- Login: Use the credentials found in the .env file.

## 4. Credentials & Security

For security reasons, usernames and passwords are not hardcoded in the software. They are stored in a configuration file on your server.

Where to find them: Look for a file named .env in the srcs/ folder:

```bash
cat srcs/.env
```

- **WordPress Admin User:** Look for ``WP_ADMIN_USER`` and ``WP_ADMIN_PASSWORD``.
- **Database Root:** Look for ``MYSQL_ROOT_PASSWORD``.

## 5. Check State
If you are unsure if the system is running correctly:

 - 1 - **Check Status:** Run ``docker ps``. You should see 3 lines (nginx, wordpress, mariadb) with status "Up".
 - 2 - **Check Logs:** If a service isn't working, check its output:
 ```bash
  docker logs nginx
  docker logs wordpress
  docker logs mariadb
 ```

