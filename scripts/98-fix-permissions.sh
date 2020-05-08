#!/bin/bash

set -e

echo "$(date '+%Y-%m-%d %H:%M:%S') INFO:    Correct owner, ${PUID}, Kodi shared user data, if required"
find "/usr/share/kodi/addons/" ! -user "${PUID}" -exec chown "${PUID}" {} \;
find "/usr/share/kodi/userdata/" ! -user "${PUID}" -exec chown "${PUID}" {} \;