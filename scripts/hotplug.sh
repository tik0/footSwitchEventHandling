#!/bin/bash
PROG="/opt/footSwitchEventHandling/footSwitchEventHandling"

for INP_DEV in $(ls /dev/input/event*); do
  OUT_STR=$(udevadm info -q all -n ${dev} | grep "ID_SERIAL=RDing_FootSwitch1F1.")
  if [[ OUT_STR == "" ]]; then
    continue
  fi
  # Check, if the device was opened already
  OPENED_ALREADY=0
  for dev_opened in $(ps aux | grep /opt/footSwitchEventHandling | grep -oe "/dev/input/event[0-9]."); do
    if [[ ${dev_opened} == ${INP_DEV} ]]; then
      OPENED_ALREADY=1
    fi
  done
  # Start the program (TODO For every device different programs)
  if [[ ${OPENED_ALREADY} == "0" ]]; then
    echo "${PROG} --eventDevice ${INP_DEV} --cmdP 'date > /tmp/myDate'" | at now
  fi
done



# OLD SCRIPT
## Count the RDing devices
# OLD_NUM=$(xinput | grep RDing | wc -l)
# while [[ ${OLD_NUM} == $(xinput | grep RDing | wc -l) ]]; do
#   echo "OLD_NUM = ${OLD_NUM}"
#   echo "new = $(xinput | grep RDing | wc -l)"
#   sleep 1
# done

## Process every RDing device
# for dev in $(xinput --list | grep RDing |grep -oe "id=[0-9]." | grep -oe "[0-9]."); do
#   echo "${dev}"
#   xinput --disable ${dev}
#   # Get the input device
#   INP_DEV=$(xinput --list-props ${dev} | grep -oe "/dev/input/event[0-9].")
#   # Check, if the device was opened already
#   OPENED_ALREADY=0
#   for dev_opened in $(ps aux | grep /opt/footSwitchEventHandling | grep -oe "/dev/input/event[0-9]."); do
#     if [[ ${dev_opened} == ${INP_DEV} ]]; then
#       OPENED_ALREADY=1
#       echo "OPENED_ALREADY"
#     fi
#   done
#   # Start the program (TODO For every device different programs)
#   if [[ ${OPENED_ALREADY} == "0" ]]; then
# #     echo "${PROG} --eventDevice ${INP_DEV} --cmdP 'date > /opt/myDate' >/dev/null" | at now
#     echo ${INP_DEV}
#     echo "${PROG} --eventDevice ${INP_DEV} --cmdP 'date > /opt/myDate'" | at now
#   fi
# done
# sleep 2
# wait