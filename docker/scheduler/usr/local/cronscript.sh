#!/bin/sh
echo "*/5       *       *       *       *       run-parts /etc/periodic/5min" >> /etc/crontabs/root
crontab -l
