# Helpful links

## Linux Input driver

Linux Input drivers: https://www.kernel.org/doc/Documentation/input/input.txt

evdev: https://en.wikipedia.org/wiki/Evdev

Work with input drivers: http://stackoverflow.com/questions/15949163/read-from-dev-input

## udev

udev: https://wiki.ubuntuusers.de/udev

DebuggingUdev: https://wiki.ubuntu.com/DebuggingUdev

Run a script when udev detects a device: http://askubuntu.com/questions/25071/how-to-run-a-script-when-a-specific-flash-drive-is-mounted

How to run long time process on Udev event: http://unix.stackexchange.com/questions/56243/how-to-run-long-time-process-on-udev-event

## X11

xinput: http://linux.die.net/man/1/xinput

Input Configuration with xinput: https://wiki.ubuntu.com/X/Config/Input

Remapping mouse buttons: http://wiki.mbirth.de/know-how/software/linux/remapping-mouse-buttons.html

Cool Tricks with Xinput Device: http://www.linux.org/threads/cool-tricks-with-xinput-device.6178/

Persistent device configuration(1): https://wiki.archlinux.org/index.php/Mouse_acceleration

Persistent device configuration(2): https://fedoraproject.org/wiki/Input_device_configuration

## Misc

How do I compare binary files in Linux (using `xxd`): http://superuser.com/questions/125376/how-do-i-compare-binary-files-in-linux


# Inspect the device

## Inspect the /dev/input folder

What happens if I plug in the device
Difference: Occurence of "event5" and "mouse0"

### Without device
```bash
bash> ls /dev/input/
by-id    event0  event10  event12  event14  event16  event2  event5  event7  event9  mice    mouse2
by-path  event1  event11  event13  event15  event17  event3  event6  event8  js0     mouse1  mouse3
```
### With device plugged in
```bash
bash> ls /dev/input/
by-id    event0  event10  event12  event14  event16  event2  event4  event6  event8  js0   mouse0  mouse2
by-path  event1  event11  event13  event15  event17  event3  event5  event7  event9  mice  mouse1  mouse3
```
## Inspect the /dev/usb folder
### Without device
```bash
bash> ls /dev/usb/
hiddev1
```
### With device plugged in
```bash
bash> ls /dev/usb/
hiddev0  hiddev1
```

## Inspect the /dev folder

Difference: Occurence of "hidraw0" and "hidraw1"

### Without device
```bash
bash> ls /dev/
autofs           input               port   random    tty14  tty34  tty54      ttyS15  ttyS7       vcsa2
block            kmsg                ppp    rfkill    tty15  tty35  tty55      ttyS16  ttyS8       vcsa3
bsg              kvm                 psaux  rtc       tty16  tty36  tty56      ttyS17  ttyS9       vcsa4
btrfs-control    log                 ptmx   rtc0      tty17  tty37  tty57      ttyS18  uhid        vcsa5
bus              loop0               ptp0   sda       tty18  tty38  tty58      ttyS19  uinput      vcsa6
char             loop1               pts    sda1      tty19  tty39  tty59      ttyS2   urandom     vcsa7
console          loop2               ram0   sda2      tty2   tty4   tty6       ttyS20  usb         vga_arbiter
core             loop3               ram1   sda5      tty20  tty40  tty60      ttyS21  v4l         vhci
cpu              loop4               ram10  sg0       tty21  tty41  tty61      ttyS22  vboxdrv     vhost-net
cpu_dma_latency  loop5               ram11  shm       tty22  tty42  tty62      ttyS23  vboxdrvu    video0
cuse             loop6               ram12  snapshot  tty23  tty43  tty63      ttyS24  vboxnetctl  watchdog
disk             loop7               ram13  snd       tty24  tty44  tty7       ttyS25  vboxusb     watchdog0
dri              loop-control        ram14  stderr    tty25  tty45  tty8       ttyS26  vcs         zero
ecryptfs         mapper              ram15  stdin     tty26  tty46  tty9       ttyS27  vcs1
fb0              mcelog              ram2   stdout    tty27  tty47  ttyprintk  ttyS28  vcs2
fd               mei                 ram3   tty       tty28  tty48  ttyS0      ttyS29  vcs3
full             mem                 ram4   tty0      tty29  tty49  ttyS1      ttyS3   vcs4
fuse             net                 ram5   tty1      tty3   tty5   ttyS10     ttyS30  vcs5
hidraw2          network_latency     ram6   tty10     tty30  tty50  ttyS11     ttyS31  vcs6
hidraw3          network_throughput  ram7   tty11     tty31  tty51  ttyS12     ttyS4   vcs7
hidraw4          null                ram8   tty12     tty32  tty52  ttyS13     ttyS5   vcsa
hpet             nvram               ram9   tty13     tty33  tty53  ttyS14     ttyS6   vcsa1
```

