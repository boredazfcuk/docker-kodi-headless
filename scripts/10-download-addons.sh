#!/bin/bash

set -e

config_dir="/config"

DownloadAddons(){
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Download addons"
   mkdir -p "${config_dir}/.kodi/addons/packages"

   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Download python-dateutil addon"
   latest_dateutil="$(curl -sX GET "http://mirrors.kodi.tv/addons/leia/script.module.dateutil/" | awk '/dateutil/{print $4}' FS='"' | grep -v "^$" | tail -n1)"
   curl -so "${config_dir}/.kodi/addons/packages/${latest_dateutil}" -L "http://mirrors.kodi.tv/addons/leia/script.module.dateutil/${latest_dateutil}"
   unzip -q "${config_dir}/.kodi/addons/packages/${latest_dateutil}" -d "${config_dir}/.kodi/addons"

   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Download future addon"
   latest_future="$(curl -sX GET "http://mirrors.kodi.tv/addons/leia/script.module.future/" | awk '/future/{print $4}' FS='"' | grep -v "^$" | tail -n1)"
   curl -so "${config_dir}/.kodi/addons/packages/${latest_future}" -L "http://mirrors.kodi.tv/addons/leia/script.module.future/${latest_future}"
   unzip -q "${config_dir}/.kodi/addons/packages/${latest_future}" -d "${config_dir}/.kodi/addons"

   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Download six addon"
   latest_six="$(curl -sX GET "http://mirrors.kodi.tv/addons/leia/script.module.six/" | awk '/six/{print $4}' FS='"' | grep -v "^$" | tail -n1)"
   curl -so "${config_dir}/.kodi/addons/packages/${latest_six}" -L "http://mirrors.kodi.tv/addons/leia/script.module.six/${latest_six}"
   unzip -q "${config_dir}/.kodi/addons/packages/${latest_six}" -d "${config_dir}/.kodi/addons"

   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Download kodi-six addon"
   latest_kodi_six="$(curl -sX GET "http://mirrors.kodi.tv/addons/leia/script.module.kodi-six/" | awk '/kodi-six/{print $4}' FS='"' | grep -v "^$" | tail -n1)"
   curl -so "${config_dir}/.kodi/addons/packages/${latest_kodi_six}" -L "http://mirrors.kodi.tv/addons/leia/script.module.kodi-six/${latest_kodi_six}"
   unzip -q "${config_dir}/.kodi/addons/packages/${latest_kodi_six}" -d "${config_dir}/.kodi/addons"

   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Download library auto-update addon"
   latest_library_auto_update="$(curl -sX GET "http://mirrors.kodi.tv/addons/leia/service.libraryautoupdate/" | awk '/libraryautoupdate/{print $4}' FS='"' | grep -v "^$" | tail -n1)"
   curl -so "${config_dir}/.kodi/addons/packages/${latest_library_auto_update}" -L "http://mirrors.kodi.tv/addons/leia/service.libraryautoupdate/${latest_library_auto_update}"
   unzip -q "${config_dir}/.kodi/addons/packages/${latest_library_auto_update}" -d "${config_dir}/.kodi/addons"

   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Download universal album scraper"
   latest_universal_album_scraper="$(curl -sX GET "http://mirrors.kodi.tv/addons/leia/metadata.album.universal/" | awk '/universal/{print $4}' FS='"' | grep -v "^$" | tail -n1)"
   curl -so "${config_dir}/.kodi/addons/packages/${latest_universal_album_scraper}" -L "http://mirrors.kodi.tv/addons/leia/metadata.album.universal/${latest_universal_album_scraper}"
   unzip -q "${config_dir}/.kodi/addons/packages/${latest_universal_album_scraper}" -d "${config_dir}/.kodi/addons"

   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Download universal artist scraper"
   latest_universal_artist_scraper="$(curl -sX GET "http://mirrors.kodi.tv/addons/leia/metadata.artists.universal/" | awk '/universal/{print $4}' FS='"' | grep -v "^$" | tail -n1)"
   curl -so "${config_dir}/.kodi/addons/packages/${latest_universal_artist_scraper}" -L "http://mirrors.kodi.tv/addons/leia/metadata.artists.universal/${latest_universal_artist_scraper}"
   unzip -q "${config_dir}/.kodi/addons/packages/${latest_universal_artist_scraper}" -d "${config_dir}/.kodi/addons"

   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Download allmusic.com scraper"
   latest_allmusic_scraper="$(curl -sX GET "http://mirrors.kodi.tv/addons/leia/metadata.common.allmusic.com/" | awk '/allmusic/{print $4}' FS='"' | grep -v "^$" | tail -n1)"
   curl -so "${config_dir}/.kodi/addons/packages/${latest_allmusic_scraper}" -L "http://mirrors.kodi.tv/addons/leia/metadata.common.allmusic.com/${latest_allmusic_scraper}"
   unzip -q "${config_dir}/.kodi/addons/packages/${latest_allmusic_scraper}" -d "${config_dir}/.kodi/addons"

   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Download fanart.tv scraper"
   latest_fanart_scraper="$(curl -sX GET "http://mirrors.kodi.tv/addons/leia/metadata.common.fanart.tv/" | awk '/fanart/{print $4}' FS='"' | grep -v "^$" | tail -n1)"
   curl -so "${config_dir}/.kodi/addons/packages/${latest_fanart_scraper}" -L "http://mirrors.kodi.tv/addons/leia/metadata.common.fanart.tv/${latest_fanart_scraper}"
   unzip -q "${config_dir}/.kodi/addons/packages/${latest_fanart_scraper}" -d "${config_dir}/.kodi/addons"

   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Download imdb scraper"
   latest_imdb_scraper="$(curl -sX GET "http://mirrors.kodi.tv/addons/leia/metadata.common.imdb.com/" | awk '/imdb/{print $4}' FS='"' | grep -v "^$" | tail -n1)"
   curl -so "${config_dir}/.kodi/addons/packages/${latest_imdb_scraper}" -L "http://mirrors.kodi.tv/addons/leia/metadata.common.imdb.com/${latest_imdb_scraper}"
   unzip -q "${config_dir}/.kodi/addons/packages/${latest_imdb_scraper}" -d "${config_dir}/.kodi/addons"

   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Download ofdb scraper"
   latest_ofdb_scraper="$(curl -sX GET "http://mirrors.kodi.tv/addons/leia/metadata.common.ofdb.de/" | awk '/ofdb/{print $4}' FS='"' | grep -v "^$" | tail -n1)"
   curl -so "${config_dir}/.kodi/addons/packages/${latest_ofdb_scraper}" -L "http://mirrors.kodi.tv/addons/leia/metadata.common.ofdb.de/${latest_ofdb_scraper}"
   unzip -q "${config_dir}/.kodi/addons/packages/${latest_ofdb_scraper}" -d "${config_dir}/.kodi/addons"

   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Download omdbapi scraper"
   latest_omdbapi_scraper="$(curl -sX GET "http://mirrors.kodi.tv/addons/leia/metadata.common.omdbapi.com/" | awk '/omdbapi/{print $4}' FS='"' | grep -v "^$" | tail -n1)"
   curl -so "${config_dir}/.kodi/addons/packages/${latest_omdbapi_scraper}" -L "http://mirrors.kodi.tv/addons/leia/metadata.common.omdbapi.com/${latest_omdbapi_scraper}"
   unzip -q "${config_dir}/.kodi/addons/packages/${latest_omdbapi_scraper}" -d "${config_dir}/.kodi/addons"

   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Download theaudiodb scraper"
   latest_theaudiodb_scraper="$(curl -sX GET "http://mirrors.kodi.tv/addons/leia/metadata.common.theaudiodb.com/" | awk '/theaudiodb/{print $4}' FS='"' | grep -v "^$" | tail -n1)"
   curl -so "${config_dir}/.kodi/addons/packages/${latest_theaudiodb_scraper}" -L "http://mirrors.kodi.tv/addons/leia/metadata.common.theaudiodb.com/${latest_theaudiodb_scraper}"
   unzip -q "${config_dir}/.kodi/addons/packages/${latest_theaudiodb_scraper}" -d "${config_dir}/.kodi/addons"

   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Download themoviedb metadata scraper"
   latest_themoviedb_scraper="$(curl -sX GET "http://mirrors.kodi.tv/addons/leia/metadata.common.themoviedb.org/" | awk '/themoviedb/{print $4}' FS='"' | grep -v "^$" | tail -n1)"
   curl -so "${config_dir}/.kodi/addons/packages/${latest_themoviedb_scraper}" -L "http://mirrors.kodi.tv/addons/leia/metadata.common.themoviedb.org/${latest_themoviedb_scraper}"
   unzip -q "${config_dir}/.kodi/addons/packages/${latest_themoviedb_scraper}" -d "${config_dir}/.kodi/addons"

   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Download tvshows moviedb metadata scraper"
   latest_tvshows_tmdb_scraper="$(curl -sX GET "http://mirrors.kodi.tv/addons/leia/metadata.tvshows.themoviedb.org/" | awk '/tvshows/{print $4}' FS='"' | grep -v "^$" | tail -n1)"
   curl -so "${config_dir}/.kodi/addons/packages/${latest_tvshows_tmdb_scraper}" -L "http://mirrors.kodi.tv/addons/leia/metadata.tvshows.themoviedb.org/${latest_tvshows_tmdb_scraper}"
   unzip -q "${config_dir}/.kodi/addons/packages/${latest_tvshows_tmdb_scraper}" -d "${config_dir}/.kodi/addons"

   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Download universal movie scraper"
   latest_universal_scraper="$(curl -sX GET "http://mirrors.kodi.tv/addons/leia/metadata.universal/" | awk '/universal/{print $4}' FS='"' | grep -v "^$" | tail -n1)"
   curl -so "${config_dir}/.kodi/addons/packages/${latest_universal_scraper}" -L "http://mirrors.kodi.tv/addons/leia/metadata.universal/${latest_universal_scraper}"
   unzip -q "${config_dir}/.kodi/addons/packages/${latest_universal_scraper}" -d "${config_dir}/.kodi/addons"

   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Download globalsearch script"
   latest_globalsearch_script="$(curl -sX GET "http://mirrors.kodi.tv/addons/leia/script.globalsearch/" | awk '/globalsearch/{print $4}' FS='"' | grep -v "^$" | tail -n1)"
   curl -so "${config_dir}/.kodi/addons/packages/${latest_globalsearch_script}" -L "http://mirrors.kodi.tv/addons/leia/script.globalsearch/${latest_globalsearch_script}"
   unzip -q "${config_dir}/.kodi/addons/packages/${latest_globalsearch_script}" -d "${config_dir}/.kodi/addons"

   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Download certifi script"
   latest_certifi_script="$(curl -sX GET "http://mirrors.kodi.tv/addons/leia/script.module.certifi/" | awk '/certifi/{print $4}' FS='"' | grep -v "^$" | tail -n1)"
   curl -so "${config_dir}/.kodi/addons/packages/${latest_certifi_script}" -L "http://mirrors.kodi.tv/addons/leia/script.module.certifi/${latest_certifi_script}"
   unzip -q "${config_dir}/.kodi/addons/packages/${latest_certifi_script}" -d "${config_dir}/.kodi/addons"

   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Download chardet script"
   latest_chardet_script="$(curl -sX GET "http://mirrors.kodi.tv/addons/leia/script.module.chardet/" | awk '/chardet/{print $4}' FS='"' | grep -v "^$" | tail -n1)"
   curl -so "${config_dir}/.kodi/addons/packages/${latest_chardet_script}" -L "http://mirrors.kodi.tv/addons/leia/script.module.chardet/${latest_chardet_script}"
   unzip -q "${config_dir}/.kodi/addons/packages/${latest_chardet_script}" -d "${config_dir}/.kodi/addons"

   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Download idna script"
   latest_idna_script="$(curl -sX GET "http://mirrors.kodi.tv/addons/leia/script.module.idna/" | awk '/idna/{print $4}' FS='"' | grep -v "^$" | tail -n1)"
   curl -so "${config_dir}/.kodi/addons/packages/${latest_idna_script}" -L "http://mirrors.kodi.tv/addons/leia/script.module.idna/${latest_idna_script}"
   unzip -q "${config_dir}/.kodi/addons/packages/${latest_idna_script}" -d "${config_dir}/.kodi/addons"

   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Download requests script"
   latest_requests_script="$(curl -sX GET "http://mirrors.kodi.tv/addons/leia/script.module.requests/" | awk '/requests/{print $4}' FS='"' | grep -v "^$" | tail -n1)"
   curl -so "${config_dir}/.kodi/addons/packages/${latest_requests_script}" -L "http://mirrors.kodi.tv/addons/leia/script.module.requests/${latest_requests_script}"
   unzip -q "${config_dir}/.kodi/addons/packages/${latest_requests_script}" -d "${config_dir}/.kodi/addons"

   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Download urllib3 script"
   latest_urllib3_script="$(curl -sX GET "http://mirrors.kodi.tv/addons/leia/script.module.urllib3/" | awk '/urllib3/{print $4}' FS='"' | grep -v "^$" | tail -n1)"
   curl -so "${config_dir}/.kodi/addons/packages/${latest_urllib3_script}" -L "http://mirrors.kodi.tv/addons/leia/script.module.urllib3/${latest_urllib3_script}"
   unzip -q "${config_dir}/.kodi/addons/packages/${latest_urllib3_script}" -d "${config_dir}/.kodi/addons"

   # echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Download version check service"
   # latest_versioncheck_service="$(curl -sX GET "http://mirrors.kodi.tv/addons/leia/service.xbmc.versioncheck/" | awk '/versioncheck/{print $4}' FS='"' | grep -v "^$" | tail -n1)"
   # curl -so "${config_dir}/.kodi/addons/packages/${latest_versioncheck_service}" -L "http://mirrors.kodi.tv/addons/leia/service.xbmc.versioncheck/${latest_versioncheck_service}"
   # unzip -q "${config_dir}/.kodi/addons/packages/${latest_versioncheck_service}" -d "${config_dir}/.kodi/addons"
}

if [ -f "/download_addons" ] && [ ! -d "${config_dir}/.kodi/addons/packages" ]; then
   DownloadAddons
   rm -f "${config_dir}/.kodi/addons/packages/"*
   chown -R abc:abc "${config_dir}"
   rm -f "/download_addons"
fi









