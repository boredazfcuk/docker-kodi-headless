#!/bin/bash

set -e

if [ -f "/init_advanced_settings" ]; then
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Initialise advanced settings"

   if [ "${kodi_debug_logging}" ]; then
      echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Enable debug logging"
      sed -i "/^<advancedsettings>$/ a<loglevel>1<\/loglevel>" "${user_data_dir}/advancedsettings.xml"
   else
      echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Debug logging not enabled"
      sed -i "/loglevel/d" "${user_data_dir}/advancedsettings.xml"
   fi

   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Configure Kodi video database host, user and password"
   sed -i "/^<videodatabase>$/,/^<\/videodatabase>$/ s%^<host>.*<\/host>*%<host>mariadb<\/host>%" "${user_data_dir}/advancedsettings.xml"
   sed -i "/^<videodatabase>$/,/^<\/videodatabase>$/ s%^<user>.*<\/user>*%<user>kodi<\/user>%" "${user_data_dir}/advancedsettings.xml"
   sed -i "/^<videodatabase>$/,/^<\/videodatabase>$/ s%^<pass>.*<\/pass>*%<pass>${kodi_password}<\/pass>%" "${user_data_dir}/advancedsettings.xml"

   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Configure Kodi music database host, user and password"
   sed -i "/^<musicdatabase>$/,/^<\/musicdatabase>$/ s%^<host>.*<\/host>*%<host>mariadb<\/host>%" "${user_data_dir}/advancedsettings.xml"
   sed -i "/^<musicdatabase>$/,/^<\/musicdatabase>$/ s%^<user>.*<\/user>*%<user>kodi<\/user>%" "${user_data_dir}/advancedsettings.xml"
   sed -i "/^<musicdatabase>$/,/^<\/musicdatabase>$/ s%^<pass>.*<\/pass>*%<pass>${kodi_password}<\/pass>%" "${user_data_dir}/advancedsettings.xml"

   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Configure Kodi webserver password"
   sed -i "/^<services>$/,/^<\/services>$/ s%^<webserverpassword>.*<\/webserverpassword>*%<webserverpassword>${kodi_password}<\/webserverpassword>%" "${user_data_dir}/advancedsettings.xml"

   if [ "$(grep -c cleanonupdate "${user_data_dir}/advancedsettings.xml")" -eq 0 ]; then
      echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Enable library cleaning"
      sed -i "/^<videolibrary>$/ a<cleanonupdate>true<\/cleanonupdate>" "${user_data_dir}/advancedsettings.xml"
      sed -i "/^<musiclibrary>$/ a<cleanonupdate>true<\/cleanonupdate>" "${user_data_dir}/advancedsettings.xml"
   fi

   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Configure single connection for Event Server"
   sed -i "s%<esportrange>.*</esportrange>%<esportrange>1</esportrange>%" "${user_data_dir}/advancedsettings.xml"

   rm -f "/init_advanced_settings"

fi