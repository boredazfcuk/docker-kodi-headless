#!/bin/bash

Initialise(){
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Create Univeral Movie Metadata Scraper Settings for Db Import"
   certification_country="$(echo ${certification_country:=us} | tr '[:upper:]' '[:lower:]')"
   echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Certification country: ${certification_country}"
   # No certification prefix specified, use default
   if [ -z "${certification_prefix}" ]; then echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Certification prefix: ${certification_prefix:=Rated}"; fi
   # If certification_prefix is set to 'none', unset certification_prefix, so removed from xml config
   if [ "${certification_prefix}" = "none" ]; then echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Certification prefix: <none>"; unset certification_prefix; fi
   # Set imdb certification country
   if [ "${certification_country}" = "us" ]; then
      imdb_certification_country="United States"
      language="en"
   elif [ "${certification_country}" = "gb" ]; then
      imdb_certification_country="United Kingdom"
      language="en"
   else
      echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Certification country not recognised - Exiting"
      sleep 600
      exit 1
   fi
}

CreateUniversalMovieScraperSettings(){
   {
      echo '<settings version="2">'
      echo '<setting id="alsoimdb" default="true">false</setting>'
      echo '<setting id="alsometa" default="true">false</setting>'
      echo '<setting id="alsootherrotten" default="true">false</setting>'
      echo '<setting id="alsorotten" default="true">false</setting>'
      echo '<setting id="alsotmdb" default="true">false</setting>'
      echo '<setting id="certificationssource">themoviedb.org</setting>'
      echo '<setting id="certprefix">'"${certification_prefix} "'</setting>'
      echo '<setting id="countrysource">themoviedb.org</setting>'
      echo '<setting id="creditssource">themoviedb.org</setting>'
      echo '<setting id="fanart">true</setting>'
      echo '<setting id="fanarttvclearart" default="true">false</setting>'
      echo '<setting id="fanarttvclearlogo" default="true">false</setting>'
      echo '<setting id="fanarttvfanart">true</setting>'
      echo '<setting id="fanarttvmoviebanner" default="true">false</setting>'
      echo '<setting id="fanarttvmoviediscart" default="true">false</setting>'
      echo '<setting id="fanarttvmovielandscape" default="true">false</setting>'
      echo '<setting id="fanarttvposter">true</setting>'
      echo '<setting id="fanarttvposterlanguage" default="true">'"${language}"'</setting>'
      echo '<setting id="fanarttvsetclearart" default="true">false</setting>'
      echo '<setting id="fanarttvsetclearlogo" default="true">false</setting>'
      echo '<setting id="fanarttvsetfanart">true</setting>'
      echo '<setting id="fanarttvsetmoviebanner" default="true">false</setting>'
      echo '<setting id="fanarttvsetmoviediscart" default="true">false</setting>'
      echo '<setting id="fanarttvsetmovielandscape" default="true">false</setting>'
      echo '<setting id="fanarttvsetposter">true</setting>'
      echo '<setting id="fullimdbsearch" default="true">false</setting>'
      echo '<setting id="genressource">themoviedb.org</setting>'
      echo '<setting id="imdbakatitles" default="true">Keep Original</setting>'
      echo '<setting id="imdbcertcountry" default="true">'"${imdb_certification_country}"'</setting>'
      echo '<setting id="imdbsearchlanguage" default="true">None</setting>'
      echo '<setting id="imdbthumbs">true</setting>'
      echo '<setting id="imdbtop250">true</setting>'
      echo '<setting id="mratingsource">themoviedb.org</setting>'
      echo '<setting id="omdbapikey" default="true">Please Enter Your OMDB API Key</setting>'
      echo '<setting id="omdbapikey2" default="true">Please Enter Your OMDB API Key</setting>'
      echo '<setting id="outlinesource" default="true">IMDb</setting>'
      echo '<setting id="plotsource">themoviedb.org</setting>'
      echo '<setting id="searchservice">themoviedb.org</setting>'
      echo '<setting id="studiosource" default="true">themoviedb.org</setting>'
      echo '<setting id="taglinesource">themoviedb.org</setting>'
      echo '<setting id="titlesource">themoviedb.org</setting>'
      echo '<setting id="tmdbcertcountry">'"${certification_country}"'</setting>'
      echo '<setting id="tmdbgenreslanguage" default="true">'"${language}"'</setting>'
      echo '<setting id="tmdbplotlanguage" default="true">'"${language}"'</setting>'
      echo '<setting id="tmdbsearchlanguage" default="true">'"${language}"'</setting>'
      echo '<setting id="tmdbset">true</setting>'
      echo '<setting id="tmdbsetlanguage" default="true">'"${language}"'</setting>'
      echo '<setting id="tmdbtaglinelanguage" default="true">'"${language}"'</setting>'
      echo '<setting id="tmdbtags" default="true">None</setting>'
      echo '<setting id="tmdbthumblanguage" default="true">'"${language}"'</setting>'
      echo '<setting id="tmdbthumbs">true</setting>'
      echo '<setting id="tmdbtitlelanguage" default="true">'"${language}"'</setting>'
      echo '<setting id="tmdbtrailer">true</setting>'
      echo '<setting id="tmdbtrailerlanguage" default="true">'"${language}"'</setting>'
      echo '<setting id="tomato" default="true">TomatoMeter All Critics</setting>'
      echo '</settings>'
   } > /config/universal.xml
}

CreateTMDbScraperSettings(){
   {
      echo '<settings version="2">'
      echo '<setting id="certprefix" default="true">'"${certification_prefix} "'</setting>'
      echo '<setting id="fanart">true</setting>'
      echo '<setting id="imdbanyway" default="true">false</setting>'
      echo '<setting id="keeporiginaltitle">true</setting>'
      echo '<setting id="language" default="true">'"${imdb_certification_country}"'</setting>'
      echo '<setting id="RatingS" default="true">TMDb</setting>'
      echo '<setting id="tmdbcertcountry">'"${certification_country}"'</setting>'
      echo '<setting id="trailer">false</setting>'
      echo '</settings>'
   } > /config/tmdb.xml
}

Initialise
CreateUniversalMovieScraperSettings
CreateTMDbScraperSettings