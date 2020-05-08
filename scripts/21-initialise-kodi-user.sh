#!/bin/bash

set -e

WaitForDBRootAccess(){
   if [ -z "${MYSQL_ROOT_PASSWORD}" ]; then
      echo "Database root access is required. Cannot continue"
      sleep 600
      exit 1
   fi
   while ! mysqladmin ping --host=mariadb --user=root --password="${MYSQL_ROOT_PASSWORD}" --silent; do
      echo "Waiting for root access to database server..." 
      local counter=$(("${counter:=0}" + 1))
      if [ "${counter}" -eq 6 ]; then echo "Database server is taking a long time to respond"; fi
      if [ "${counter}" -gt 12 ]; then echo "Database server is taking a long time to respond using credentials - root:${MYSQL_ROOT_PASSWORD}"; fi
      sleep 10
      if [ "${counter}" -eq 30 ]; then echo "Database server is unavailable. Cannot continue"; sleep 600; exit 1; fi
   done
}

CreateKodiUser(){
   kodi_user_exists="$(mysql --host=mariadb --user=root --password="${MYSQL_ROOT_PASSWORD}" --skip-column-names --execute="SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = 'kodi');")"
   if [ "${kodi_user_exists}" -eq 0 ]; then
      echo "Creating user kodi and granting privileges to the ${kodi_music_db} and ${kodi_videos_db} Dbs"
      mysql --host=mariadb --user=root --password="${MYSQL_ROOT_PASSWORD}" --execute="CREATE USER 'kodi' IDENTIFIED BY '${kodi_password}';"
      mysql --host=mariadb --user=root --password="${MYSQL_ROOT_PASSWORD}" --execute="GRANT ALL ON ${kodi_music_db}.* TO 'kodi';"
      mysql --host=mariadb --user=root --password="${MYSQL_ROOT_PASSWORD}" --execute="GRANT ALL ON ${kodi_videos_db}.* TO 'kodi';"
      mysql --host=mariadb --user=root --password="${MYSQL_ROOT_PASSWORD}" --execute="flush privileges;"
   else
      echo "Kodi user already exists"
   fi
}

if [ -f "/init_kodi_user" ]; then
   WaitForDBRootAccess
   CreateKodiUser
   rm -f "/init_kodi_user"
fi