# Alpine Docker Cron with Docker Compose

This tutorial provides a working example of configuring a cron job with an Alpine Docker image and Docker Compose. The example consists of a PHP application using `php:8.2-fpm-alpine` image and a cron job set to run every 5 minutes. The cron job prints a message to the log file when it completes. The following files are used:

1. `docker-compose.yaml`
2. `Dockerfile`
3. `cronscript.sh`
4. `crontask-1.sh`

## File Overview

### 1. docker-compose.yaml

This file defines the `php` service using the `Dockerfile` for building the image. The `command` attribute is set to run the `crond` daemon in the foreground with log level 8.

```yaml
version: "3.4"

services:
  php:
    build:
      context: .
      target: dev_tester
    command: sh -c "crond -f -l 8"
```

### 2. Dockerfile

This file builds the `php:8.2-fpm-alpine` image, creates a log file, and sets up the cron job with required permissions. It also copies the `cronscript.sh` and `crontask-1.sh` files to the appropriate locations.

```dockerfile
FROM php:8.2-fpm-alpine AS dev_tester

RUN apk update && apk add --no-cache

ENV APP_ENV=prod
WORKDIR /srv/app

# Create the log file to be able to run tail
RUN touch /var/log/cron.log
RUN mkdir -p /etc/periodic/5min

COPY docker/scheduler/usr/local/cronscript.sh /usr/local/bin/cronscript.sh
COPY docker/scheduler/etc/periodic/5min/crontask-1.sh /etc/periodic/5min/crontask-1.sh
RUN chmod +x /usr/local/bin/cronscript.sh
RUN chmod +x /etc/periodic/5min/crontask-1.sh

# Add crontab entry
RUN echo "*/5       *       *       *       *       run-parts /etc/periodic/5min" > /etc/crontabs/root

CMD ["php-fpm"]
```

### 3. cronscript.sh

This script appends the cron job entry to the root crontab file and lists the crontab content.

```sh
#!/bin/sh
echo "*/5       *       *       *       *       run-parts /etc/periodic/5min" >> /etc/crontabs/root
crontab -l
```

### 4. crontask-1.sh

This script is the actual cron job that runs every 5 minutes. It writes a message to the log file and appends the current date and time when it completes.

```sh
#!/usr/bin/env sh
echo 'Welcome to the demo of our amazing application!' >> /var/log/cron.log 2>&1
echo "$(date) Completed" >> /var/log/cron.log 2>&1
```
