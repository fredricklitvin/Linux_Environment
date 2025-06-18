# Linux Environment Setup: DNS, Reverse Proxy, and Monitoring

This project sets up a Linux environment that runs a Dockerized web application with:
-  Custom DNS server (Bind9)
-  HTTPS with self-signed SSL certificate (Nginx Reverse Proxy)
-  Basic system monitoring and alerting via Bash
-  Dockerized web app deployment


---

##  Project Structure

Linux_Environment/
├── DNS/ # Bind9 templates for custom DNS zone
├── Monitoring/ # Bash monitoring script + .env.template
├── Reverse_Proxy/ # NGINX reverse proxy config template
├── setup_env.sh # Automated setup script (DNS, NGINX, Monitoring)
├── .env.template # Environment variables to export

##  Quick Start

### 1. 🔧 Create Your `.env` Files

From the root folder:

```bash
cp env.template .env
cp Monitoring/env.template Monitoring/.env
```
Edit them and fill in the required environment variables.

### 2.  Install Docker
Follow Docker's official instructions for your system.
https://docs.docker.com/engine/install/ubuntu/

### 3.  Run Your Web App (Example)
Use any web app. For example, clone and run this:

```bash
git clone https://github.com/stackzoo/simple-web-app.git
cd simple-web-app
docker build -t test/app:latest . \
&& docker run -it --rm -p 8887:8887 test/app:latest
```
The reverse proxy is configured to forward to localhost:8887

### 4. Create a Self-Signed SSL Certificate
Run:

```bash
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ssl.key -out ssl.crt
```
Put the generated ssl.key and ssl.crt in the .env file.

### 5. Run the Setup Script
This script will:

Install Bind9 and set up DNS

Install NGINX and configure reverse proxy with SSL

Configure monitoring alerts using ssmtp and cron

```bash

chmod +x setup_env.sh
sudo ./setup_env.sh
```
### 6.  Set Linux to Use Local DNS (Make It Authoritative)
Edit /etc/systemd/resolved.conf:
```bash
[Resolve]
DNS=127.0.0.1
FallbackDNS=8.8.8.8
```
Then reload:
```bash
sudo systemctl restart systemd-resolved
```


### 7. Monitor Health
A monitoring Bash script logs CPU, disk, memory, services, and Docker logs.
You can:

Add it to cron for scheduled health checks

Send alerts via ssmtp

### Notes
Tested on Ubuntu-based Linux systems

Project uses systemd and assumes sudo access

Reverse proxy listens on HTTPS (port 443) and forwards to your Docker app
