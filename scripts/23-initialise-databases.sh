#!/bin/bash

set -e

Initialise(){
   IFS=,
   video_id=1
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Music Db name: ${kodi_music_db:=MyMusic172}"
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Videos Db name: ${kodi_videos_db:=MyVideos116}"
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Music locations: ${music_dirs:=/storage/music/}"
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Video locations: ${video_dirs:=/storage/videos/}"
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    TV locations: ${tv_dirs:=/storage/tvshows/}"
   certification_country="$(echo ${certification_country:=us} | tr '[:upper:]' '[:lower:]')"
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Certification country: ${certification_country}"
   # No certification prefix specified, use default
   if [ -z "${certification_prefix}" ]; then echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Certification prefix: ${certification_prefix:=Rated}"; fi
   certification_prefix="${certification_prefix} "
   # If certification_prefix is set to 'none', unset certification_prefix, so removed from xml config
   if [ "${certification_prefix/ /}" = "none" ]; then echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Certification prefix: <none>"; unset certification_prefix; fi
}

WaitForDbKodiAccess(){
   while [ "$(mysql --host=mariadb --user=kodi --password="${kodi_password}" --execute="SELECT 1;" 2>/dev/null | grep -c 1)" -ne 2 ]; do
      echo "Waiting for kodi user acces to database server to come online..." 
      local counter=$(("${counter:=0}" + 1))
      if [ "${counter}" -eq 6 ]; then echo "Database server is taking a long time to respond"; fi
      if [ "${counter}" -gt 12 ]; then echo "Database server is taking a long time to respond using credentials - kodi:${kodi_password}"; fi
      sleep 10
      if [ "${counter}" -eq 30 ]; then echo "Database server is unavailable. Cannot continue"; sleep 600; exit 1; fi
   done
   # If either Db doesn't exist, enable Db query logging, force 
   if ! mysql --host=mariadb --user=kodi --password="${kodi_password}" --execute="use ${kodi_music_db};"; then
      touch "/init_dbs"
   fi
   if ! mysql --host=mariadb --user=kodi --password="${kodi_password}" --execute="use ${kodi_videos_db};"; then
      touch "/init_dbs"
   fi
}

StartKODI(){
   if [ ! -d "/config/.kodi/temp/" ]; then mkdir "/config/.kodi/temp"; touch "/config/.kodi/temp/kodi.log"; chown -R abc:abc /config; fi
   tail -qFn0 "/config/.kodi/temp/kodi.log" >/dev/null 2>&1 &
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Create default configuration"
   /usr/bin/kodi --headless &
   sleep 10
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Kodi initialisation complete"
}

