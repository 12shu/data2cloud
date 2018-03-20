#!/bin/sh
service cron restart
sh /root/down.sh
sh /root/up.sh
$SHELL
