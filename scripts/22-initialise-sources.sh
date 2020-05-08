#!/bin/bash

set -e

Initialise(){
   IFS=,
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Create sources.xml using:"
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:       - Music locations: ${music_dirs:=/storage/music/}"
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:       - Video locations: ${video_dirs:=/storage/videos/}"
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:       - TV locations: ${tv_dirs:=/storage/tvshows/}"
}

AddHeader(){
   {
      echo '<sources>'
      echo '    <programs>'
      echo '        <default pathversion="1"></default>'
      echo '    </programs>'
      echo '    <files>'
      echo '        <default pathversion="1"></default>'
      echo '        <source>'
      echo '            <name>Kodi.tv</name>'
      echo '            <path pathversion="1">http://kodiuk.tv/repo/</path>'
      echo '            <allowsharing>true</allowsharing>'
      echo '        </source>'
      echo '    </files>'
      echo '    <games>'
      echo '        <default pathversion="1"></default>'
      echo '    </games>'
      echo '    <video>'
      echo '        <default pathversion="1"></default>'
   } > "${user_data_dir}/sources.xml"
}

AddVideoLocations(){
   for video_dir in ${video_dirs}; do
      echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Adding source name: $(basename ${video_dir})"
      echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:     - with path: ${video_dir}"
      {
         echo '        <source>'
         echo "            <name>$(basename ${video_dir})</name>"
         echo "            <path pathversion=\"1\">${video_dir}</path>"
         echo '            <allowsharing>true</allowsharing>'
         echo '        </source>'
      } >> "${user_data_dir}/sources.xml"
   done
}

AddTVLocations(){
   for tv_dir in ${tv_dirs}; do
      echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Adding source name: $(basename ${tv_dir})"
      echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:     - with path: ${tv_dir}"
      {
         echo '        <source>'
         echo "            <name>$(basename ${tv_dir})</name>"
         echo "            <path pathversion=\"1\">${tv_dir}</path>"
         echo '            <allowsharing>true</allowsharing>'
         echo '        </source>'
      } >> "${user_data_dir}/sources.xml"
   done
}

AddLinker(){
      {
         echo "    </video>"
         echo "    <music>"
         echo '        <default pathversion="1"></default>'
      } >> "${user_data_dir}/sources.xml"
}

AddMusicLocations(){
   for music_dir in ${music_dirs}; do
      echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Adding source name: $(basename ${music_dir})"
      echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:     - with path: ${music_dir}"
      {
         echo '        <source>'
         echo "            <name>$(basename ${music_dir})</name>"
         echo "            <path pathversion=\"1\">${music_dir}</path>"
         echo '            <allowsharing>true</allowsharing>'
         echo '        </source>'
      } >> "${user_data_dir}/sources.xml"
   done
}

AddFooter(){
   {
      echo '    </music>'
      echo '</sources>'
   } >> "${user_data_dir}/sources.xml"
}

#####
Initialise
AddHeader
AddVideoLocations
AddTVLocations
AddLinker
AddMusicLocations
AddFooter