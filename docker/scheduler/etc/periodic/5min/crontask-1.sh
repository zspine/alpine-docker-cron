#!/usr/bin/env sh
echo 'Welcome to the demo of our amazing application!' >> /var/log/cron.log 2>&1
echo "$(date) Completed" >> /var/log/cron.log 2>&1

