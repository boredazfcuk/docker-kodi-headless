#!/bin/bash

if [ "$(netcat -z "$(hostname -i)" 9090; echo $?)" -ne 0 ]; then
   echo "Kodi WebUI not responding on port 9090"
   exit 1
fi

kodi_video_db_server=$(cat "${user_data_dir}/advancedsettings.xml" | awk '/<videodatabase>/{flag=1; next} /<\/videodatabase>/{flag=0} flag' | grep -o -P '(?<=\<host>).*?(?=<\/host>)')
kodi_video_db_user=$(cat "${user_data_dir}/advancedsettings.xml" | awk '/<videodatabase>/{flag=1; next} /<\/videodatabase>/{flag=0} flag' | grep -o -P '(?<=\<user>).*?(?=<\/user>)')
kodi_video_db_password=$(cat "${user_data_dir}/advancedsettings.xml" | awk '/<videodatabase>/{flag=1; next} /<\/videodatabase>/{flag=0} flag' | grep -o -P '(?<=\<pass>).*?(?=<\/pass>)')
kodi_video_db_name=$(mysql --protocol=tcp --host "${kodi_video_db_server}" --user "${kodi_video_db_user}" --password="${kodi_video_db_password}" --execute="show databases;" --silent | grep MyVideo)
exit_code="$(mysql --protocol=tcp --host "${kodi_video_db_server}" --user "${kodi_video_db_user}" --password="${kodi_video_db_password}" --execute="use ${kodi_video_db_name}; select 1" 2>&1 >/dev/null | echo ${?})"
if [ "${exit_code}" != 0 ]; then
   echo "Video database not accessible"
   exit 1
fi

kodi_music_db_server=$(cat "${user_data_dir}/advancedsettings.xml" | awk '/<musicdatabase>/{flag=1; next} /<\/musicdatabase>/{flag=0} flag' | grep -o -P '(?<=\<host>).*?(?=<\/host>)')
kodi_music_db_user=$(cat "${user_data_dir}/advancedsettings.xml" | awk '/<musicdatabase>/{flag=1; next} /<\/musicdatabase>/{flag=0} flag' | grep -o -P '(?<=\<user>).*?(?=<\/user>)')
kodi_music_db_password=$(cat "${user_data_dir}/advancedsettings.xml" | awk '/<musicdatabase>/{flag=1; next} /<\/musicdatabase>/{flag=0} flag' | grep -o -P '(?<=\<pass>).*?(?=<\/pass>)')
kodi_music_db_name=$(mysql --protocol=tcp --host "${kodi_music_db_server}" --user "${kodi_music_db_user}" --password="${kodi_music_db_password}" --execute="show databases;" --silent | grep MyMusic)
exit_code="$(mysql --protocol=tcp --host "${kodi_music_db_server}" --user "${kodi_music_db_user}" --password="${kodi_music_db_password}" --execute="use ${kodi_music_db_name}; select 1" 2>&1 >/dev/null | echo ${?})"
if [ "${exit_code}" != 0 ]; then
   echo "Music database not accessible"
   exit 1
fi

echo "Kodi WebUI, Video database and Music database all accessible"
exit 0