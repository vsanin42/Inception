*This project has been created as part of the 42 curriculum by vsanin* 

# Inception

![Inception](https://miro.medium.com/v2/resize:fit:720/format:webp/1*MiiTlPl89vwpv_bvFUjacQ.jpeg)

*Image credit: [ssergiu](https://medium.com/@ssterdev)*

## Description

This project demonstrates the creation of a small infrastructure composed of several services using Docker. Its goal was to deepen the knowledge of Docker, containerization, Unix administration, shell scripting and networking.

The infrastructure consists of **MariaDB, WordPress (+ php-fpm) and Nginx**, each running in a separate container. The running containers are connected internally via Docker network. The only entrypoint to the infrastructure is through Nginx server, acting as a reverse proxy, on port 443 (HTTPS).

## Instructions

### Prerequisites

To be able to use the application, you must either have root permissions on your Linux OS-based host machine, or create a virtual machine. If you opt for a virtual machine, you will need a way to pass secrets (credentials, certificates, keys) to it. A convenient way to do that is setting up a shared folder to make a host machine folder contents visible to the VM. It is then necessary to install Docker itself.

### Installation

Simply download the contents of the repository. **IMPORTANT:** several operations must be done before running the application to ensure a smooth experience:

1. At the top of the Makefile, provide your own desired path as the value of the `VOLUMEDIR` variable to specify where you want your data volumes to be located (see more in the following section).

2. The ownership and permissions of the local volume directories may change as a result of creating containers and use of `sudo` may be required for the `rm -rf` command. Either add `sudo` to the command or modify the the `/etc/sudoers` file to allow executing the command as current user without root privileges. This can be done by using `sudo visudo` and adding the following line to the file and saving: `<user> ALL=(ALL) NOPASSWD: /bin/rm -rf <VOLUMEDIR>*`, with your own user and VOLUMEDIR values. Beware of the security implications. More here: https://www.digitalocean.com/community/tutorials/how-to-edit-the-sudoers-file

3. To be able to access Wordpress via custom address, edit the `/etc/hosts` file and include your desired address after the IP. For example, by 42 subject requirements the domain must be `login.42.fr`, so the `hosts` file includes this line: `127.0.0.1 login.42.fr`, where `login` is the student username.

4. To ensure Nginx works with HTTPS protocol, a certificate and a private key must be provided. It is crucial to handle them with caution and never share them (i.e. don't commit to git). To conveniently generate a certificate and a private key, `openssl` tool can be used - more here: https://www.geeksforgeeks.org/linux-unix/practical-uses-of-openssl-command-in-linux/. The generated files (`.key` and `.pem`) must be placed in the `tools` directory under `nginx` directory. Then it is necessary to make sure the file names you chose at the generation match those in the Nginx Dockerfile and the `nginx_entrypoint.sh` script. If all is successful, upon connecting from a browser it is possible that a warning can be displayed: this is due to the certificate being self-signed (not issued by a trusted certificate authority), therefore the browser cannot verify the server, despite the connection being secure. It is safe to accept the warning and proceed, but only since this is a controlled environment.

5. You must also provide your own credentials, database and website names in the form of an `.env` file. The required variables can be found in MariaDB and WordPress entrypoint scripts. Initialization of some containers will not complete unless all variables are assigned a value. The following list of emptied variables can be filled and added to the `.env` file, which will be then ready for use once placed in the `srcs` directory:

```
DOMAIN_NAME=

DB_HOST=
DB_NAME=
DB_USER=
DB_USERPASS=
DB_ROOTPASS=

WP_TITLE=

WP_ADMIN=
WP_ADMIN_PASS=
WP_ADMIN_EMAIL=

WP_USER=
WP_USER_PASS=
WP_USER_EMAIL=
WP_PUBLIC_URL=
```

### Running

It is possible to run the containers independently, however the central point to the application is the `docker-compose.yml` file. Navigate to the `srcs` directory and use `docker compose <option>` commands to manipulate the environment. Refer to the docker documentation (link below) to learn about the `docker compose` commands to achieve desired results.

To make running the application more convenient, a Makefile has been made with predefined commands and options. It includes the following rules/targets:

* `all` - Runs `up`.

* `up` - 1. Create directories for docker volumes in a filepath of your choice - **IMPORTANT: See *Installation section 1* before continuing.** If the directories already exist, nothing happens. 2. Build the images and start the containers in a detached state (does not block the terminal).

* `down` - Stop and remove the containers.

* `build` - Build images.

* `lsall` ("list all") - includes a combination of commands to list and display the state of the most relevant parts of the application: containers, images and volumes.

* `logs` - Show logs being output by the containers.

* `clean` - Same behaviour as `down`, while removing compose volumes and images. This does not deletes your saved data, upon calling `up` the data persists. 

* `fclean` - Same behaviour as `clean`, while removing **local** volumes. **This deletes your saved data** and results in a "clean slate" state upon the next application start. **IMPORTANT: See *Installation section 2* before continuing.**

* `re` - Calls `fclean` + `up`.

To invoke these rules, use: `make <rule>` in the root directory (with the Makefile), for example: `make up`. `make` without arguments will invoke `all`, which in turns invokes `up`.

## Resources

* Official Docker documentation: https://docs.docker.com/manuals/, https://docs.docker.com/reference/

* Official Nginx documentation: https://nginx.org/en/docs/

* Official Wordpress: https://developer.wordpress.org/

* Official WP-CLI documentation: https://make.wordpress.org/cli/handbook/

* Official MariaDB documentation: https://mariadb.com/docs/server

* Other useful pages and articles:

    * Bash scripting cheatsheet: https://devhints.io/

    * Best practices for writing Dockerfiles: https://www.divio.com/blog/best-practices-writing-dockerfiles/

    * Choosing between CMD and ENTRYPOINT: https://www.docker.com/blog/docker-best-practices-choosing-between-run-cmd-and-entrypoint/

    * Usage of OpenSSL: https://www.geeksforgeeks.org/linux-unix/practical-uses-of-openssl-command-in-linux/

    * Alpine wiki: https://wiki.alpinelinux.org/wiki/Main_Page

* YouTube videos:
    
    * Introduction: https://www.youtube.com/watch?v=Ud7Npgi6x8E

    * Docker Compose: https://www.youtube.com/watch?v=HGKfE-cn9y4

    * Full tutorial/crash course: https://www.youtube.com/watch?v=3c-iBn73dDE

In the creation of this project, LLMs (ChatGPT 5.2) were used to assist with service configuration, conceptualization of the environment, providing source material for learning and creating test cases and commands for verfication and debugging. They were not used to provide ready to use Docker compose file, Dockerfiles and shell scripts.

## Project description
This project uses **Docker** to isolate each service into its own container, creating a containerized multi-service architechture. It simplifies debugging, ensures separation of concerns and clear responsibility boundaries, improves flexibility and follows best practices for deployment.

In this architecture, **MariaDB** acts as the persistent data storage responsible for managing all WordPress database content (users, posts, configuration options). **WordPress**, running with **PHP-FPM**, handles the application logic, processing PHP requests and interacting with the database. **Nginx** serves as the web server and reverse proxy, managing HTTPS connections and forwarding PHP requests to the WordPress container via **FastCGI**.

**Docker compose** is used to orchestrate the services, define their relationships and characteristics and connect them internally via **Docker network**. Nginx is exposed to allow **HTTPS** connections only.

Data is stored in **persistent volumes**. In Docker compose they are defined as named volumes to adhere to the subject, but under the hood their type is "bind", essentially making them a named bind mount, while following the subject requirement for them being named. They are therefore not managed by Docker, and only manual erasure of the volume directories on the host machine deletes the data.

**Alpine images** were selected as base images for image creation primarily due to being lightweight with minimum functionality. Debian images provide a more complete base, but many features may be unnecessary. Using Alpine images ensured that the image size is minimal, resulting in faster startup times, while having the necessary functionality.

The image creation from the **Dockerfile** only includes things that are determined at build time, therefore anything related to environment variables is outsourced to entrypoint scripts for each container. Once runtime-dependent configuration has been performed, each container's main process is executed from the script as a foreground process, enabling signal handling and becoming **PID 1** in the container.

Dockerfiles include a **healthcheck** - a command that's being run in the container in predefined intervals to check if the main process is still running and functional. Some containers' creation depends on another container being healthy: for example, WordPress needs the MariaDB container to be healthy before it can run, Nginx is in turn dependent on WordPress.

WordPress installation was simplified by **WP-CLI** - a command line interface tool for WordPress that provides possibilities of WordPress installation and database/user creation.

For proper functionality, certain confidential information must be passed to the containers: an **.env** file, containing database name, domain name, admin and user credentials; a **self-signed certificate** and a **private key** for the server to be able to conduct **TLS** handshakes in HTTPS connections. The responibility to provide these is on the user, as neither transferring these files nor baking them into the images is safe.

### Virtual Machines vs Docker
| Virtual Machines | Docker |
|--------------|-------------|
| Emulates computers entirely   | OS-level virtualization |
| Heavy (in GBs, slower starts)     | Light (in MBs, faster starts)     |
| Managed by hypervisor (i.e. VirtualBox)    | Managed by Docker Engine (daemon + CLI client + APIs)   |
| Can run different OS      | Needs same OS as kernel     |
| Strongly isolated environment, own OS kernel      | Isolated, but shares the OS kernel    |
| Less portable     | Highly portable |

### Secrets vs Environment Variables
| Secrets | Environment Variables |
| -------------|---------------|
| Used for sensitive data transfer | Used for key-value pairs transfer |
| Secure, encrypted, not exposed | Not secure, can be seen at container runtime |
| Safer for production | Appropriate for dev/test and non-sensitive data and configs  |

### Docker Network vs Host Network
| Docker Network | Host Network |
| -------------|---------------|
| Docker's own internal network for container communication | Shares host network |
| Assigns containers private IPs, DNS via container names | Containers have no private IPs, use host IP |
| Traffic forwarded by Docker | Direct traffic, no forwarding |
| Isolated from host, used in Compose | Not isolated, less secure  |

### Docker Volumes vs Bind Mounts
| Docker Volumes | Bind Mounts |
| -------------|---------------|
| Managed by Docker | Must be managed by the user |
| Stored in a specific Docker directory | Stored in a location specified by the user |
| Safer in production | More risk involved with permissions and security |
| Can be removed by Docker to reset the data | Must be cleared manually to reset the data |

