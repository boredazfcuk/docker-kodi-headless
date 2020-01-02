#!/bin/bash
EXITCODE=0
WEBSERVERUSERNAME=$(cat "${USERDATA}/advancedsettings.xml" | awk '/<services>/{flag=1; next} /<\/services>/{flag=0} flag' | grep -o -P '(?<=\<webserverusername>).*?(?=<\/webserverusername>)')
WEBSERVERPASSWORD=$(cat "${USERDATA}/advancedsettings.xml" | awk '/<services>/{flag=1; next} /<\/services>/{flag=0} flag' | grep -o -P '(?<=\<webserverpassword>).*?(?=<\/webserverpassword>)')
EXITCODE="$(wget --quiet --tries=1 --user="${WEBSERVERUSERNAME}" --password="${WEBSERVERPASSWORD}" --spider "http://${HOSTNAME}:8080" | echo ${?})"
if [ "${EXITCODE}" != 0 ]; then
   echo "Kodi WebUI not accessible"
   exit 1
fi

VIDEODBSERVER=$(cat "${USERDATA}/advancedsettings.xml" | awk '/<videodatabase>/{flag=1; next} /<\/videodatabase>/{flag=0} flag' | grep -o -P '(?<=\<host>).*?(?=<\/host>)')
VIDEODBUSER=$(cat "${USERDATA}/advancedsettings.xml" | awk '/<videodatabase>/{flag=1; next} /<\/videodatabase>/{flag=0} flag' | grep -o -P '(?<=\<user>).*?(?=<\/user>)')
VIDEODBPASS=$(cat "${USERDATA}/advancedsettings.xml" | awk '/<videodatabase>/{flag=1; next} /<\/videodatabase>/{flag=0} flag' | grep -o -P '(?<=\<pass>).*?(?=<\/pass>)')
VIDEODBNAME=$(mysql --protocol=tcp --host "${VIDEODBSERVER}" --user "${VIDEODBUSER}" --password="${VIDEODBPASS}" --execute="show databases;" --silent | grep MyVideo)
EXITCODE="$(mysql --protocol=tcp --host "${VIDEODBSERVER}" --user "${VIDEODBUSER}" --password="${VIDEODBPASS}" --execute="use ${VIDEODBNAME}; select 1" 2>&1 >/dev/null | echo ${?})"
if [ "${EXITCODE}" != 0 ]; then
   echo "Video database not accessible"
   exit 1
fi

MUSICDBSERVER=$(cat "${USERDATA}/advancedsettings.xml" | awk '/<musicdatabase>/{flag=1; next} /<\/musicdatabase>/{flag=0} flag' | grep -o -P '(?<=\<host>).*?(?=<\/host>)')
MUSICDBUSER=$(cat "${USERDATA}/advancedsettings.xml" | awk '/<musicdatabase>/{flag=1; next} /<\/musicdatabase>/{flag=0} flag' | grep -o -P '(?<=\<user>).*?(?=<\/user>)')
MUSICDBPASS=$(cat "${USERDATA}/advancedsettings.xml" | awk '/<musicdatabase>/{flag=1; next} /<\/musicdatabase>/{flag=0} flag' | grep -o -P '(?<=\<pass>).*?(?=<\/pass>)')
MUSICDBNAME=$(mysql --protocol=tcp --host "${MUSICDBSERVER}" --user "${MUSICDBUSER}" --password="${MUSICDBPASS}" --execute="show databases;" --silent | grep MyMusic)
EXITCODE="$(mysql --protocol=tcp --host "${MUSICDBSERVER}" --user "${MUSICDBUSER}" --password="${MUSICDBPASS}" --execute="use ${MUSICDBNAME}; select 1" 2>&1 >/dev/null | echo ${?})"
if [ "${EXITCODE}" != 0 ]; then
   echo "Music database not accessible"
   exit 1
fi

echo "Kodi WebUI, Video database and Music database all accessible"
exit 0