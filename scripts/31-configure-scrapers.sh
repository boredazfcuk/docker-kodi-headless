#!/bin/bash

set -e

Initialise(){
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Music locations: ${music_dirs:=/storage/music/}"
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Video locations: ${video_dirs:=/storage/videos/}"
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    TV locations: ${tv_dirs:=/storage/tvshows/}"
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Certification country: ${certification_country:=us}"
   # No certification prefix specified, use default
   if [ -z "${certification_prefix}" ]; then echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Certification prefix: ${certification_prefix:=Rated}"; fi
   certification_prefix="${certification_prefix} "
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Scraper: ${scraper:=tmdb}"
   if [ "${scraper}" = "tmdb" ]; then
      movie_scraper="metadata.themoviedb.org"
      tv_scraper="metadata.tvshows.themoviedb.org"
   elif [ "${scraper}" = "universal" ]; then
      movie_scraper="metadata.universal"
      tv_scraper="metadata.tvshows.themoviedb.org"
   else
      echo "$(date '+%Y-%m-%d %H:%M:%S') ERROR:  Scraper not recognised - Exiting."
      sleep 600
      exit 1
   fi
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Movie scraper name: ${movie_scraper}"
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    TV scraper name: ${tv_scraper}"
   # If certification_prefix is set to 'none', unset certification_prefix, so removed from xml config
   if [ "${certification_prefix/ /}" = "none" ]; then echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Certification prefix: <none>"; unset certification_prefix; fi
   kodi_videos_db="$(mysql --protocol=tcp --host mariadb --user kodi --password="${kodi_password}" --execute="show databases;" --silent | grep MyVideo)"
   kodi_music_db="$(mysql --protocol=tcp --host mariadb --user kodi --password="${kodi_password}" --execute="show databases;" --silent | grep MyMusic)"
}

SetCertificationCountry(){
   sed -i \
      -e "s/id=\"tmdbcertcountry\" default=\".*\"/id=\"tmdbcertcountry\" default=\"${certification_country}\"/" \
      "/config/.kodi/addons/metadata.universal/resources/settings.xml"
   sed -i \
      -e "s/id=\"tmdbcertcountry\" default=\".*\"/id=\"tmdbcertcountry\" default=\"${certification_country}\"/" \
      "/config/.kodi/addons/metadata.universal/universal.xml"
   sed -i \
      -e "s/id=\"tmdbcertcountry\" default=\".*\"/id=\"tmdbcertcountry\" default=\"${certification_country}\"/" \
      "/config/.kodi/addons/metadata.tvshows.themoviedb.org/resources/settings.xml"
}

SetCertificationPrefix(){
   if [ -z "${certification_prefix}" ]; then
      sed -i \
         -e "s/id=\"certprefix\" default=\".*\"/id=\"certprefix\" default=\"Rated \"/" \
         "/config/.kodi/addons/metadata.themoviedb.org/resources/settings.xml"
      sed -i \
         -e "/certprefix/ s%>.*<%><%" \
         "${user_data_dir}/addon_data/metadata.universal/settings.xml"
   else
      sed -i \
         -e "s/id=\"certprefix\" default=\".*\"/id=\"certprefix\" default=\"${certification_prefix}\"/" \
         "/config/.kodi/addons/metadata.themoviedb.org/resources/settings.xml"
      sed -i \
         -e "/certprefix/ s%>.*<%>${certification_prefix}<%" \
         "${user_data_dir}/addon_data/metadata.universal/settings.xml"
   fi
}

SetDefaultScraper(){
   if [ "${scraper}" = "tmdb" ]; then
      sed -i \
         -e "/scrapers.moviesdefault/ s%>.*<%>metadata.themoviedb.org<%" \
         -e "/scrapers.tvshowsdefault/ s%>.*<%>metadata.tvshows.themoviedb.org<%" \
         "${user_data_dir}/guisettings.xml"
   elif [ "${scraper}" = "universal" ]; then
      sed -i \
         -e "/scrapers.moviesdefault/ s%>.*<%>metadata.universal<%" \
         -e "/scrapers.tvshowsdefault/ s%>.*<%>metadata.universal<%" \
         "${user_data_dir}/guisettings.xml"
   else
      echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Scraper ${scraper} not recognised. Exiting"
      sleep 120
      exit 1
   fi
}

