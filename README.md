# footSwitchEventHandling
Handle the press/release inputs of a foot switch and map them to a command

## Compile project

### Create project

Choose any of the build generators and build targets:

cmake -G"Eclipse CDT4 - Unix Makefiles" -DCMAKE_BUILD_TYPE=debug .
cmake -G"Eclipse CDT4 - Unix Makefiles" -DCMAKE_BUILD_TYPE=release .

Or via `ninja`
cmake -G"Eclipse CDT4 - Ninja" -DCMAKE_BUILD_TYPE=debug .
cmake -G"Eclipse CDT4 - Ninja" -DCMAKE_BUILD_TYPE=release .

### Build them

`make` or `ninja`