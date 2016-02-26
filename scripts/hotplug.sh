#!/bin/bash
# This script runs the footSwitchEventHandling program
# for the non-opened RDing event device from /dev/input
# with the next non-opened scripts in the scripts folder

ROOT="/opt/footSwitchEventHandling"
SCRIPTS_FOLDER="${ROOT}/scripts/cmd"
PROG="${ROOT}/footSwitchEventHandling"
ID_SERIAL="RDing_FootSwitch1F1."
LOCKFILE="/tmp/$(basename ${0}).lock"


lock () {
LOCK_SUCCESS="0";
while [[ ${LOCK_SUCCESS} == "0" ]]; do
  mkdir "${LOCKFILE}"; LOCKVALUE=$?
  if [[ "${LOCKVALUE}" == "0" ]]; then    # directory did not exist, but was created successfully
    echo >&2 "successfully acquired lock: ${LOCKFILE}"
    LOCK_SUCCESS="1"
  else    # failed to create the directory, presumably because it already exists
    echo >&2 "cannot acquire lock on ${LOCKFILE}, wait to be freed"
    sleep 1
  fi
done
}

unlock () {
rm -rf ${LOCKFILE}
}


if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# lock any other hotplug.sh process
lock

# Get a free RDing event device
DEV_OPENED_ALREADY=0
INP_DEV_TO_OPEN=""
for INP_DEV in $(ls /dev/input/event*); do
  # Check all event devices, if they are a RDing Footswitch, and if so, process it
  OUT_STR=$(udevadm info -q all -n ${INP_DEV} | grep "ID_SERIAL=${ID_SERIAL}")
  if [[ ${OUT_STR} == "" ]]; then
    echo "Dev. ${INP_DEV} is not a RDing device" 1>&2
    continue
  fi

  echo "Process the RDing device at ${INP_DEV}"

  # Check, if the device has been opened by ${PROG} already
  for OPEN_DEVICE in $(ps aux | grep ${PROG} | grep -oe "/dev/input/event[0-9]."); do
    if [[ ${OPEN_DEVICE} == ${INP_DEV} ]]; then
      echo "Device ${OPEN_DEVICE} already opened" 1>&2
      DEV_OPENED_ALREADY=1
      break
    fi
  done

  if [[ ${DEV_OPENED_ALREADY} == "0" ]]; then
    echo "Found free device ${INP_DEV}" 1>&2
    INP_DEV_TO_OPEN=${INP_DEV}
    break
  fi
  DEV_OPENED_ALREADY=0
done

echo -e "INP_DEV_TO_OPEN=${INP_DEV_TO_OPEN}\n"

# Get the next free script
# (e.g. 1 is executed, so start the scripts in folder 2)
SCRIPT_OPENED_ALREADY=1
cmdP=""
cmdR=""
for SCRIPT_FOLDER in $(ls ${SCRIPTS_FOLDER}); do

  # I need an identifier for the opened scripts.
  # Thus, I'll put an echo string in front of every command
  COMMENT_STRING="echo ${SCRIPT_FOLDER}"
  echo "Process scripts in folder ${SCRIPTS_FOLDER}/${SCRIPT_FOLDER}"
  # Search for the "echo" comment string with the regarding script folder number
  OUT_STR=$(ps aux | grep ${PROG} | grep -oe "${COMMENT_STRING}")
  if [[ ${OUT_STR} != "" ]]; then
      echo "Scripts in ${SCRIPTS_FOLDER}/${SCRIPT_FOLDER} already opened" 1>&2
      continue
  fi
   # Get the script content
  cmdP="${COMMENT_STRING}P;$(cat ${SCRIPTS_FOLDER}/${SCRIPT_FOLDER}/P | head -n1)"
  cmdR="${COMMENT_STRING}R;$(cat ${SCRIPTS_FOLDER}/${SCRIPT_FOLDER}/R | head -n1)"
  SCRIPT_OPENED_ALREADY=0
  break
done

echo -e "cmdP: ${cmdP}"
echo -e "cmdR: ${cmdR}\n"

# Finally, run the program
EXIT_CODE="1"
if [[ ${DEV_OPENED_ALREADY} == "0" && ${SCRIPT_OPENED_ALREADY} == "0" ]]; then
  echo "${PROG} --eventDevice ${INP_DEV_TO_OPEN} --cmdP \"${cmdP}\" --cmdR \"${cmdR}\"" | at now
  EXIT_CODE="0"
fi

# Release the other running hotplug.sh scripts
unlock

exit ${EXIT_CODE}