# make-esp-sdk

Makefile to build the GNU C Compiler toolchain for Espressif ESP8266 with a standalone SDK.

It was developed for use with Cygwin on Windows. It should be easy to maintain and configure without additional files and scripts.

Travis-CI build status for Linux and MacOS64.

[![Travis Build Status](https://travis-ci.org/Juppit/make-esp-sdk.svg?branch=master)](https://travis-ci.org/Juppit/make-esp-sdk)

AppVeyor build status for Cygwin64 and MinGW64.

[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/Juppit/make-esp-sdk?svg=true)](https://ci.appveyor.com/project/Juppit/make-esp-sdk)

You should be able to build the toolchain with the following systems:
- Cygwin64
- MinGW64
- Linux
- MacOS64

But, it is still **Work in Progress**.

Install the project in a directory of your choice, for example 'make-esp-sdk':
```bash
  git clone https://github.com/Juppit/make-esp-sdk make-esp-sdk
```

If you like to prepare the build before you start 'make' you can download most sources into the tarballs directory:
```bash
  make get-tars
```

When you edit the 'Makefile', you can use the listed versions:
```bash
  xtensa-lx106-elf-sdk:   version 2.2.x  down to 2.0.0
```

You can configure the 'Makefile' to create the project with or without lwip and gdb.

Use this command to create the project by default:
```bash
  make                  # build all with latest versions
```
this will give you the parts listed below,

or use this commands to create parts of the project:
```bash
  make build-gmp        # version 6.1.2  down to 6.0.0a
  make build-mpfr       # version 4.0.1  down to 3.1.1
  make build-mpc        # version 1.1.0  down to 1.0.1
  make build-binutils   # version 2.30   down to 2.26
  make build-gcc-1      # version 8.1.0  down to 4.8.2
  make build-newlib     # version xtensa
  make build-gcc-2
  make build-libhal     # version lx106-hal
  make build-lwip       # version esp-open-lwip
```
The listed versions should be created without errors.

Use this command to create only the GNU debugger:
```bash
  make USE_GDB=y gdb
```

To rebuild one of the above parts, it should be enough to:
- delete the corresponding file <src/.xxx-vvv.loaded> from 'src' directory, for example <src/.mpc-1.1.0.loaded>.

Note: build directories are named after the operating system, for example 'build-Cygwin64'

With this commands you can clean up the build system:
```bash
  make clean            # removes all build directories and all markers like <src/.mpfr-4.0.1.installed>
  make purge            # removes additionally the source directories
```
