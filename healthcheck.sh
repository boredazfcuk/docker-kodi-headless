#!/bin/bash

WEBSERVERUSERNAME=$(cat "${USERDATA}/advancedsettings.xml" | awk '/<services>/{flag=1; next} /<\/services>/{flag=0} flag' | grep -o -P '(?<=\<webserverusername>).*?(?=<\/webserverusername>)')
WEBSERVERPASSWORD=$(cat "${USERDATA}/advancedsettings.xml" | awk '/<services>/{flag=1; next} /<\/services>/{flag=0} flag' | grep -o -P '(?<=\<webserverpassword>).*?(?=<\/webserverpassword>)')
wget --quiet --tries=1 --user="${WEBSERVERUSERNAME}" --password="${WEBSERVERPASSWORD}" --spider "http://${HOSTNAME}:8080" || exit 1

VIDEODBSERVER=$(cat "${USERDATA}/advancedsettings.xml" | awk '/<videodatabase>/{flag=1; next} /<\/videodatabase>/{flag=0} flag' | grep -o -P '(?<=\<host>).*?(?=<\/host>)')
VIDEODBUSER=$(cat "${USERDATA}/advancedsettings.xml" | awk '/<videodatabase>/{flag=1; next} /<\/videodatabase>/{flag=0} flag' | grep -o -P '(?<=\<user>).*?(?=<\/user>)')
VIDEODBPASS=$(cat "${USERDATA}/advancedsettings.xml" | awk '/<videodatabase>/{flag=1; next} /<\/videodatabase>/{flag=0} flag' | grep -o -P '(?<=\<pass>).*?(?=<\/pass>)')
VIDEODBNAME=$(mysql --protocol=tcp --host "${VIDEODBSERVER}" --user "${VIDEODBUSER}" --password="${VIDEODBPASS}" --execute="show databases;" --silent | grep MyVideo)
mysql --protocol=tcp --host "${VIDEODBSERVER}" --user "${VIDEODBUSER}" --password="${VIDEODBPASS}" --execute="use ${VIDEODBNAME}; select 1" 2>&1 >/dev/null || exit 1

MUSICDBSERVER=$(cat "${USERDATA}/advancedsettings.xml" | awk '/<musicdatabase>/{flag=1; next} /<\/musicdatabase>/{flag=0} flag' | grep -o -P '(?<=\<host>).*?(?=<\/host>)')
MUSICDBUSER=$(cat "${USERDATA}/advancedsettings.xml" | awk '/<musicdatabase>/{flag=1; next} /<\/musicdatabase>/{flag=0} flag' | grep -o -P '(?<=\<user>).*?(?=<\/user>)')
MUSICDBPASS=$(cat "${USERDATA}/advancedsettings.xml" | awk '/<musicdatabase>/{flag=1; next} /<\/musicdatabase>/{flag=0} flag' | grep -o -P '(?<=\<pass>).*?(?=<\/pass>)')
MUSICDBNAME=$(mysql --protocol=tcp --host "${VIDEODBSERVER}" --user "${VIDEODBUSER}" --password="${VIDEODBPASS}" --execute="show databases;" --silent | grep MyMusic)
mysql --protocol=tcp --host "${VIDEODBSERVER}" --user "${VIDEODBUSER}" --password="${VIDEODBPASS}" --execute="use ${MUSICDBNAME}; select 1" 2>&1 >/dev/null || exit 1