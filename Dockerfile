FROM linuxserver/kodi-headless
MAINTAINER boredazfcuk
ENV USERDATA=/config/.kodi/userdata

RUN echo "$(date '+%d/%m/%Y - %H:%M:%S') | ***** BUILD STARTED *****" && \
   echo "$(date '+%d/%m/%Y - %H:%M:%S') | Install dependencies" && \
   apt-get update && \
   apt-get upgrade -y && \
   apt-get install -y wget python mariadb-client unzip sqlite3 --no-install-recommends && \
echo "$(date '+%d/%m/%Y - %H:%M:%S') | Configure logging" && \
   sed -i -e '/contenv/a \\n\ttail -F \/config\/.kodi\/temp\/kodi.log 2>/dev/null & \\' /etc/services.d/kodi/run

COPY "10-set-defaults" "/config/custom-cont-init.d/10-set-defaults"
COPY "20-download-addons" "/config/custom-cont-init.d/20-download-addons"
COPY "30-initialise-databases" "/config/custom-cont-init.d/30-initialise-databases"
COPY "40-fix-permissions" "/config/custom-cont-init.d/40-fix-permissions"
COPY "90-wait-for-mariadb" "/config/custom-cont-init.d/90-wait-for-mariadb"
COPY sources.xml "${USERDATA}/sources.xml"
COPY guisettings.xml "${USERDATA}/guisettings.xml"
COPY addon_data/metadata.universal/settings.xml "${USERDATA}/addon_data/metadata.universal/settings.xml"
COPY addon_data/metadata.themoviedb.org/settings.xml "${USERDATA}/addon_data/metadata.themoviedb.org/settings.xml"
COPY addon_data/metadata.tvshows.themoviedb.org/settings.xml "${USERDATA}/addon_data/metadata.tvshows.themoviedb.org/settings.xml"
COPY healthcheck.sh /usr/local/bin/healthcheck.sh

RUN echo "$(date '+%d/%m/%Y - %H:%M:%S') | Set scripts to be executable" && \
   chmod +x /usr/local/bin/healthcheck.sh && \
echo "$(date '+%d/%m/%Y - %H:%M:%S') | ***** BUILD COMPLETE *****"

HEALTHCHECK --start-period=10s --interval=1m --timeout=10s \
   CMD /usr/local/bin/healthcheck.sh