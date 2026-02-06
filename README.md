*This project has been created as part of the 42 curriculum by vsanin* 

# Inception
## Description

This project demonstrates the creation of a small infrastructure composed of several services using Docker. Its goal was to deepen the knowledge of Docker, containerization, Unix administration, shell scripting and networking.

The infrastructure consists of MariaDB, WordPress (+ php-fpm) and Nginx, each running in a separate container. The running containers are connected internally via Docker network. The only entrypoint to the infrastructure is through Nginx server, acting as a reverse proxy, on port 443 (HTTPS).


## Instructions

### Prerequisites

### Installation

### Running

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


## Project description


### Virtual Machines vs Docker


### Secrets vs Environment Variables


### Docker Network vs Host Network


### Docker Volumes vs Bind Mounts



## Tables

| Left columns  | Right columns |
| ------------- |:-------------:|
| left foo      | right foo     |
| left bar      | right bar     |
| left baz      | right baz     |

## Blocks of code

```
let message = 'Hello world';
alert(message);
```

## Inline code

This web site is using `markedjs/marked`.
