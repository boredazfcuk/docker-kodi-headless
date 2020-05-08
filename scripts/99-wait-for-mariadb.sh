#!/bin/bash

set -e

while [ "$(mysql --host=mariadb --user=kodi --password="${kodi_password}" --execute="SELECT User FROM mysql.user;" 2>/dev/null | grep -c kodi)" = 0 ]; do
   echo "Waiting for database server to come online..." 
   sleep 10
   counter=$(("${counter:=0}" + 1))
   if [ "${counter}" = 6 ]; then echo "Database server is taking a long time to respond"; fi
   if [ "${counter}" -gt 12 ]; then echo "Database server is unavailable using credentials - kodi:${kodi_password}"; fi
done