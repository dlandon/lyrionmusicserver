#!/bin/bash
#
# 30_firstrun.sh
#

#
# Configure user nobody to match Unraid's settings
#
PUID="${PUID:-99}"
PGID="${PGID:-100}"

usermod -u "$PUID" nobody

if ! getent group "$PGID" >/dev/null; then
	groupadd -g "$PGID" lmsgroup
	GROUP_NAME="lmsgroup"
else
	GROUP_NAME="$(getent group "$PGID" | cut -d: -f1)"
fi

usermod -g "$GROUP_NAME" nobody
usermod -d /config nobody

#
# Create conf directory if it doesn't exist
#
if [ ! -d /config ]; then
	mkdir /config
fi
chown "${PUID}:${PGID}" /config
chmod 775 /config

#
# Create prefs directory if it doesn't exist
#
if [ ! -d /config/prefs ]; then
	mkdir /config/prefs
fi
chown "${PUID}:${PGID}" /config/prefs
chmod 775 /config/prefs

if [ ! -d /config/prefs/plugin ]; then
	mkdir /config/prefs/plugin
fi
chown "${PUID}:${PGID}" /config/prefs/plugin
chmod 775 /config/prefs/plugin

#
# Create logs directory if it doesn't exist and log files
#
if [ ! -d /config/logs ]; then
	mkdir /config/logs
fi
chown "${PUID}:${PGID}" /config/logs
chmod 775 /config/logs

if [ ! -f /config/logs/perfmon.log ]; then
	touch /config/logs/perfmon.log
fi
chown "${PUID}:${PGID}" /config/logs/perfmon.log
chmod 664 /config/logs/perfmon.log

if [ ! -f /config/logs/server.log ]; then
	touch /config/logs/server.log
fi
chown "${PUID}:${PGID}" /config/logs/server.log
chmod 664 /config/logs/server.log

#
# Create cache directory if it doesn't exist
#
if [ ! -d /config/cache ]; then
	mkdir /config/cache
fi
chown "${PUID}:${PGID}" /config/cache
chmod 775 /config/cache

#
# Create playlists directory if it doesn't exist
#
if [ ! -d /config/playlists ]; then
	mkdir /config/playlists
fi
chown "${PUID}:${PGID}" /config/playlists
chmod 775 /config/playlists

#
# Configure LMS settings protection
#
LMS_PROTECT_SETTINGS=${LMS_PROTECT_SETTINGS:-1}
PREF_FILE="/config/prefs/server.prefs"

#
# Ensure prefs file exists
#
if [ ! -f "$PREF_FILE" ]; then
	touch "$PREF_FILE"
fi
chown "${PUID}:${PGID}" "$PREF_FILE"
chmod 664 "$PREF_FILE"

#
# Normalize value (only 0 or 1)
#
if [ "$LMS_PROTECT_SETTINGS" != "0" ]; then
	LMS_PROTECT_SETTINGS="1"
fi

#
# Update or append protectSettings
#
if grep -q '^protectSettings:' "$PREF_FILE"; then
	sed -i "s/^protectSettings:.*/protectSettings: $LMS_PROTECT_SETTINGS/" "$PREF_FILE"
else
	echo "protectSettings: $LMS_PROTECT_SETTINGS" >> "$PREF_FILE"
fi
