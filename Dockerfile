FROM linuxserver/kodi-headless
MAINTAINER boredazfcuk
ENV user_data_dir=/config/.kodi/userdata

RUN echo "$(date '+%d/%m/%Y - %H:%M:%S') | ***** BUILD STARTED FOR KODI-HEADLESS *****" && \
   echo "$(date '+%d/%m/%Y - %H:%M:%S') | Install dependencies" && \
   apt-get update && \
   apt-get upgrade -y && \
   apt-get install -y ca-certificates wget python mariadb-client unzip sqlite3 nano --no-install-recommends && \
echo "$(date '+%d/%m/%Y - %H:%M:%S') | Configure logging" && \
   sed -i -e '/contenv/a \\n\ttail -F \/config\/.kodi\/temp\/kodi.log 2>/dev/null & \\' /etc/services.d/kodi/run

COPY "scripts/"* "/config/custom-cont-init.d/"
COPY healthcheck.sh /usr/local/bin/healthcheck.sh

RUN echo "$(date '+%d/%m/%Y - %H:%M:%S') | Set scripts to be executable" && \
   chmod +x /usr/local/bin/healthcheck.sh && \
   apt-get clean && \
   rm -rf /var/lib/apt/lists/* && \
   touch "/download_addons" "/init_advanced_settings" "/init_kodi_user" "/init_dbs" "/init_addons" && \
echo "$(date '+%d/%m/%Y - %H:%M:%S') | ***** BUILD COMPLETE *****"

HEALTHCHECK --start-period=10s --interval=1m --timeout=10s \
   CMD /usr/local/bin/healthcheck.sh