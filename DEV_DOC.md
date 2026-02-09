# Developer documentation

This document explains how a developer can set up the project environment from scratch, configure required files and secrets, build and launch the infrastructure using Docker Compose and the Makefile, manage containers and volumes, and understand where and how project data is stored and persisted.

## Environment setup from scratch

To work with this project, a **Linux-based** environment with administrative privileges is required. If the host system does not allow this, a **virtual machine** must be used.

The following prerequisites must be met:

* Docker must be installed and running
* Docker Compose must be available
* Make must be installed
* The user must have permission to manage Docker resources

If a virtual machine is used, a **shared directory** between the host and the VM is recommended to conveniently provide configuration files, secrets, and certificates.

### Configuration files and secrets

Several configuration elements must be provided by the developer before the project can be launched:

* An `.env` file containing database credentials, WordPress credentials, and the domain name
* A self-signed **TLS certificate and a private key** for Nginx
* A local directory to store persistent data volumes

The `.env` file is required by both the MariaDB and WordPress containers. Missing or incomplete variables will prevent containers from initializing correctly.

TLS certificates and private keys must be generated manually and placed in the directory expected by the Nginx Dockerfile and entrypoint script. These files must never be committed to version control.

To access the website using a custom domain name, the `/etc/hosts` file must be updated to map the desired domain (for example `login.42.fr`) to the local IP address.

## Building and launching the project

The infrastructure is orchestrated using **Docker Compose**, with a **Makefile** provided to simplify common development workflows.

All commands must be executed from the root directory of the repository.

### Building the images

Images for all services are built from custom Dockerfiles using **Alpine Linux** as the base image. Image creation includes only build-time dependencies and configuration.

The `build` rule in the Makefile can be used to build or rebuild all images.

### Launching the infrastructure

The `up` rule builds the images if needed and starts all containers in detached mode. It also ensures that the required directories for persistent data exist before containers are started.

Container startup order is controlled using **healthchecks**. WordPress waits for MariaDB to be healthy, and Nginx depends on WordPress being available.

### Stopping and resetting the project

The `down` rule stops and removes all running containers without deleting stored data.

The `clean` rule additionally removes images and Compose-managed resources while preserving persistent data.

The `fclean` rule fully resets the environment by removing local volume directories, resulting in a clean state on the next startup.

## Managing containers and volumes

Developers can use **Docker Compose** commands to inspect and manage the running infrastructure.

Typical management tasks include:

* Listing running containers and their health status
* Viewing logs for individual services
* Restarting containers after configuration changes
* Inspecting volumes and networks created by Docker Compose

The Makefile provides convenience targets such as `lsall` and `logs` to simplify these operations.

## Data storage and persistence

Project data is persisted using **named Docker volumes backed by bind mounts**.

Two volumes are defined:

* a database volume for MariaDB
* a WordPress volume for website files and uploads

Although the volumes are declared as named volumes in Docker Compose, their underlying storage is bound to user-defined directories on the host machine. Docker tracks them as named volumes, while the actual data location is managed manually.

This design ensures that data persists across container restarts, rebuilds, and image updates. Data is only removed when the local volume directories are explicitly deleted, for example using the `fclean` Makefile rule.