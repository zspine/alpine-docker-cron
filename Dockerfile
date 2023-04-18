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
