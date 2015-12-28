#!/bin/bash

# Disable every RDing device
for dev in $(xinput --list | grep RDing |grep -oe "id=[0-9]." | grep -oe "[0-9]."); do
  xinput --disable ${dev}
done
