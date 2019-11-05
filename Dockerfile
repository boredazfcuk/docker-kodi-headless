FROM linuxserver/kodi-headless
MAINTAINER boredazfcuk

ENV USERDATA=/config/.kodi/userdata

COPY healthcheck.sh /usr/local/bin/healthcheck.sh

RUN echo "$(date '+%d/%m/%Y - %H:%M:%S') | ***** BUILD STARTED *****" && \
   echo "$(date '+%d/%m/%Y - %H:%M:%S') | Install dependencies" && \
   apt-get update && \
   apt-get upgrade -y && \
   apt-get install -y wget mariadb-client && \
echo "$(date '+%d/%m/%Y - %H:%M:%S') | Configure logging" && \
   sed -i -e '/s6-setuidgid/a \\ttail -F \/config\/.kodi\/temp\/kodi.log & \\' /etc/services.d/kodi/run && \
echo "$(date '+%d/%m/%Y - %H:%M:%S') | Set scripts to be executable" && \
   chmod +x /usr/local/bin/healthcheck.sh && \
echo "$(date '+%d/%m/%Y - %H:%M:%S') | ***** BUILD COMPLETE *****"

HEALTHCHECK --start-period=10s --interval=1m --timeout=10s \
   CMD /usr/local/bin/healthcheck.sh