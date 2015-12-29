#!/bin/bash
# This script runs the footSwitchEventHandling program
# for the non-opened RDing event device from /dev/input
# with the next non-opened scripts in the scripts folder

ROOT="/opt/footSwitchEventHandling"
SCRIPTS_FOLDER="${ROOT}/scripts/cmd"
PROG="${ROOT}/footSwitchEventHandling"
ID_SERIAL="RDing_FootSwitch1F1."

if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Process every event device
for INP_DEV in $(ls /dev/input/event*); do
  # Check all event devices, if they are a RDing Footswitch, and if so, process it
  OUT_STR=$(udevadm info -q all -n ${INP_DEV} | grep "ID_SERIAL=${ID_SERIAL}")
  if [[ ${OUT_STR} == "" ]]; then
    echo "Dev. ${INP_DEV} is not a RDing device" 1>&2
  else
    echo "Process the RDing device at ${INP_DEV}"

    # Check, if the device has been opened by ${PROG} already
    DEV_OPENED_ALREADY=0
    for OPEN_DEVICE in $(ps aux | grep ${PROG} | grep -oe "/dev/input/event[0-9]."); do
      if [[ ${OPEN_DEVICE} == ${INP_DEV} ]]; then
        echo "Device already opened" 1>&2
        DEV_OPENED_ALREADY=1
      fi
    done

    # Start the program with the next free script
    # (e.g. 1 is executed, so start the scripts in folder 2)
    SCRIPT_OPENED_ALREADY=0
    cmdP=""
    cmdR=""
    for SCRIPT_FOLDER in $(ls ${SCRIPTS_FOLDER}); do

      # I need an identifier for the opened scripts.
      # Thus, I'll put an echo string in front of every command
      COMMENT_STRING="echo ${SCRIPT_FOLDER}"
      echo "Process scripts in folder ${SCRIPTS_FOLDER}/${SCRIPT_FOLDER}"
      # Get the script content
      cmdP="${COMMENT_STRING}P;$(cat ${SCRIPTS_FOLDER}/${SCRIPT_FOLDER}/P | head -n1)"
      cmdR="${COMMENT_STRING}R;$(cat ${SCRIPTS_FOLDER}/${SCRIPT_FOLDER}/R | head -n1)"
      # Search for the "echo" comment string with the regarding script folder number
      for OPEN_DEVICE in $(ps aux | grep ${PROG} | grep -oe "${COMMENT_STRING}"); do
          echo "Scripts in ${SCRIPTS_FOLDER}/${SCRIPT_FOLDER} already opened" 1>&2
          SCRIPT_OPENED_ALREADY=1
      done

      # Finally, run the program
      if [[ ${DEV_OPENED_ALREADY} == "0" && ${SCRIPT_OPENED_ALREADY} == "0" ]]; then
        echo "${PROG} --eventDevice ${INP_DEV} --cmdP \"${cmdP}\" --cmdR \"${cmdR}\"" | at now
        exit 0
      fi
    done
  fi
done
exit 1