# footSwitchEventHandling
Handle the press/release inputs of a foot switch and map them to a command

## Compile Project

### Create Project

Choose any of the build generators and build targets:

```bash
cmake -G"Eclipse CDT4 - Unix Makefiles" -DCMAKE_BUILD_TYPE=debug .
cmake -G"Eclipse CDT4 - Unix Makefiles" -DCMAKE_BUILD_TYPE=release .
```
Or via `ninja`
```bash
cmake -G"Eclipse CDT4 - Ninja" -DCMAKE_BUILD_TYPE=debug .
cmake -G"Eclipse CDT4 - Ninja" -DCMAKE_BUILD_TYPE=release .
```
### Build

`make` or `ninja`

### Run

Get the event device and execute the program for a test as follows:
```bash
sudo ./footSwitchEventHandling -e /dev/input/event16 -p ${PWD}/testPress.sh -r ${PWD}/testRelease.sh
# Output
Pressed: Hello World
Released: Bye World
Pressed: Hello World
Released: Bye World
Pressed: Hello World
Released: Bye World
...
```