### With device plugged in
```bash
bash> ls /dev/
autofs           hidraw4             null   ram8      tty12  tty32  tty52      ttyS13  ttyS5       vcsa
block            hpet                nvram  ram9      tty13  tty33  tty53      ttyS14  ttyS6       vcsa1
bsg              input               port   random    tty14  tty34  tty54      ttyS15  ttyS7       vcsa2
btrfs-control    kmsg                ppp    rfkill    tty15  tty35  tty55      ttyS16  ttyS8       vcsa3
bus              kvm                 psaux  rtc       tty16  tty36  tty56      ttyS17  ttyS9       vcsa4
char             log                 ptmx   rtc0      tty17  tty37  tty57      ttyS18  uhid        vcsa5
console          loop0               ptp0   sda       tty18  tty38  tty58      ttyS19  uinput      vcsa6
core             loop1               pts    sda1      tty19  tty39  tty59      ttyS2   urandom     vcsa7
cpu              loop2               ram0   sda2      tty2   tty4   tty6       ttyS20  usb         vga_arbiter
cpu_dma_latency  loop3               ram1   sda5      tty20  tty40  tty60      ttyS21  v4l         vhci
cuse             loop4               ram10  sg0       tty21  tty41  tty61      ttyS22  vboxdrv     vhost-net
disk             loop5               ram11  shm       tty22  tty42  tty62      ttyS23  vboxdrvu    video0
dri              loop6               ram12  snapshot  tty23  tty43  tty63      ttyS24  vboxnetctl  watchdog
ecryptfs         loop7               ram13  snd       tty24  tty44  tty7       ttyS25  vboxusb     watchdog0
fb0              loop-control        ram14  stderr    tty25  tty45  tty8       ttyS26  vcs         zero
fd               mapper              ram15  stdin     tty26  tty46  tty9       ttyS27  vcs1
full             mcelog              ram2   stdout    tty27  tty47  ttyprintk  ttyS28  vcs2
fuse             mei                 ram3   tty       tty28  tty48  ttyS0      ttyS29  vcs3
hidraw0          mem                 ram4   tty0      tty29  tty49  ttyS1      ttyS3   vcs4
hidraw1          net                 ram5   tty1      tty3   tty5   ttyS10     ttyS30  vcs5
hidraw2          network_latency     ram6   tty10     tty30  tty50  ttyS11     ttyS31  vcs6
hidraw3          network_throughput  ram7   tty11     tty31  tty51  ttyS12     ttyS4   vcs7
```

# xinput

`xinput` shows the device as mouse "RDing FootSwitch1F1.":

```bash
bash> xinput --list
⎡ Virtual core pointer                          id=2    [master pointer  (3)]
⎜   ↳ Virtual core XTEST pointer                id=4    [slave  pointer  (2)]
⎜   ↳ Microsoft Microsoft® Nano Transceiver v1.0        id=11   [slave  pointer  (2)]
⎜   ↳ Microsoft Microsoft® Nano Transceiver v1.0        id=12   [slave  pointer  (2)]
⎜   ↳ SynPS/2 Synaptics TouchPad                id=15   [slave  pointer  (2)]
⎜   ↳ TPPS/2 IBM TrackPoint                     id=17   [slave  pointer  (2)]
⎜   ↳ RDing FootSwitch1F1.                      id=9    [slave  pointer  (2)]
⎣ Virtual core keyboard                         id=3    [master keyboard (2)]
    ↳ Virtual core XTEST keyboard               id=5    [slave  keyboard (3)]
    ↳ Power Button                              id=6    [slave  keyboard (3)]
    ↳ Video Bus                                 id=7    [slave  keyboard (3)]
    ↳ Sleep Button                              id=8    [slave  keyboard (3)]
    ↳ Microsoft Microsoft® Nano Transceiver v1.0        id=10   [slave  keyboard (3)]
    ↳ Integrated Camera                         id=13   [slave  keyboard (3)]
    ↳ AT Translated Set 2 keyboard              id=14   [slave  keyboard (3)]
    ↳ ThinkPad Extra Buttons                    id=16   [slave  keyboard (3)]
```

xinput redirects us to the assumed device node

