#!/bin/bash
# Run dbus command as user which owns DISPLAY=:0

# Get the dbus command. e.g. change to the next desktop: "--print-reply --dest=org.kde.KWin /KWin org.kde.KWin.previousDesktop"
DBUS_CMD=${1}

# Get the user who owns the display
USER=$(who | grep ' :0 ' | cut -d ' ' -f1)
# Get the remote DBUS, which runs KDE4
KDE4_PID=$(pidof kded4);
ALIEN_DBUS_SESSION_BUS_ADDRESS=$(cat /proc/${KDE4_PID}/environ | tr '\0' '\n' | grep DBUS_SESSION_BUS_ADDRESS | cut -d '=' -f2-);
su -c "export DBUS_SESSION_BUS_ADDRESS=${ALIEN_DBUS_SESSION_BUS_ADDRESS}; dbus-send ${DBUS_CMD}" -l ${USER}