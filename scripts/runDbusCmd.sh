#!/bin/bash
# Run dbus command as user who owns DISPLAY=:0 and runs a kde4 daemon

# Get the dbus command. e.g. change to the next desktop: "--print-reply --dest=org.kde.KWin /KWin org.kde.KWin.previousDesktop"
DBUS_CMD=${1}

# Get the user who owns the display
USER=$(who | grep ' :0 ' | cut -d ' ' -f1)
# Get the remote DBUS of ${USER}, which runs KDE4
KDE4_PID=""
for KDE4_PID_TMP in $(pidof kded4 | cut -d ' ' -f2); do
  uid=$(awk '/^Uid:/{print $2}' /proc/${KDE4_PID_TMP}/status)
  user=$(getent passwd "$uid" | awk -F: '{print $1}')
  if [[ ${user} == ${USER} ]]; then
    KDE4_PID=${KDE4_PID_TMP}
    break
  fi
done

# Check if we have found a user who owns a kded4 and :0
if [[ ${KDE4_PID} == "" ]]; then
  echo "No kded4 process for user ${USER} found" 1>&2
  exit
fi
  
ALIEN_DBUS_SESSION_BUS_ADDRESS=$(cat /proc/${KDE4_PID}/environ | tr '\0' '\n' | grep DBUS_SESSION_BUS_ADDRESS | cut -d '=' -f2-);
su -c "export DBUS_SESSION_BUS_ADDRESS=${ALIEN_DBUS_SESSION_BUS_ADDRESS}; dbus-send ${DBUS_CMD}" -l ${USER}