EnableAddons(){
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Configure Addons database"
   while [ ! -f "${user_data_dir}/Database/Addons27.db" ]; do
      echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Waiting for Addons database to be created"
      sleep 5
   done
   sleep 5
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Enable dateutil script addon"
   sqlite3 "${user_data_dir}/Database/Addons27.db" 'update installed set enabled=1 where addonid=="script.module.dateutil";'
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Enable future addon"
   sqlite3 "${user_data_dir}/Database/Addons27.db" 'update installed set enabled=1 where addonid=="script.module.future";'
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Enable six script addon"
   sqlite3 "${user_data_dir}/Database/Addons27.db" 'update installed set enabled=1 where addonid=="script.module.six";'
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Enable kodi-six script addon"
   sqlite3 "${user_data_dir}/Database/Addons27.db" 'update installed set enabled=1 where addonid=="script.module.kodi-six";'
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Enable library auto-update service addon"
   sqlite3 "${user_data_dir}/Database/Addons27.db" 'update installed set enabled=1 where addonid=="service.libraryautoupdate";'
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Enable universal album scraper metadata addon"
   sqlite3 "${user_data_dir}/Database/Addons27.db" 'update installed set enabled=1 where addonid=="metadata.album.universal";'
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Enable universal artist metadata addon"
   sqlite3 "${user_data_dir}/Database/Addons27.db" 'update installed set enabled=1 where addonid=="metadata.artists.universal";'
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Enable allmusic.com metadata addon"
   sqlite3 "${user_data_dir}/Database/Addons27.db" 'update installed set enabled=1 where addonid=="metadata.common.allmusic.com";'
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Enable fanart.tv metadata addon"
   sqlite3 "${user_data_dir}/Database/Addons27.db" 'update installed set enabled=1 where addonid=="metadata.common.fanart.tv";'
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Enable imdb metadata addon"
   sqlite3 "${user_data_dir}/Database/Addons27.db" 'update installed set enabled=1 where addonid=="metadata.common.imdb.com";'
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Enable ofdb metadata addon"
   sqlite3 "${user_data_dir}/Database/Addons27.db" 'update installed set enabled=1 where addonid=="metadata.common.ofdb.de";'
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Enable omdbapi metadata addon"
   sqlite3 "${user_data_dir}/Database/Addons27.db" 'update installed set enabled=1 where addonid=="metadata.common.omdbapi.com";'
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Enable theaudiodb metadata addon"
   sqlite3 "${user_data_dir}/Database/Addons27.db" 'update installed set enabled=1 where addonid=="metadata.common.theaudiodb.com";'
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Enable tmdb metadata addon"
   sqlite3 "${user_data_dir}/Database/Addons27.db" 'update installed set enabled=1 where addonid=="metadata.common.themoviedb.org";'
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Enable tmdb tvshows metadata addon"
   sqlite3 "${user_data_dir}/Database/Addons27.db" 'update installed set enabled=1 where addonid=="metadata.tvshows.themoviedb.org";'
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Enable universal movie scraper metadata addon"
   sqlite3 "${user_data_dir}/Database/Addons27.db" 'update installed set enabled=1 where addonid=="metadata.universal";'
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Enable globalsearch script addon"
   sqlite3 "${user_data_dir}/Database/Addons27.db" 'update installed set enabled=1 where addonid=="script.globalsearch";'
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Enable certifi script addon"
   sqlite3 "${user_data_dir}/Database/Addons27.db" 'update installed set enabled=1 where addonid=="script.module.certifi";'
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Enable chardet script addon"
   sqlite3 "${user_data_dir}/Database/Addons27.db" 'update installed set enabled=1 where addonid=="script.module.chardet";'
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Enable idna script addon"
   sqlite3 "${user_data_dir}/Database/Addons27.db" 'update installed set enabled=1 where addonid=="script.module.idna";'
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Enable requests script addon"
   sqlite3 "${user_data_dir}/Database/Addons27.db" 'update installed set enabled=1 where addonid=="script.module.requests";'
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Enable urllib3 script addon"
   sqlite3 "${user_data_dir}/Database/Addons27.db" 'update installed set enabled=1 where addonid=="script.module.urllib3";'
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Enable versioncheck script addon"
   sqlite3 "${user_data_dir}/Database/Addons27.db" 'update installed set enabled=1 where addonid=="service.xbmc.versioncheck";'
}

WaitForVideosDB(){
   while [ -z "${kodi_videos_db}" ]; do
      echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Wait for video database to be created..."
      kodi_videos_db="$(mysql --protocol=tcp --host mariadb --user kodi --password="${kodi_password}" --execute="show databases;" --silent | grep MyVideo)"
      sleep 1
   done
}

WaitForMusicDB(){
   while [ -z "${kodi_music_db}" ]; do
      echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Wait for music database to be created by the database server..."
      kodi_music_db="$(mysql --protocol=tcp --host mariadb --user kodi --password="${kodi_password}" --execute="show databases;" --silent | grep MyMusic)"
      sleep 1
   done
}

AddVideoLocations(){
   for video_dir in ${video_dirs}; do
      echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Checking for ${video_dir} in Db"
      path_exists="$(mysql --host=mariadb --user=kodi --password="${kodi_password}" --skip-column-names --execute="use ${kodi_videos_db}; select 1 from path where strPath='${video_dir}';")"
      if [ -z "${path_exists}" ]; then
         echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Adding movie content path to database: ${video_dir}"
         # Create record
         mysql --host=mariadb --user=kodi --password="${kodi_password}" --execute="use ${kodi_videos_db}; insert into path (idPath, strPath) values (NULL, '${video_dir}');"
         # Create default settings
         mysql --host=mariadb --user=kodi --password="${kodi_password}" --execute="use ${kodi_videos_db}; update path set strContent='', strScraper='', scanRecursive=0, useFolderNames=0, strSettings='', noUpdate=0, exclude=1 where idPath=${video_id};"
         # Set custom configuration
         mysql --host=mariadb --user=kodi --password="${kodi_password}" --execute="use ${kodi_videos_db}; update path set strContent='movies', strScraper='metadata.themoviedb.org', scanRecursive=2147483647, useFolderNames=1, strSettings='<settings version=\"2\"><setting id=\"certprefix\" default=\"true\">${certification_prefix}</setting><setting id=\"fanart\">true</setting><setting id=\"imdbanyway\" default=\"true\">false</setting><setting id=\"keeporiginaltitle\">true</setting><setting id=\"language\" default=\"true\">en</setting><setting id=\"RatingS\" default=\"true\">TMDb</setting><setting id=\"tmdbcertcountry\">${certification_country}</setting><setting id=\"trailer\">false</setting></settings>', noUpdate=0, exclude=0 where idPath=${video_id};"
   #      mysql --host=mariadb --user=kodi --password="${kodi_password}" --execute="use ${kodi_videos_db}; insert into path (idPath, strPath) values (NULL, '${video_dir}'); update path set strContent='', strScraper='', scanRecursive=0, useFolderNames=0, strSettings='', noUpdate=0, exclude=1 where idPath=${video_id}; update path set strContent='movies', strScraper='metadata.themoviedb.org', scanRecursive=2147483647, useFolderNames=1, strSettings='<settings version=\"2\"><setting id=\"certprefix\" default=\"true\">${certification_prefix}</setting><setting id=\"fanart\">true</setting><setting id=\"imdbanyway\" default=\"true\">false</setting><setting id=\"keeporiginaltitle\">true</setting><setting id=\"language\" default=\"true\">en</setting><setting id=\"RatingS\" default=\"true\">TMDb</setting><setting id=\"tmdbcertcountry\">${certification_country}</setting><setting id=\"trailer\">false</setting></settings>', noUpdate=0, exclude=0 where idPath=${video_id};"
         video_id=$((video_id + 1))
      else
         echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Movie path already exists in Db: ${video_dir}"
      fi
   done
}