```bash
bash> xinput --list-props 9
Device 'RDing FootSwitch1F1.':
        Device Enabled (135):   1
        Coordinate Transformation Matrix (137): 1.000000, 0.000000, 0.000000, 0.000000, 1.000000, 0.000000, 0.000000, 0.000000, 1.000000
        Device Accel Profile (260):     0
        Device Accel Constant Deceleration (261):       1.000000
        Device Accel Adaptive Deceleration (262):       1.000000
        Device Accel Velocity Scaling (263):    10.000000
        Device Product ID (255):        3141, 29699
        Device Node (256):      "/dev/input/event4"
        Evdev Axis Inversion (264):     0, 0
        Evdev Axes Swap (266):  0
        Axis Labels (267):      "Rel X" (145), "Rel Y" (146), "Rel Vert Wheel" (259)
        Button Labels (268):    "Button Left" (138), "Button Middle" (139), "Button Right" (140), "Button Wheel Up" (141), "Button Wheel Down" (142), "Button Horiz Wheel Left" (143), "Button Horiz Wheel Right" (144)
        Evdev Middle Button Emulation (269):    0
        Evdev Middle Button Timeout (270):      50
        Evdev Third Button Emulation (271):     0
        Evdev Third Button Emulation Timeout (272):     1000
        Evdev Third Button Emulation Button (273):      3
        Evdev Third Button Emulation Threshold (274):   20
        Evdev Wheel Emulation (275):    0
        Evdev Wheel Emulation Axes (276):       0, 0, 4, 5
        Evdev Wheel Emulation Inertia (277):    10
        Evdev Wheel Emulation Timeout (278):    200
        Evdev Wheel Emulation Button (279):     4
        Evdev Drag Lock Buttons (280):  0
```

When we want to work with the events, we should disable the device so that no more characters appear if someone presses the switch:
```bash
bash> xinput --disable 9
```

# Working with the event device

Pressing the Switch for a few seconds:

```bash
bash> footSwitchEventHandling --debug --eventDevice /dev/input/event4

# Press events
---------- DEBUG START: input_event ----------
time.tv_sec: 1451225158
time.tv_usec: 261641
type: 4
code: 4
value: 458757 (NO STRING FOUND)
---------- DEBUG END: input_event ----------
---------- DEBUG START: input_event ----------
time.tv_sec: 1451225158
time.tv_usec: 261641
type: 1
code: 48
value: 1 (EV_KEY)
---------- DEBUG END: input_event ----------
---------- DEBUG START: input_event ----------
time.tv_sec: 1451225158
time.tv_usec: 261641
type: 0
code: 0
value: 0 (EV_SYN)
---------- DEBUG END: input_event ----------

# Repetition events:
---------- DEBUG START: input_event ----------
time.tv_sec: 1451225158
time.tv_usec: 512841
type: 1
code: 48
value: 2 (EV_REL)
---------- DEBUG END: input_event ----------
---------- DEBUG START: input_event ----------
time.tv_sec: 1451225158
time.tv_usec: 512841
type: 0
code: 0
value: 1 (EV_KEY)
---------- DEBUG END: input_event ----------
# .........................Repetition of events.........................................
---------- DEBUG START: input_event ----------
time.tv_sec: 1451225158
time.tv_usec: 764844
type: 1
code: 48
value: 2 (EV_REL)
---------- DEBUG END: input_event ----------
---------- DEBUG START: input_event ----------
time.tv_sec: 1451225158
time.tv_usec: 764844
type: 0
code: 0
value: 1 (EV_KEY)
---------- DEBUG END: input_event ----------

# Release events:
---------- DEBUG START: input_event ----------
time.tv_sec: 1451225158
time.tv_usec: 765638
type: 4
code: 4
value: 458757 (NO STRING FOUND)
---------- DEBUG END: input_event ----------
---------- DEBUG START: input_event ----------
time.tv_sec: 1451225158
time.tv_usec: 765638
type: 1
code: 48
value: 0 (EV_SYN)
---------- DEBUG END: input_event ----------
---------- DEBUG START: input_event ----------
time.tv_sec: 1451225158
time.tv_usec: 765638
type: 0
code: 0
value: 0 (EV_SYN)
---------- DEBUG END: input_event ----------
```

We can investigate that we receive tupples and tripples, grouped by their `time`field.

Press tripple: `(458757, EV_KEY, EV_SYN)`

Repetition tupple: `(EV_REL, EV_KEY)`

Release tupple: `(458757, EV_SYN, EV_SYN)`
