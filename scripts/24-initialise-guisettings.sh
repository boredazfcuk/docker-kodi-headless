#!/bin/bash

Initialise(){
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Configure Kodi video database host, user and password"
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
}

ConfigureGUISettingsXML(){
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Enable background updates for music"
   sed -i \
      -e "/musiclibrary\.backgroundupdate/ s%>.*<%>true<%" \
      "${user_data_dir}/guisettings.xml"  

   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Enable background updates for videos"
   sed -i \
      -e "/videolibrary\.backgroundupdate/ s%>.*<%>true<%" \
      "${user_data_dir}/guisettings.xml"  

   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Enable startup scan for music"
   sed -i \
      -e "/musiclibrary\.updateonstartup/ s%>.*<%>true<%" \
      "${user_data_dir}/guisettings.xml" 
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Enable startup scan for videos"
   sed -i \
      -e "/videolibrary\.updateonstartup/ s%>.*<%>true<%" \
      "${user_data_dir}/guisettings.xml" 
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Display empty TV shows"
   sed -i \
      -e "/videolibrary\.showemptytvshows/ s%>.*<%>true<%" \
      "${user_data_dir}/guisettings.xml" 

   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Set default movie scraper"
   sed -i \
      -e "/scrapers\.moviesdefault/ s%>.*<%>${movie_scraper}<%" \
      "${user_data_dir}/guisettings.xml" 
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Set default tv show scraper"
   sed -i \
      -e "/scrapers\.tvshowsdefault/ s%>.*<%>${tv_scraper}<%" \
      "${user_data_dir}/guisettings.xml"
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Disable addons updates"
   sed -i \
      -e "/general\.addonupdates/ s%>.*<%>false<%" \
      "${user_data_dir}/guisettings.xml"
}

Initialise
ConfigureGUISettingsXML