UpdateVideoScraper(){
   local path_exists_in_db
   for video_dir in ${video_dirs}; do
      echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Checking for ${video_dir} in Db"
      path_exists_in_db="$(mysql --host=mariadb --user=kodi --password="${kodi_password}" --skip-column-names --execute="use ${kodi_videos_db}; select 1 from path where strPath='${video_dir}';")"
      if [ "${path_exists_in_db}" ]; then
         echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Movie content path ${video_dir} already exists in database"
         current_scraper="$(mysql --host=mariadb --user=kodi --password="${kodi_password}" --skip-column-names --execute="use ${kodi_videos_db}; SELECT strScraper from path WHERE strPath='${video_dir}';")"
         echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Current scraper: ${current_scraper}"
         if [ "${movie_scraper}" != "${current_scraper}" ]; then
            echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Changing scraper to ${scraper}"
            if [ "${scraper}" = "universal" ]; then
               # Grab universal settings
               scraper_settings="$(cat /config/universal.xml| tr -d '\n')"
            fi
            if [ "${scraper}" = "tmdb" ]; then
               # Grab tmdb settings
               scraper_settings="$(cat /config/tmdb.xml| tr -d '\n')"
            fi
            # Change scraper
            mysql --host=mariadb --user=kodi --password="${kodi_password}" --execute="use ${kodi_videos_db}; update path set strContent='movies', strScraper='${movie_scraper}', scanRecursive=2147483647, useFolderNames=1, strSettings='${scraper_settings}', noUpdate=0, exclude=0 where path=${video_dir};"
         fi
      else
         echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Movie path does not exist in Db: ${video_dir}"
      fi
   done
}

UpdateTVTVScraper(){
   local path_exists_in_db
   for tv_dir in ${tv_dirs}; do
      echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Checking for ${tv_dir} in Db"
      path_exists_in_db="$(mysql --host=mariadb --user=kodi --password="${kodi_password}" --skip-column-names --execute="use ${kodi_videos_db}; select 1 from path where strPath='${tv_dir}';")"
      # if [ "${path_exists}" ]; then
         # # Set tv scraper
         # if [ "${scraper}" = "tmdb" ]; then
            # mysql --host=mariadb --user=kodi --password="${kodi_password}" --execute="use ${kodi_videos_db}; update path set strContent='tvshows', strScraper='${tv_scraper}', scanRecursive=0, useFolderNames=0, strSettings='<settings version=\"2\"><setting id=\"fanarttvart\">true</setting><setting id=\"keeporiginaltitle\" default=\"true\">false</setting><setting id=\"language\" default=\"true\">en</setting><setting id=\"tmdbart\">true</setting></settings>', noUpdate=0, exclude=0 where path=${tv_dir};"
         # fi
         # if [ "${scraper}" = "universal" ]; then
            # # Same as tmdb as no universal tv show scraper exists
            # mysql --host=mariadb --user=kodi --password="${kodi_password}" --execute="use ${kodi_videos_db}; update path set strContent='tvshows', strScraper='${tv_scraper}', scanRecursive=0, useFolderNames=0, strSettings='<settings version=\"2\"><setting id=\"fanarttvart\">true</setting><setting id=\"keeporiginaltitle\" default=\"true\">false</setting><setting id=\"language\" default=\"true\">en</setting><setting id=\"tmdbart\">true</setting></settings>', noUpdate=0, exclude=0 where path=${tv_dir};"
         # fi
      # else
         # echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    TV path does not exist in Db: ${tv_dir}"
      # fi
   done
}

UpdateMusicScraper(){
   local path_exists_in_db
   for music_dir in ${music_dirs}; do
      echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Checking for ${music_dir} in Db"
      path_exists_in_db="$(mysql --host=mariadb --user=kodi --password="${kodi_password}" --skip-column-names --execute="use ${kodi_videos_db}; select 1 from path where strPath='${music_dir}';")"
      # if [ "${path_exists}" ]; then
         # # Create record
         # mysql --host=mariadb --user=kodi --password="${kodi_password}" --execute="use ${kodi_music_db}; insert into path (idPath, strPath) values (NULL, '${music_dir}');"
      # else
         # echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Music path does not exist in Db: ${music_dir}"
      # fi
   done
}

Initialise
SetCertificationCountry
SetCertificationPrefix
SetDefaultScraper
UpdateVideoScraper
#UpdateTVTVScraper
#UpdateMusicScraper