AddTVLocations(){
   for tv_dir in ${tv_dirs}; do
      echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Adding tv content path to database: ${tv_dir}"
      path_exists="$(mysql --host=mariadb --user=kodi --password="${kodi_password}" --skip-column-names --execute="use ${kodi_videos_db}; select 1 from path where strPath='${tv_dir}';")"
      if [ -z "${path_exists}" ]; then
         # Create record
         mysql --host=mariadb --user=kodi --password="${kodi_password}" --execute="use ${kodi_videos_db}; insert into path (idPath, strPath) values (NULL, '${tv_dir}');"
         # Create default settings
         mysql --host=mariadb --user=kodi --password="${kodi_password}" --execute="use ${kodi_videos_db}; update path set strContent='', strScraper='', scanRecursive=0, useFolderNames=0, strSettings='', noUpdate=0, exclude=1 where idPath=${video_id};"
         # Set custom configuration
         mysql --host=mariadb --user=kodi --password="${kodi_password}" --execute="use ${kodi_videos_db}; update path set strContent='tvshows', strScraper='metadata.tvshows.themoviedb.org', scanRecursive=0, useFolderNames=0, strSettings='<settings version=\"2\"><setting id=\"fanarttvart\">true</setting><setting id=\"keeporiginaltitle\" default=\"true\">false</setting><setting id=\"language\" default=\"true\">en</setting><setting id=\"tmdbart\">true</setting></settings>', noUpdate=0, exclude=0 where idPath=${video_id};"
   #      mysql --host=mariadb --user=kodi --password="${kodi_password}" --execute="use ${kodi_videos_db}; insert into path (idPath, strPath) values (NULL, '${tv_dir}'); update path set strContent='', strScraper='', scanRecursive=0, useFolderNames=0, strSettings='', noUpdate=0, exclude=1 where idPath=${video_id}; update path set strContent='tvshows', strScraper='metadata.tvshows.themoviedb.org', scanRecursive=0, useFolderNames=0, strSettings='<settings version=\"2\"><setting id=\"fanarttvart\">true</setting><setting id=\"keeporiginaltitle\" default=\"true\">false</setting><setting id=\"language\" default=\"true\">en</setting><setting id=\"tmdbart\">true</setting></settings>', noUpdate=0, exclude=0 where idPath=${video_id};"
         video_id=$((video_id + 1))
      else
         echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Movie path already exists in Db: ${tv_dir}"
      fi
   done
}

AddMusicLocations(){
   for music_dir in ${music_dirs}; do
      echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Adding music content path to database: ${music_dir}"
      path_exists="$(mysql --host=mariadb --user=kodi --password="${kodi_password}" --skip-column-names --execute="use ${kodi_videos_db}; select 1 from path where strPath='${music_dir}';")"
      if [ -z "${path_exists}" ]; then
         # Create record
         mysql --host=mariadb --user=kodi --password="${kodi_password}" --execute="use ${kodi_music_db}; insert into path (idPath, strPath) values (NULL, '${music_dir}');"
      else
         echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Movie path already exists in Db: ${music_dir}"
      fi
   done
}

RestartContainer(){
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Restart container"
   pkill -u 0
}

##### Start #####
Initialise
WaitForDbKodiAccess
# Fire up Kodi to create the default config
if [ -f "/init_dbs" ]; then
   StartKODI
   WaitForVideosDB
   WaitForMusicDB
   AddVideoLocations
   AddTVLocations
   AddMusicLocations
fi
if [ -f "/init_addons" ]; then
   EnableAddons
fi
if [ -f "/init_dbs" ] && [ -f "/init_addons" ]; then
   rm -f "/init_dbs" "/init_addons"
   RestartContainer
fi