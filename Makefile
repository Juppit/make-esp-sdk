# Author: Peter Dobler (@Juppit)
#
# Credits to Max Fillipov (@jcmvbkbc) for major xtensa-toolchain (gcc-xtensa, newlib-xtensa)
# Credits to Paul Sokolovsky (@pfalcon) for esp-open-sdk
# Credits to Ivan Grokhotkov (@igrr) for compiler options (NLX_OPT) and library modifications
#
# Last edit: 27.03.2020

#*******************************************
#************** configuration **************
#*******************************************

# the standalone version is used only
STANDALONE = y
# debug = y	gives a lot of output
DEBUG ?= n

# use library default versions 
DEFAULT_VERSIONS = n

# compress:	reduces used disc space by approx. 40-50 percent
#			but installs some code, which looks like a virus
USE_COMPRESS ?= n
# strip:	reduces used disc space by approx. 40-50 percent
USE_STRIP    ?= y
# create tar-file for distribution
USE_DISTRIB ?= n

# build lwip-lib
USE_LWIP   ?= y
# build debugger
USE_GDB    ?= n

# following libraries are not necessary for esp8266
# Integer Set Library
USE_ISL    ?= n
# The Chunky Loop Generator
USE_CLOOG  ?= n
#
# ELF object file access library (supports 64-bit ELF files)
#https://fossies.org/linux/misc/old/libelf-0.8.13.tar.gz
USE_ELF    ?= n
# The Curses library "cursor optimization"
USE_CURSES ?= n
# XML-Parser
USE_EXPAT  ?= n

BUILDPATH = /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:

PLATFORM := $(shell uname -s)
ifneq (,$(findstring 64, $(shell uname -m)))
    ARCH := 64
else
    ARCH := 32
endif

BUILD :=
CURSES_MINGW_BUILD :=

BUILD_OS := $(PLATFORM)
ifeq ($(OS),Windows_NT)
    ifneq (,$(findstring MINGW32,$(PLATFORM)))
        BUILD_OS := Mingw$(ARCH)
        BUILDPATH := /mingw$(ARCH)/bin:$(BUILDPATH)
        # on Mingw only for CURSES necessary
        CURSES_MINGW_BUILD := --build=x86_64-pc-mingw$(ARCH)
    endif
    ifneq (,$(findstring MINGW64,$(PLATFORM)))
        BUILD_OS := Mingw$(ARCH)
        BUILDPATH := /mingw$(ARCH)/bin:$(BUILDPATH)
        # on Mingw only for CURSES necessary
        CURSES_MINGW_BUILD := --build=x86_64-pc-mingw$(ARCH)
    endif
    ifneq (,$(findstring MSYS,$(PLATFORM)))
        #BUILD_OS := MSYS$(ARCH)
        BUILD_OS := Msys$(ARCH)
        #BUILDPATH := /msys$(ARCH)/usr/bin:$(BUILDPATH)
        BUILDPATH := /c/ProgramData/Chocolatey/bin:/usr/bin:$(BUILDPATH)
    endif
    ifneq (,$(findstring CYGWIN,$(PLATFORM)))
        BUILD_OS := Cygwin$(ARCH)
        # on Cygwin necessary for GMP and GDB
        BUILD := --build=x86_64-unknown-cygwin
    endif
    ifneq (,$(findstring Cygwin,$(PLATFORM)))
        BUILD_OS := Cygwin$(ARCH)
        # on Cygwin necessary for GMP and GDB
        BUILD := --build=x86_64-unknown-cygwin
    endif
else
    ifeq ($(PLATFORM),Darwin)
        BUILD_OS := MacOS$(ARCH)
    endif
    ifeq ($(PLATFORM),Linux)
        BUILD_OS := Linux$(ARCH)
        ifneq (,$(findstring ARM,$(PLATFORM)))
            BUILD_OS := LinuxARM$(ARCH)
        endif
        ifneq (,$(findstring AARCH64,$(PLATFORM)))
            BUILD_OS := LinuxARM$(ARCH)
        endif
    endif
endif

# tar-file for distribution
DISTRIB  = $(BUILD_OS)-$(TARGET)

# various hosts are not supported like 'darwin'
#HOST  = x86_64-apple-darwin14.0.0
TARGET = xtensa-lx106-elf

# xtensa-lx106-elf-gcc means the executable e.g. xtensa-lx106-elf-gcc.exe
XCC  := $(TARGET)-cc
XGCC := $(TARGET)-gcc
XAR  := $(TARGET)-ar
XOCP := $(TARGET)-objcopy

# listed versions are somewhat tested
# the last versions will be used
SDK_VERSION = 2.0.0
ESP_SDK_VERSION = 020000
SDK_VERSION = 2.1.0
SDK_VERSION = 2.1.x
ESP_SDK_VERSION = 020100
SDK_VERSION = 2.2.0
SDK_VERSION = 2.2.x
ESP_SDK_VERSION = 020200
SDK_VERSION = 2.2.1
ESP_SDK_VERSION = 020201
#SDK_VERSION = 3.0
#ESP_SDK_VERSION = 030000

GMP_VERSION  = 6.1.0
#GMP_VERSION  = 6.1.1
#GMP_VERSION  = 6.1.2

MPFR_VERSION = 3.1.4
#MPFR_VERSION = 3.1.5
#MPFR_VERSION = 3.1.6
#MPFR_VERSION = 4.0.0
#MPFR_VERSION = 4.0.1

MPC_VERSION  = 1.0.3
#MPC_VERSION  = 1.1.0

GCC_VERSION  = 4.8.2
GCC_VERSION  = 4.9.2
GCC_VERSION  = 5.1.0
GCC_VERSION  = 5.2.0
GCC_VERSION  = 5.3.0
GCC_VERSION  = 5.5.0
GCC_VERSION  = 6.4.0
#GCC_VERSION = 7.1.0
GCC_VERSION  = 7.2.0
GCC_VERSION  = 7.3.0
GCC_VERSION  = 8.1.0
#GCC_VERSION  = xtensa
GCC_VERSION  = 9.1.0
GCC_VERSION  = 9.2.0

GCC_VERSION  = xtensa
GCC_BRANCH   = 4.8.2

GDB_VERSION  = 7.5.1
GDB_VERSION  = 7.10
GDB_VERSION  = 7.11
GDB_VERSION  = 7.12
GDB_VERSION  = 7.12.1
GDB_VERSION  = 8.0.1
GDB_VERSION  = 8.1
#GDB_VERSION  = 8.2

BIN_VERSION  = 2.26
BIN_VERSION  = 2.27
BIN_VERSION  = 2.28
BIN_VERSION  = 2.29
BIN_VERSION  = 2.29.1
BIN_VERSION  = 2.30
#BIN_VERSION  = 2.31
BIN_VERSION  = xtensa

#NLX_VERSION  = 2.5.0
#NLX_VERSION  = 3.0.0
#NLX_VERSION  = esp32
NLX_VERSION  = xtensa

HAL_VERSION  = lx106-hal

CURSES_VERSION = 6.0
CURSES_VERSION = 6.1

EXPAT_VERSION = 2.1.0
EXPAT_VERSION = 2.2.5

ISL_VERSION   = 0.14
ISL_VERSION   = 0.18

CLOOG_VERSION = 0.18.1
CLOOG_VERSION = 0.18.4

LWIP_VERSION  = lwip2
LWIP_VERSION  = esp-open-lwip

ifeq ($(DEFAULT_VERSIONS),y)
GMP_VERSION   = 6.1.0
MPFR_VERSION  = 3.1.4
MPC_VERSION   = 1.0.3
BIN_VERSION   = 2.30
GCC_VERSION   = xtensa
GCC_BRANCH    = 4.8.2
HAL_VERSION   = lx106-hal
LWIP_VERSION  = esp-open-lwip
GDB_VERSION   = 8.1
NLX_VERSION   = xtensa
USE_ISL       = n
USE_CLOOG     = n
USE_CURSES    = n
USE_EXPAT     = n
USE_LWIP      = y
USE_GDB       = n
endif
#*******************************************
#************* define variables ************
#*******************************************

TOP = $(PWD)

TOOLCHAIN = $(TOP)/$(TARGET)
TARGET_DIR = $(TOOLCHAIN)/$(TARGET)

SAFEPATH = "$(TOOLCHAIN)/bin":$(BUILDPATH)

COMP_LIBS = comp_libs
COMP_LIBS_DIR = $(TOP)/$(COMP_LIBS)
SOURCE_DIR = $(TOP)/src
TAR_DIR = $(TOP)/tarballs
PATCHES_DIR = $(SOURCE_DIR)/patches
BUILD_DIR = build-$(BUILD_OS)
DIST_DIR = $(TOP)/distrib

OUTPUT_DATE = date +"%Y-%m-%d %X" 

# Log file
BUILD_LOG = $(DIST_DIR)/$(BUILD_OS)-build.log
ERROR_LOG = $(DIST_DIR)/$(BUILD_OS)-error.log

ifeq ($(USE_GDB),y)
  BUILD_LOG = $(DIST_DIR)/$(BUILD_OS)-$(GDB)-build.log
  ERROR_LOG = $(DIST_DIR)/$(BUILD_OS)-$(GDB)-error.log
endif

GNU_URL    = https://ftp.gnu.org/gnu
GNUGCC_URL = https://gcc.gnu.org/pub/gcc/infrastructure

GMP = gmp
GMP_DIR = $(SOURCE_DIR)/$(GMP)-$(GMP_VERSION)
# make it easy for gmp-6.0.0a
ifneq (,$(findstring 6.0.0a,$(GMP_VERSION)))
    GMP_DIR = $(SOURCE_DIR)/$(GMP)-6.0.0
endif
BUILD_GMP_DIR = $(GMP_DIR)/$(BUILD_DIR)
GMP_URL = $(GNU_URL)/$(GMP)/$(GMP)-$(GMP_VERSION).tar.bz2
#GMP_URL = $(GNUGCC_URL)/$(GMP)-$(GMP_VERSION).tar.bz2
GMP_TAR = $(TAR_DIR)/$(GMP)-$(GMP_VERSION).tar.bz2
GMP_TAR_DIR = $(GMP)-$(GMP_VERSION)

MPFR = mpfr
MPFR_DIR = $(SOURCE_DIR)/$(MPFR)-$(MPFR_VERSION)
BUILD_MPFR_DIR = $(MPFR_DIR)/$(BUILD_DIR)
MPFR_URL = $(GNU_URL)/$(MPFR)/$(MPFR)-$(MPFR_VERSION).tar.bz2
#MPFR_URL = $(GNUGCC_URL)/$(MPFR)-$(MPFR_VERSION).tar.bz2
MPFR_TAR = $(TAR_DIR)/$(MPFR)-$(MPFR_VERSION).tar.bz2
MPFR_TAR_DIR = $(MPFR)-$(MPFR_VERSION)

MPC = mpc
MPC_DIR = $(SOURCE_DIR)/$(MPC)-$(MPC_VERSION)
BUILD_MPC_DIR = $(MPC_DIR)/$(BUILD_DIR)
MPC_URL = $(GNU_URL)/$(MPC)/$(MPC)-$(MPC_VERSION).tar.gz
#MPC_URL = $(GNUGCC_URL)/$(MPC)-$(MPC_VERSION).tar.gz
MPC_TAR = $(TAR_DIR)/$(MPC)-$(MPC_VERSION).tar.gz
MPC_TAR_DIR = $(MPC)-$(MPC_VERSION)

BIN = binutils
BIN_DIR = $(SOURCE_DIR)/$(BIN)-$(BIN_VERSION)
BUILD_BIN_DIR = $(BIN_DIR)/$(BUILD_DIR)
BIN_URL = $(GNU_URL)/$(BIN)/$(BIN)-$(BIN_VERSION).tar.gz
BIN_TAR = $(TAR_DIR)/$(BIN)-$(BIN_VERSION).tar.gz
BIN_TAR_DIR = $(BIN)-$(BIN_VERSION)
ifneq (,$(findstring xtensa,$(BIN_VERSION)))
    BIN_URL = https://github.com/jcmvbkbc/binutils-gdb-xtensa/archive/master.zip
    BIN_TAR = $(TAR_DIR)/binutils-gdb-xtensa-master.zip
    BIN_TAR_DIR = binutils-gdb-xtensa-master
	USE_GDB = n
endif

NLX = newlib
NLX_DIR = $(SOURCE_DIR)/$(NLX)-$(NLX_VERSION)
BUILD_NLX_DIR = $(NLX_DIR)/$(BUILD_DIR)

# get from NLX_URL
# find as NLX_TAR (zip/tar.gz) in tarballs
# untar to NLX_TAR_DIR directory
# move from NLX_TAR_DIR to NLX_DIR
NLX_URL  = ftp://sourceware.org/pub/newlib/$(NLX)-$(NLX_VERSION).tar.gz
NLX_TAR  = $(TAR_DIR)/$(NLX)-$(NLX_VERSION).tar.gz
NLX_TAR_DIR = $(NLX)-$(NLX_VERSION)

ifneq (,$(findstring xtensa,$(NLX_VERSION)))
    NLX_URL  = https://github.com/jcmvbkbc/newlib-xtensa/archive/xtensa.zip
    NLX_TAR  = $(TAR_DIR)/newlib-xtensa-master.zip
    NLX_TAR_DIR = $(NLX)-xtensa-xtensa
endif

ifneq (,$(findstring esp32,$(NLX_VERSION)))
    NLX_URL  = https://github.com/espressif/newlib-esp32/archive/$(NLX_TAR)
    NLX_TAR  = $(TAR_DIR)/newlib-esp32.zip
    NLX_TAR_DIR = $(NLX)-esp32-master
endif

GCC = gcc
GCC_DIR = $(SOURCE_DIR)/$(GCC)-$(GCC_VERSION)
BUILD_GCC_DIR = $(GCC_DIR)/$(BUILD_DIR)
GCC_URL = $(GNU_URL)/$(GCC)/$(GCC)-$(GCC_VERSION)/$(GCC)-$(GCC_VERSION).tar.gz
GCC_TAR = $(TAR_DIR)/$(GCC)-$(GCC_VERSION).tar.gz
GCC_TAR_DIR = $(GCC)-$(GCC_VERSION)
ifneq (,$(findstring xtensa,$(GCC_VERSION)))
#    GCC_URL = https://github.com/jcmvbkbc/gcc-xtensa/archive/xtensa-ctng-$(GCC_VERSION).zip
#    GCC_TAR = $(TAR_DIR)/gcc-xtensa-xtensa-ctng-$(GCC_VERSION).zip
#    GCC_TAR_DIR = gcc-xtensa-xtensa-ctng-$(GCC_VERSION)
    GCC_URL = https://github.com/jcmvbkbc/gcc-xtensa/archive/master.zip
    GCC_TAR = $(TAR_DIR)/gcc-xtensa-master.zip
    GCC_TAR_DIR = gcc-xtensa-master
#    GCC_URL = https://github.com/jcmvbkbc/gcc-xtensa/archive/gcc-4_8_2-release.zip
#    GCC_TAR = $(TAR_DIR)/gcc-4_8_2-release
#    GCC_TAR_DIR = gcc-xtensa
endif

HAL = libhal
HAL_DIR = $(SOURCE_DIR)/$(HAL)-$(HAL_VERSION)
BUILD_HAL_DIR = $(HAL_DIR)/$(BUILD_DIR)
HAL_URL  = https://github.com/tommie/lx106-hal/archive/master.zip
HAL_TAR  = $(TAR_DIR)/$(HAL)-$(HAL_VERSION)-master.zip
HAL_TAR_DIR = $(HAL_VERSION)-master

GDB = gdb
GDB_DIR = $(SOURCE_DIR)/$(GDB)-$(GDB_VERSION)
BUILD_GDB_DIR = $(GDB_DIR)/$(BUILD_DIR)
GDB_URL = $(GNU_URL)/$(GDB)/$(GDB)-$(GDB_VERSION).tar.gz
GDB_TAR = $(TAR_DIR)/$(GDB)-$(GDB_VERSION).tar.gz
GDB_TAR_DIR = $(GDB)-$(GDB_VERSION)

LWIP = lwip
LWIP_DIR = $(SOURCE_DIR)/$(LWIP)-$(LWIP_VERSION)
BUILD_LWIP_DIR = $(LWIP_DIR)/$(BUILD_DIR)
LWIP_URL = https://github.com/pfalcon/esp-open-lwip/archive/sdk-1.5.0-experimental.zip
LWIP_TAR = $(TAR_DIR)/$(LWIP)-sdk-1.5.0-experimental.zip
LWIP_TAR_DIR = esp-open-lwip-sdk-1.5.0-experimental
ifeq ($(LWIP_VERSION),lwip2)
    BUILD_LWIP_DIR = $(LWIP_DIR)/build-536
    LWIP_URL = https://github.com/d-a-v/esp82xx-nonos-linklayer/archive/master.zip
    LWIP_TAR = $(TAR_DIR)/$(LWIP)-esp82xx-nonos-linklayer-master.zip
    LWIP_TAR_DIR = esp82xx-nonos-linklayer-master
endif

SDK = sdk
SDK_DIR = $(SOURCE_DIR)/$(SDK)-$(SDK_VERSION)

CURSES = ncurses
CURSES_DIR = $(SOURCE_DIR)/$(CURSES)-$(CURSES_VERSION)
BUILD_CURSES_DIR = $(CURSES_DIR)/$(BUILD_DIR)
CURSES_URL = $(GNU_URL)/$(CURSES)/$(CURSES)-$(CURSES_VERSION).tar.gz
CURSES_TAR = $(TAR_DIR)/$(CURSES)-$(CURSES_VERSION).tar.bz2
CURSES_TAR_DIR = $(CURSES)-$(CURSES_VERSION)

EXPAT = expat
EXPAT_DIR = $(SOURCE_DIR)/$(EXPAT)-$(EXPAT_VERSION)
BUILD_EXPAT_DIR = $(EXPAT_DIR)/$(BUILD_DIR)
EXPAT_URL = https://sourceforge.net/projects/expat/files/expat/$(EXPAT_VERSION)/expat-$(EXPAT_VERSION).tar.bz2/download
ifneq (,$(findstring 2.1.0,$(EXPAT_VERSION)))
    EXPAT_URL = https://github.com/libexpat/libexpat/releases/download/R_2_1_0/expat-2.1.0.tar.gz
endif
EXPAT_TAR = $(TAR_DIR)/$(EXPAT)-$(EXPAT_VERSION).tar.gz
EXPAT_TAR_DIR = $(EXPAT)-$(EXPAT_VERSION)

ISL = isl
ISL_DIR = $(SOURCE_DIR)/$(ISL)-$(ISL_VERSION)
BUILD_ISL_DIR = $(ISL_DIR)/$(BUILD_DIR)
ISL_URL = $(GNUGCC_URL)/$(ISL)-$(ISL_VERSION).tar.bz2
ISL_TAR = $(TAR_DIR)/$(ISL)-$(ISL_VERSION).tar.bz2
ISL_TAR_DIR = $(ISL)-$(ISL_VERSION)

CLOOG = cloog
CLOOG_DIR = $(SOURCE_DIR)/$(CLOOG)-$(CLOOG_VERSION)
BUILD_CLOOG_DIR = $(CLOOG_DIR)/$(BUILD_DIR)
CLOOG_URL = $(GNUGCC_URL)/$(CLOOG)-$(CLOOG_VERSION).tar.gz
CLOOG_TAR = $(TAR_DIR)/$(CLOOG)-$(CLOOG_VERSION).tar.gz
CLOOG_TAR_DIR = $(CLOOG)-$(CLOOG_VERSION)

CORE = $(GMP) $(MPFR) $(ISL) $(CLOOG) $(MPC) $(EXPAT) $(CURSES) $(BIN) $(GCC) $(NLX) $(HAL) $(SDK)
CORE_VERSIONS = $(GMP)-$(GMP_VERSION) $(MPFR)-$(MPFR_VERSION) $(ISL)-$(ISL_VERSION) $(CLOOG)-$(CLOOG_VERSION) \
				$(MPC)-$(MPC_VERSION) $(EXPAT)-$(EXPAT_VERSION) $(CURSES)-$(CURSES_VERSION) $(BIN)-$(BIN_VERSION) \
				$(GCC)-$(GCC_VERSION) $(NLX)-$(NLX_VERSION) $(HAL)-$(HAL_VERSION) $(SDK)-$(SDK_VERSION)
CORE_DIRS = $(GMP_DIR) $(MPFR_DIR) $(ISL_DIR) $(CLOOG_DIR) $(MPC_DIR) $(EXPAT_DIR) $(CURSES_DIR) $(BIN_DIR) $(GCC_DIR) $(NLX_DIR) $(HAL_DIR) $(SDK_DIR)
BUILD_CORE_DIRS = $(BUILD_GMP_DIR) $(BUILD_MPFR_DIR) $(BUILD_ISL_DIR) $(BUILD_CLOOG_DIR) $(BUILD_MPC_DIR) $(BUILD_EXPAT_DIR) $(BUILD_CURSES_DIR) $(BUILD_BIN_DIR) \
	$(BUILD_GCC_DIR)-stage1 $(BUILD_NLX_DIR) $(BUILD_GCC_DIR)-stage2 $(BUILD_HAL_DIR)
TOOLS = $(LWIP) $(GDB)
TOOL_DIRS = $(LWIP_DIR) $(GDB_DIR)
BUILD_TOOL_DIRS = $(BUILD_LWIP_DIR) $(BUILD_GDB_DIR)

ifeq ($(DEBUG),y)
	WGET     := wget -c --progress=dot:binary
	PATCH    := patch -b -N
	QUIET    :=
	UNTAR    := bsdtar -vxf
	UNZIP    := unzip -o
	CONF_OPT := configure
	INST_OPT := install
	MAKE_OPT :=
	AR_DEL   := dv
	AR_XTRACT:= xv
	AR_INSERT:= rv
	OCP_REDEF:= --redefine-sym
else
	WGET     := wget -cq
	PATCH    := patch -s -b -N 
	QUIET    := >>$(BUILD_LOG) 2>>$(ERROR_LOG)
	UNTAR    := bsdtar -xf
	UNZIP    := unzip -qo
	CONF_OPT := configure -q
	INST_OPT := install -s
	MAKE_OPT := V=1 -s
	AR_DEL   := d
	AR_XTRACT:= x
	AR_INSERT:= r
	OCP_REDEF:= --redefine-sym
endif

# on linux bsdtar has problems to extract some zip archives from github 
# so we use unzip on linux for zip archives
# if we are not on linux we use untar (bsdtar) also for zip archives
# this is necessary because unzip is not available on appveyor
ZIP_DIR_OPT = -d
ifeq (,$(findstring Linux,$(BUILD_OS)))
	UNZIP = $(UNTAR)
	ZIP_DIR_OPT = -C
endif

MKDIR := mkdir -p
RM    := rm -f
RMDIR := rm -R -f
MOVE  := mv -f
COPY  := cp -R -f

STRIPLINE = *************************
STRIP = ****

# for easy debugging
#QUIET    :=
#MAKE_OPT :=

# Under MacOS the syntax for mode description is different
FIND_MODE := /0111
ifeq ($(PLATFORM),Darwin)
	FIND_MODE := 0111
endif

WITH_GMP  = --with-$(GMP)=$(COMP_LIBS_DIR)/$(GMP)-$(GMP_VERSION)
WITH_GMP_PREFIX = --with-$(GMP)-prefix=$(COMP_LIBS_DIR)/$(GMP)-$(GMP_VERSION)
WITH_MPFR = --with-$(MPFR)=$(COMP_LIBS_DIR)/$(MPFR)-$(MPFR_VERSION)
WITH_MPC  = --with-$(MPC)=$(COMP_LIBS_DIR)/$(MPC)-$(MPC_VERSION)
#WITH_GMP  = --with-$(GMP)=$(GCC_DIR)/$(GMP)-$(GMP_VERSION)
#WITH_GMP_PREFIX = --with-$(GMP)-prefix=$(GCC_DIR)/$(GMP)-$(GMP_VERSION)
#WITH_MPFR = --with-$(MPFR)=$(GCC_DIR)/$(MPFR)-$(MPFR_VERSION)
#WITH_MPC  = --with-$(MPC)=$(GCC_DIR_)/$(MPC)-$(MPC_VERSION)
WITH_NLX  = --with-$(NLX)
WITH_ISL  =
WITH_CLOOG=
#include unused-options.inc
GMP_OPT   = --disable-shared --enable-static
MPFR_OPT  = --disable-shared --enable-static
MPC_OPT   = --disable-shared --enable-static $(WITH_GMP) $(WITH_MPFR)
BUILD_OPT = --enable-werror=no --disable-multilib --disable-nls --disable-shared --disable-threads \
            --with-gnu-as --with-gnu-ld
BIN_OPT   = $(BUILD_OPT) --with-$(GCC) $(WITH_GMP) $(WITH_MPFR) $(WITH_MPC) $(WITH_ISL)
#see: xtensa-lx106-elf-gcc-4.8.2.exe -v
GCC_OPT   = $(BUILD_OPT) $(WITH_GMP) $(WITH_MPFR) $(WITH_MPC) $(WITH_NLX) $(WITH_ISL) $(WITH_CLOOG) \
            --disable-libssp --disable-__cxa_atexit --disable-libstdcxx-pch \
			--enable-target-optspace --without-long-double-128 --disable-libgomp --disable-libmudflap \
			--disable-libquadmath --disable-libquadmath-support --disable-lto
GC1_OPT   = --enable-languages=c $(GCC_OPT) --without-headers
GC2_OPT   = --enable-languages=c,c++ $(GCC_OPT) --enable-cxx-flags='-fno-exceptions -fno-rtti'
NLX_OPT   = --enable-multilib --with-gnu-as --with-gnu-ld --disable-nls
NLX_OPT   = --enable-multilib --with-gnu-as --with-gnu-ld --disable-nls \
            --with-$(NLX) --enable-target-optspace --disable-option-checking \
            --enable-$(NLX)-nano-formatted-io --enable-$(NLX)-reent-small \
            --disable-$(NLX)-io-c99-formats --disable-$(NLX)-supplied-syscalls \
            --with-target-subdir=$(TARGET)

#			 --program-transform-name="s&^&$(TARGET)-&"
NLX_OPT1  = CROSS_CFLAGS="-fno-omit-frame-pointer -DSIGNAL_PROVIDED -DABORT_PROVIDED -DMALLOC_PROVIDED"
HAL_OPT   =
GDB_OPT   = $(BUILD_OPT)

#include unused-versions.inc
# from SDK_URL get archive with SDK_ZIP inside and extract to SDK_VER
SDK_URL_2.0.0 = "http://bbs.espressif.com/download/file.php?id=1690"
SDK_ZIP_2.0.0 = ESP8266_NONOS_SDK
SDK_VER_2.0.0 = esp_iot_sdk_v2.0.0
SDK_URL_2.1.0 = "https://github.com/espressif/ESP8266_NONOS_SDK/archive/v2.1.0.zip"
SDK_ZIP_2.1.0 = ESP8266_NONOS_SDK-2.1.0
SDK_VER_2.1.0 = esp_iot_sdk_v2.1.0
#ESP8266_NONOS_SDK-2.1.0-18-g61248df
SDK_URL_2.1.x = "https://github.com/espressif/ESP8266_NONOS_SDK/archive/release/v2.1.x.zip"
SDK_ZIP_2.1.x = ESP8266_NONOS_SDK-release-v2.1.x
SDK_VER_2.1.x = esp_iot_sdk_v2.1.x
SDK_URL_2.2.0 = "https://github.com/espressif/ESP8266_NONOS_SDK/archive/v2.2.0.zip"
SDK_ZIP_2.2.0 = ESP8266_NONOS_SDK-2.2.0
SDK_VER_2.2.0 = esp_iot_sdk_v2.2.0
#ESP8266_NONOS_SDK-2.2.0-3-gf8f27ce
SDK_URL_2.2.x = "https://github.com/espressif/ESP8266_NONOS_SDK/archive/release/v2.2.x.zip"
SDK_ZIP_2.2.x = ESP8266_NONOS_SDK-release-v2.2.x
SDK_VER_2.2.x = esp_iot_sdk_v2.2.x
SDK_URL_2.2.1 = "https://github.com/espressif/ESP8266_NONOS_SDK/archive/v2.2.1.zip"
SDK_ZIP_2.2.1 = ESP8266_NONOS_SDK-2.2.1
SDK_VER_2.2.1 = esp_iot_sdk_v2.2.1
SDK_URL_3.0   = "https://github.com/espressif/ESP8266_NONOS_SDK/archive/v3.0.zip"
SDK_ZIP_3.0   = ESP8266_NONOS_SDK-3.0
SDK_VER_3.0   = esp_iot_sdk_v3.0

SDK_ZIP = $(SDK_ZIP_$(SDK_VERSION))
SDK_URL = $(SDK_URL_$(SDK_VERSION))
SDK_VER = $(SDK_VER_$(SDK_VERSION))
SDK_TAR = $(TAR_DIR)/$(SDK_VER).zip
SDK_TAR_DIR = $(SDK_ZIP)

#*******************************************
#************** rules section **************
#*******************************************

.PHONY: build-part-1 build-part-2 get-tars
.PHONY: info-start info-build info info-gdb info-install
.PHONY: distrib install strip compress
.PHONY: clean clean-build clean-sdk
.PHONY: distrib-$(GDB) distrib-gdb-info strip-$(GDB)
.PHONY: build-$(GMP) build-$(MPFR) build-$(MPC) build-$(BIN) 
.PHONY: build-$(EXPAT) build-$(CURSES) build-$(CLOOG) build-$(ISL)
.PHONY: build-$(GCC)-1 build-$(NLX) build-$(GCC)-2 build-$(GDB)
.PHONY: build-$(HAL) build-$(SDK) build-$(SDK)-libs build-$(LWIP)

#*******************************************
#************* Build Toolchain *************
#*******************************************

all:
	@$(MAKE) $(MAKE_OPT) info-start
	@$(MAKE) $(MAKE_OPT) info-build
	@$(MAKE) $(MAKE_OPT) build-part-1
	@$(MAKE) $(MAKE_OPT) build-part-2
	@$(MAKE) $(MAKE_OPT) strip
	@$(MAKE) $(MAKE_OPT) compress
	@$(MAKE) $(MAKE_OPT) info
	@$(MAKE) $(MAKE_OPT) info-gdb
	@cat build-start.txt; rm build-start.txt
	@$(MAKE) $(MAKE_OPT) distrib
	@$(OUTPUT_DATE)
	@echo -e "\07"

install:
	@rm $(SOURCE_DIR)/.*.installed
	@$(MAKE) info-install
	@$(MAKE) $(MAKE_OPT) all

#*******************************************
#************* build targets ***************
#*******************************************

#**** allow most parallelization in build process
# CI process on travis and appveyor is limited
build-part-1: build-$(GMP) build-$(MPFR) build-$(MPC) build-$(BIN) build-$(EXPAT) build-$(CURSES) build-$(CLOOG) build-$(ISL) \
              build-$(GCC)-1 build-$(NLX) build-$(GCC)-2 build-$(HAL)
# remaining parts and additional tool
build-part-2: build-$(SDK) build-$(LWIP) build-$(SDK)-libs

# remaining debugger tool
$(GDB):
	@$(MAKE) $(MAKE_OPT) info-start
	@$(MAKE) $(MAKE_OPT) build-$(GDB) 2>>$(ERROR_LOG)
	@$(MAKE) $(MAKE_OPT) strip-$(GDB) 2>>$(ERROR_LOG)
	@$(MAKE) $(MAKE_OPT) info-gdb
	@$(MAKE) $(MAKE_OPT) distrib-$(GDB)
	@$(OUTPUT_DATE)
	@echo -e "\07"

#**** download all tar-files into tarballs
get-tars: $(TAR_DIR)
	@for TAR in $(CORE_VERSIONS); do $(MAKE) $(SOURCE_DIR)/.$$TAR.loaded $(QUIET); done
	@for TAR in $(TOOLS); do $(MAKE) get-$$TAR $(QUIET); done

get-$(LWIP):
ifeq ($(USE_LWIP),y)
	@$(MAKE) $(SOURCE_DIR)/.$(LWIP)-$(LWIP_VERSION).loaded
endif

get-$(GDB):
ifeq ($(USE_GDB),y)
	@$(MAKE) $(SOURCE_DIR)/.$(GDB)-$(GDB_VERSION).loaded
endif

#**** create needed directories

$(SOURCE_DIR):
	@$(MKDIR) $(SOURCE_DIR)

$(TAR_DIR):
	@$(MKDIR) $(TAR_DIR)

$(DIST_DIR):
	@$(MKDIR) $(DIST_DIR)

$(SDK_DIR):
	@$(MKDIR) $(SDK_DIR)

$(COMP_LIBS_DIR):
	@$(MKDIR) $(COMP_LIBS_DIR)
	@$(MKDIR) $(COMP_LIBS_DIR)/$(GMP)-$(GMP_VERSION)
	@$(MKDIR) $(COMP_LIBS_DIR)/$(MPFR)-$(MPFR_VERSION)
	@$(MKDIR) $(COMP_LIBS_DIR)/$(MPC)-$(MPC_VERSION)
ifeq ($(USE_LWIP),y)
	@$(MKDIR) $(COMP_LIBS_DIR)/$(LWIP)-$(LWIP_VERSION)
endif
ifeq ($(USE_GDB),y)
	@$(MKDIR) $(COMP_LIBS_DIR)/$(GDB)-$(GDB_VERSION)
endif

#include unused-targets.inc

#*** for the '|' token (order-only prerequisite) see: https://www.gnu.org/software/make/manual/html_node/Prerequisite-Types.html
$(TOOLCHAIN): | $(DIST_DIR) $(SOURCE_DIR) $(TAR_DIR) $(COMP_LIBS_DIR)
	@git config --global core.autocrlf false
	@$(MKDIR) $(TOOLCHAIN)
	@$(MKDIR) $(TARGET_DIR)

#*******************************************
#************* single targets **************
#*******************************************
#
build-$(GMP):    $(SOURCE_DIR)/.$(GMP)-$(GMP_VERSION).installed | $(TOOLCHAIN)
build-$(MPFR):   $(SOURCE_DIR)/.$(MPFR)-$(MPFR_VERSION).installed | $(TOOLCHAIN)
build-$(MPC):    $(SOURCE_DIR)/.$(MPC)-$(MPC_VERSION).installed | $(TOOLCHAIN)
build-$(BIN):    $(SOURCE_DIR)/.$(BIN)-$(BIN_VERSION).installed | $(TOOLCHAIN)
build-$(GCC)-1:  $(SOURCE_DIR)/.$(GCC)-$(GCC_VERSION)-stage1.installed | $(TOOLCHAIN)
build-$(NLX):    $(SOURCE_DIR)/.$(NLX)-$(NLX_VERSION).installed | $(TOOLCHAIN)
build-$(GCC)-2:  $(SOURCE_DIR)/.$(GCC)-$(GCC_VERSION)-stage2.installed | $(TOOLCHAIN)
build-$(HAL):    $(SOURCE_DIR)/.$(HAL)-$(HAL_VERSION).installed | $(TOOLCHAIN)
build-$(SDK):    $(SOURCE_DIR)/.$(SDK)-$(SDK_VERSION).installed | $(TOOLCHAIN)
build-$(SDK)-libs:  $(SOURCE_DIR)/.$(SDK)-$(SDK_VERSION)-libs.installed | $(TOOLCHAIN)

ifeq ($(USE_GDB),y)
build-$(GDB): $(SOURCE_DIR)/.$(GDB)-$(GDB_VERSION).installed | $(TOOLCHAIN)
else
build-$(GDB):
endif

ifeq ($(USE_LWIP),y)
build-$(LWIP): $(SOURCE_DIR)/.$(LWIP)-$(LWIP_VERSION).installed | $(TOOLCHAIN)
else
build-$(LWIP):
endif

#include unused-builds.inc

#*******************************************
#************** helper targets *************
#*******************************************
strip:
ifeq ($(USE_STRIP),y)
	@$(MAKE) $(MAKE_OPT) $(SOURCE_DIR)/.$(SDK)-$(SDK_VERSION).stripped
endif

strip-$(GDB):
ifeq ($(USE_STRIP),y)
	@$(MAKE) $(MAKE_OPT) $(SOURCE_DIR)/.$(GDB)-$(GDB_VERSION).stripped
endif

compress:
ifeq ($(USE_COMPRESS),y)
	@$(MAKE) $(MAKE_OPT) $(SOURCE_DIR)/.$(SDK)-$(SDK_VERSION).compressed
endif

distrib:
ifeq ($(USE_DISTRIB),y)
	@$(MAKE) $(MAKE_OPT) $(SOURCE_DIR)/.$(SDK)-$(SDK_VERSION).distributed
endif

distrib-$(GDB):
ifeq ($(USE_DISTRIB),y)
	@$(MAKE) $(MAKE_OPT) $(SOURCE_DIR)/.$(GDB)-$(GDB_VERSION).distributed
endif

#*******************************************
#****************** Infos ******************
#*******************************************

info-start:
	@date +"%Y-%m-%d %X" > build-start.txt
	@$(MKDIR) $(DIST_DIR)
	@cat build-start.txt > $(BUILD_LOG)
	@echo "" >> $(BUILD_LOG)
	@cat build-start.txt > $(ERROR_LOG)
	@echo "" >> $(ERROR_LOG)
	@$(OUTPUT_DATE)
	$(info Detected: $(BUILD_OS) on $(OS))
	$(info SafePath: $(SAFEPATH))
	$(info BuildPath: $(BUILDPATH))
	$(info Processors: $(NUMBER_OF_PROCESSORS))

info-build:
	$(info $(STRIPLINE))
	$(info $(STRIP) Build Toolchain...)
	$(info $(STRIPLINE))

info-install:
	$(info $(STRIPLINE))
	$(info $(STRIP) Install Toolchain...)
	$(info $(STRIPLINE))

info:
	$(info +------------------------------------------------+)
	$(info | $(TARGET) Toolchain is build with:)
	$(info |)
	$(info |   GMP      $(GMP_VERSION))
	$(info |   MPFR     $(MPFR_VERSION))
	$(info |   MPC      $(MPC_VERSION))
	$(info |   Binutils $(BIN_VERSION))
	$(info |   GCC      $(GCC_VERSION))
	$(info |   NEWLIB   $(NLX_VERSION))
	$(info |   LIBHAL   $(HAL_VERSION))
ifeq ($(USE_LWIP),y)
	$(info |   LWIP     $(LWIP_VERSION))
endif
#include unused-infos.inc
	$(info |)
	$(info |   SDK      $(SDK_VERSION))
	$(info +------------------------------------------------+)

info-gdb:
ifeq ($(USE_GDB),y)
	$(info +------------------------------------------------+)
	$(info | The debugger is builded:)
	$(info |   GDB      $(GDB_VERSION))
	$(info +------------------------------------------------+)
endif

info-inst:
	$(info +------------------------------------------------+)
	$(info | $(TARGET) Toolchain is built. To use it:)
	$(info |   export PATH=$(TOOLCHAIN)/bin:\$$PATH)
	$(info |)
ifneq ($(STANDALONE),y)
	$(info | Espressif ESP8266 SDK is installed.)
	$(info | Toolchain contains only Open Source components)
	$(info | To link external proprietary libraries add:)
	$(info |)
	$(info |   $(XGCC) \\)
	$(info |       -I $(SDK_DIR)/include \\)
	$(info |       -L $(SDK_DIR)/lib)
	$(info +------------------------------------------------+)
else
	$(info | Espressif ESP8266 SDK is installed,)
	$(info |   libraries and headers are merged)
	$(info +------------------------------------------------+)
endif

distrib-info:
	$(info +------------------------------------------------+)
	$(info | The Toolchain will be packed for distribution,)
	$(info |   creating: $(DISTRIB).tar.gz)
	$(info +------------------------------------------------+)

distrib-info-$(GDB):
	$(info +------------------------------------------------+)
	$(info | The debugger will be packed for distribution,)
	$(info |   creating: $(BUILD_OS)-$(GDB)-$(GDB_VERSION).tar.gz)
	$(info +------------------------------------------------+)

#*******************************************
#*************** SDK  section **************
#*******************************************

$(SOURCE_DIR)/.$(SDK)-$(SDK_VERSION).distributed:
ifeq ($(USE_DISTRIB),y)
	@$(MAKE) info > $(DIST_DIR)/$(DISTRIB).info
	@$(MAKE) distrib-info
	@$(MKDIR) $(DIST_DIR)
	-@bsdtar -cz -f $(DIST_DIR)/$(DISTRIB).tar.gz $(TARGET)
	@ls $(DIST_DIR)/$(DISTRIB)*
	@touch $@
endif

$(SOURCE_DIR)/.$(SDK)-$(SDK_VERSION).loaded:
	$(call Load_Modul,$(SDK),$(SDK_VERSION),$(SDK_URL),$(SDK_TAR))
$(SOURCE_DIR)/.$(SDK)-$(SDK_VERSION).extracted: $(SOURCE_DIR)/.$(SDK)-$(SDK_VERSION).loaded
	$(call Extract_Modul,$(SDK),$(SDK_VERSION),$(SDK_DIR),$(SDK_TAR),$(SDK_TAR_DIR))
$(SOURCE_DIR)/.$(SDK)-$(SDK_VERSION).patched: $(SOURCE_DIR)/.$(SDK)-$(SDK_VERSION).extracted
	@$(MAKE) $(MAKE_OPT) sdk_patch
	@touch $@
$(SOURCE_DIR)/.$(SDK)-$(SDK_VERSION).installed: $(SOURCE_DIR)/.$(SDK)-$(SDK_VERSION).patched
	@$(RM) $(SOURCE_DIR)/.$(SDK)-$(SDK_VERSION).distributed
ifeq ($(STANDALONE),y)
	$(call Info_Modul,Install,$(SDK)...   )
	@cp -p -R -f $(SDK_DIR)/include/* $(TARGET_DIR)/include/
	@cp -p -R -f $(SDK_DIR)/lib/* $(TARGET_DIR)/lib/
	@sed -e 's/\r//' $(SDK_DIR)/ld/eagle.app.v6.ld | sed -e s@../ld/@@ >$(TARGET_DIR)/lib/eagle.app.v6.ld
	@sed -e 's/\r//' $(SDK_DIR)/ld/eagle.rom.addr.v6.ld >$(TARGET_DIR)/lib/eagle.rom.addr.v6.ld
endif
	@touch $@

#*******************************************
#*************** LIBs section **************
#*******************************************

$(SOURCE_DIR)/.$(SDK)-$(SDK_VERSION)-libs.installed: $(SOURCE_DIR)/.$(SDK)-$(SDK_VERSION).installed
	$(call Info_Modul,Modify,Libs... )
	@$(MAKE) $(MAKE_OPT) libc
	@$(TOOLCHAIN)/bin/$(XOCP) --rename-section .text=.irom0.text \
		--rename-section .literal=.irom0.literal $(TARGET_DIR)/lib/libc.a $(TARGET_DIR)/lib/libcirom.a;
	$(info $(STRIP) libcirom.a...   )
	@$(MAKE) $(MAKE_OPT) libmain
	@$(MAKE) $(MAKE_OPT) libgcc
	@$(MAKE) $(MAKE_OPT) libstdc++
	@touch $@

libc_objs = lib_a-bzero.o lib_a-memcmp.o lib_a-memcpy.o lib_a-memmove.o lib_a-memset.o lib_a-rand.o \
		lib_a-strcmp.o lib_a-strcpy.o lib_a-strlen.o lib_a-strncmp.o lib_a-strncpy.o lib_a-strstr.o
libc: $(TARGET_DIR)/lib/libc.a | $(TOOLCHAIN) $(NLX_DIR)
	@$(TOOLCHAIN)/bin/$(XAR) $(AR_DEL) $(TARGET_DIR)/lib/$@.a $(libc_objs)
	$(info $(STRIP) libc.a ...      )

# see https://github.com/esp8266/Arduino/blob/master/tools/sdk/lib/fix_sdk_libs.sh
libmain_objs = mem_manager.o time.o
libmain: $(TARGET_DIR)/lib/libmain.a
	@$(TOOLCHAIN)/bin/$(XAR) $(AR_DEL) $(TARGET_DIR)/lib/$@.a $(libmain_objs)
	@$(TOOLCHAIN)/bin/$(XAR) $(AR_XTRACT) $(TARGET_DIR)/lib/$@.a eagle_lwip_if.o user_interface.o
	@$(TOOLCHAIN)/bin/$(XOCP) $(OCP_REDEF) hostname=wifi_station_hostname eagle_lwip_if.o 
	@$(TOOLCHAIN)/bin/$(XOCP) $(OCP_REDEF) hostname=wifi_station_hostname user_interface.o 
	@$(TOOLCHAIN)/bin/$(XOCP) $(OCP_REDEF) default_hostname=wifi_station_default_hostname eagle_lwip_if.o 
	@$(TOOLCHAIN)/bin/$(XOCP) $(OCP_REDEF) default_hostname=wifi_station_default_hostname user_interface.o 
	@$(TOOLCHAIN)/bin/$(XAR) $(AR_INSERT) $(TARGET_DIR)/lib/$@.a eagle_lwip_if.o user_interface.o
	-@rm -f eagle_lwip_if.o user_interface.o
	$(info $(STRIP) libmain ...     )

libgcc_objs = _addsubdf3.o _addsubsf3.o _divdf3.o _divdi3.o _divsi3.o _extendsfdf2.o _fixdfsi.o _fixunsdfsi.o \
		_fixunssfsi.o _floatsidf.o _floatsisf.o _floatunsidf.o _floatunsisf.o _muldf3.o _muldi3.o _mulsf3.o \
		_truncdfsf2.o _udivdi3.o _udivsi3.o _umoddi3.o _umulsidi3.o
libgcc: $(TARGET_DIR)/lib/libgcc.a
	@$(TOOLCHAIN)/bin/$(XAR) $(AR_DEL) $(TARGET_DIR)/lib/$@.a $(libgcc_objs)
	$(info $(STRIP) libgcc  ...     )

# see https://github.com/esp8266/Arduino/blob/master/tools/sdk/lib/README.md
libstdc++_objs = pure.o vterminate.o guard.o functexcept.o del_op.o del_opv.o new_op.o new_opv.o
libstdc++: $(TARGET_DIR)/lib/libstdc++.a
	@$(TOOLCHAIN)/bin/$(XAR) $(AR_DEL) $(TARGET_DIR)/lib/$@.a $(libstdc++_objs)
	$(info $(STRIP) libstdc ...     )
	$(info $(STRIPLINE))

#*******************************************
#************ submodul section *************
#*******************************************
%.extracted: %.zip
	unzip -q $<
%.extracted: %.tar.gz
	$(UNTAR) $<

define Info_Modul
    @echo "$(STRIPLINE)"
    @echo "$(STRIP) $1 $2" | tee -a $(ERROR_LOG)
endef

define Load_Modul
    @$(MKDIR) $(TAR_DIR)
    @if ! test -s $4; then echo "$(STRIPLINE)"; fi
    @if ! test -s $4; then echo "$(STRIP) Load $1..." | tee -a $(ERROR_LOG); fi
    @#### Load: if not exist $4 then $(WGET) $3 --output-document $4 && $(RM) $(SOURCE_DIR)/.$1-$2.*ed
    @if ! test -s $4; then $(WGET) $3 --output-document $4 && $(RM) $(SOURCE_DIR)/.$1-$2.*ed; fi
    @touch $(SOURCE_DIR)/.$1-$2.loaded
endef

define Extract_Modul
    @if ! test -f $(SOURCE_DIR)/.$1-$2.extracted; then echo "$(STRIPLINE)"; fi
    @if ! test -f $(SOURCE_DIR)/.$1-$2.extracted; then echo "$(STRIP) Extract $1..." | tee -a $(ERROR_LOG); fi
    @#### Extract: if not exist $(SOURCE_DIR)/.$1-$2.extracted then $(RMDIR) $3 && untar/unzip $4 and mv src/$5 to $3
    @if ( test -f $(basename $4).gz)  && (! test -f $(SOURCE_DIR)/.$1-$2.extracted); then $(RMDIR) $3 && $(UNTAR) $4 -C $(SOURCE_DIR); fi
    @if ( test -f $(basename $4).bz2) && (! test -f $(SOURCE_DIR)/.$1-$2.extracted); then $(RMDIR) $3 && $(UNTAR) $4 -C $(SOURCE_DIR); fi
    @if ( test -f $(basename $4).zip) && (! test -f $(SOURCE_DIR)/.$1-$2.extracted); then $(RMDIR) $3 && $(UNZIP) $4 $(ZIP_DIR_OPT) $(SOURCE_DIR); fi
    -@if (! test -f $(SOURCE_DIR)/.$1-$2.extracted) && (! test -f $3); then $(MOVE) $(SOURCE_DIR)/$5 $3; fi
    @touch $(SOURCE_DIR)/.$1-$2.extracted
endef

define Config_Modul
    @echo "$(STRIPLINE)"
    @echo "$(STRIP) Config $1..." | tee -a $(ERROR_LOG)
    +@if ! test -f $(SOURCE_DIR)/.$1-$2.patched; then $(MAKE) $(MAKE_OPT) $1-$2_patch && touch $(SOURCE_DIR)/.$1-$2.patched; fi
    @$(MKDIR) $3
    @#### Config: Path=$(SAFEPATH); cd $3 ../$(CONF_OPT) $(BUILD) $4 $5
    +@PATH=$(SAFEPATH); cd $3; ../$(CONF_OPT) $(BUILD) $4 $5 $(QUIET)
    @touch $(SOURCE_DIR)/.$1-$2.configured
endef

define Build_Modul
    @echo "$(STRIPLINE)"
    @echo "$(STRIP) Build $1..." | tee -a $(ERROR_LOG)
    @#### Build: Path=$(SAFEPATH); $4 $(MAKE) $(MAKE_OPT) $5 -C $3
    @#### for '+' token see https://www.gnu.org/software/make/manual/html_node/Error-Messages.html
    +@PATH=$(SAFEPATH); $4 $(MAKE) $(MAKE_OPT) $5 -C $3 $(QUIET)
    @touch $(SOURCE_DIR)/.$1-$2.builded
endef

define Install_Modul
    @echo "$(STRIPLINE)"
    @echo "$(STRIP) Install $1..." | tee -a $(ERROR_LOG)
    @echo "$(STRIPLINE)"
    @#### "Install: Path=$(SAFEPATH); $(MAKE) $(MAKE_OPT) $4=$(INST_OPT) -C $3"
    +@PATH=$(SAFEPATH); $(MAKE) $(MAKE_OPT) $4 -C $3 $(QUIET)
    @$(OUTPUT_DATE)
    @touch $(SOURCE_DIR)/.$1-$2.installed
endef

define Move_Modul
    @echo "$(STRIPLINE)"
    @echo "$(STRIP) Move $1..." | tee -a $(ERROR_LOG)
    @echo "$(STRIPLINE)"
    +@if ! test -f $(SOURCE_DIR)/.$1-$2.patched; then $(MAKE) $(MAKE_OPT) $1-$2_patch && touch $(SOURCE_DIR)/.$1-$2.patched; fi
    @#### "Move: $(MOVE) $(SOURCE_DIR)/$1-$2 $(GCC_DIR)"
	@$(RMDIR) $(GCC_DIR)/$1-$2
    @$(MOVE) $(SOURCE_DIR)/$1-$2 $(GCC_DIR) $(QUIET)
    @$(OUTPUT_DATE)
    @touch $(SOURCE_DIR)/.$1-$2.moved
endef

#************** GMP (GNU Multiple Precision Arithmetic Library)
$(SOURCE_DIR)/.$(GMP)-$(GMP_VERSION).loaded:
	$(call Load_Modul,$(GMP),$(GMP_VERSION),$(GMP_URL),$(GMP_TAR))
$(SOURCE_DIR)/.$(GMP)-$(GMP_VERSION).extracted: $(SOURCE_DIR)/.$(GMP)-$(GMP_VERSION).loaded
	$(call Extract_Modul,$(GMP),$(GMP_VERSION),$(GMP_DIR),$(GMP_TAR),$(GMP_TAR_DIR))
$(SOURCE_DIR)/.$(GMP)-$(GMP_VERSION).configured: $(SOURCE_DIR)/.$(GMP)-$(GMP_VERSION).extracted
	$(call Config_Modul,$(GMP),$(GMP_VERSION),$(BUILD_GMP_DIR),--prefix=$(COMP_LIBS_DIR)/$(GMP)-$(GMP_VERSION),$(GMP_OPT))
$(SOURCE_DIR)/.$(GMP)-$(GMP_VERSION).builded: $(SOURCE_DIR)/.$(GMP)-$(GMP_VERSION).configured
	$(call Build_Modul,$(GMP),$(GMP_VERSION),$(BUILD_GMP_DIR))
$(SOURCE_DIR)/.$(GMP)-$(GMP_VERSION).installed: $(SOURCE_DIR)/.$(GMP)-$(GMP_VERSION).builded
	$(call Install_Modul,$(GMP),$(GMP_VERSION),$(BUILD_GMP_DIR),$(INST_OPT))

#************** MPFR (Multiple Precision Floating-Point Reliable Library)
$(SOURCE_DIR)/.$(MPFR)-$(MPFR_VERSION).loaded:
	$(call Load_Modul,$(MPFR),$(MPFR_VERSION),$(MPFR_URL),$(MPFR_TAR))
$(SOURCE_DIR)/.$(MPFR)-$(MPFR_VERSION).extracted: $(SOURCE_DIR)/.$(MPFR)-$(MPFR_VERSION).loaded
	$(call Extract_Modul,$(MPFR),$(MPFR_VERSION),$(MPFR_DIR),$(MPFR_TAR),$(MPFR_TAR_DIR))
$(SOURCE_DIR)/.$(MPFR)-$(MPFR_VERSION).configured: $(SOURCE_DIR)/.$(MPFR)-$(MPFR_VERSION).extracted $(SOURCE_DIR)/.$(GMP)-$(GMP_VERSION).installed
	$(call Config_Modul,$(MPFR),$(MPFR_VERSION),$(BUILD_MPFR_DIR),--prefix=$(COMP_LIBS_DIR)/$(MPFR)-$(MPFR_VERSION) -with-$(GMP)=$(COMP_LIBS_DIR)/$(GMP)-$(GMP_VERSION),$(MPFR_OPT))
$(SOURCE_DIR)/.$(MPFR)-$(MPFR_VERSION).builded: $(SOURCE_DIR)/.$(MPFR)-$(MPFR_VERSION).configured
	$(call Build_Modul,$(MPFR),$(MPFR_VERSION),$(BUILD_MPFR_DIR))
$(SOURCE_DIR)/.$(MPFR)-$(MPFR_VERSION).installed: $(SOURCE_DIR)/.$(MPFR)-$(MPFR_VERSION).builded
	$(call Install_Modul,$(MPFR),$(MPFR_VERSION),$(BUILD_MPFR_DIR),$(INST_OPT))

#$(SOURCE_DIR)/.$(MPFR)-$(MPFR_VERSION).moved: $(SOURCE_DIR)/.$(MPFR)-$(MPFR_VERSION).extracted
#	$(call Move_Modul,$(MPFR),$(MPFR_VERSION))

#************** MPC (Multiple precision complex arithmetic Library)
$(SOURCE_DIR)/.$(MPC)-$(MPC_VERSION).loaded:
	$(call Load_Modul,$(MPC),$(MPC_VERSION),$(MPC_URL),$(MPC_TAR))
$(SOURCE_DIR)/.$(MPC)-$(MPC_VERSION).extracted: $(SOURCE_DIR)/.$(MPC)-$(MPC_VERSION).loaded
	$(call Extract_Modul,$(MPC),$(MPC_VERSION),$(MPC_DIR),$(MPC_TAR),$(MPC_TAR_DIR))
$(SOURCE_DIR)/.$(MPC)-$(MPC_VERSION).configured: $(SOURCE_DIR)/.$(MPC)-$(MPC_VERSION).extracted $(SOURCE_DIR)/.$(MPFR)-$(MPFR_VERSION).installed
	$(call Config_Modul,$(MPC),$(MPC_VERSION),$(BUILD_MPC_DIR),--prefix=$(COMP_LIBS_DIR)/$(MPC)-$(MPC_VERSION) -with-$(MPFR)=$(COMP_LIBS_DIR)/$(MPFR)-$(MPFR_VERSION) -with-$(GMP)=$(COMP_LIBS_DIR)/$(GMP)-$(GMP_VERSION),$(MPC_OPT))
$(SOURCE_DIR)/.$(MPC)-$(MPC_VERSION).builded: $(SOURCE_DIR)/.$(MPC)-$(MPC_VERSION).configured
	$(call Build_Modul,$(MPC),$(MPC_VERSION),$(BUILD_MPC_DIR))
$(SOURCE_DIR)/.$(MPC)-$(MPC_VERSION).installed: $(SOURCE_DIR)/.$(MPC)-$(MPC_VERSION).builded
	$(call Install_Modul,$(MPC),$(MPC_VERSION),$(BUILD_MPC_DIR),$(INST_OPT))

#$(SOURCE_DIR)/.$(MPC)-$(MPC_VERSION).moved: $(SOURCE_DIR)/.$(MPC)-$(MPC_VERSION).extracted
#	$(call Move_Modul,$(MPC),$(MPC_VERSION))

#************** Binutils (The GNU binary utilities)
$(SOURCE_DIR)/.$(BIN)-$(BIN_VERSION).loaded:
	$(call Load_Modul,$(BIN),$(BIN_VERSION),$(BIN_URL),$(BIN_TAR))
$(SOURCE_DIR)/.$(BIN)-$(BIN_VERSION).extracted: $(SOURCE_DIR)/.$(BIN)-$(BIN_VERSION).loaded
	$(call Extract_Modul,$(BIN),$(BIN_VERSION),$(BIN_DIR),$(BIN_TAR),$(BIN_TAR_DIR))
$(SOURCE_DIR)/.$(BIN)-$(BIN_VERSION).configured: $(SOURCE_DIR)/.$(BIN)-$(BIN_VERSION).extracted $(SOURCE_DIR)/.$(GMP)-$(GMP_VERSION).installed
	$(call Config_Modul,$(BIN),$(BIN_VERSION),$(BUILD_BIN_DIR),--prefix=$(TOOLCHAIN) --target=$(TARGET),$(BIN_OPT))
$(SOURCE_DIR)/.$(BIN)-$(BIN_VERSION).builded: $(SOURCE_DIR)/.$(BIN)-$(BIN_VERSION).configured
	$(call Build_Modul,$(BIN),$(BIN_VERSION),$(BUILD_BIN_DIR))
$(SOURCE_DIR)/.$(BIN)-$(BIN_VERSION).installed: $(SOURCE_DIR)/.$(BIN)-$(BIN_VERSION).builded
	$(call Install_Modul,$(BIN),$(BIN_VERSION),$(BUILD_BIN_DIR),$(INST_OPT))

#************** GCC (The GNU C preprocessor)
$(SOURCE_DIR)/.$(GCC)-$(GCC_VERSION).loaded:
	$(call Load_Modul,$(GCC),$(GCC_VERSION),$(GCC_URL),$(GCC_TAR))
$(SOURCE_DIR)/.$(GCC)-$(GCC_VERSION).extracted: $(SOURCE_DIR)/.$(GCC)-$(GCC_VERSION).loaded
	$(call Extract_Modul,$(GCC),$(GCC_VERSION),$(GCC_DIR),$(GCC_TAR),$(GCC_TAR_DIR))
#************** GCC Stage 1
$(SOURCE_DIR)/.$(GCC)-$(GCC_VERSION)-stage1.configured: $(SOURCE_DIR)/.$(GCC)-$(GCC_VERSION).extracted $(SOURCE_DIR)/.$(MPC)-$(MPC_VERSION).installed $(SOURCE_DIR)/.$(BIN)-$(BIN_VERSION).installed
	$(call Config_Modul,$(GCC),$(GCC_VERSION)-stage1,$(BUILD_GCC_DIR)-stage1,--prefix=$(TOOLCHAIN) --target=$(TARGET),$(GC1_OPT))
$(SOURCE_DIR)/.$(GCC)-$(GCC_VERSION)-stage1.builded: $(SOURCE_DIR)/.$(GCC)-$(GCC_VERSION)-stage1.configured
	$(call Build_Modul,$(GCC),$(GCC_VERSION)-stage1,$(BUILD_GCC_DIR)-stage1,,all-gcc)
$(SOURCE_DIR)/.$(GCC)-$(GCC_VERSION)-stage1.installed: $(SOURCE_DIR)/.$(GCC)-$(GCC_VERSION)-stage1.builded
	$(call Install_Modul,$(GCC),$(GCC_VERSION)-stage1,$(BUILD_GCC_DIR)-stage1,install-gcc)
	@cp -p -f $(TOOLCHAIN)/bin/$(XGCC) $(TOOLCHAIN)/bin/$(XCC)

$(TOOLCHAIN)/bin/$(XGCC): $(SOURCE_DIR)/.$(BIN)-$(BIN_VERSION).installed
	@cp -p -f $(TOOLCHAIN)/bin/$(XGCC) $(TOOLCHAIN)/bin/$(XCC)

#************** GCC Stage 2
$(SOURCE_DIR)/.$(GCC)-$(GCC_VERSION)-stage2.configured: $(SOURCE_DIR)/.$(GCC)-$(GCC_VERSION)-stage1.installed $(SOURCE_DIR)/.$(NLX)-$(NLX_VERSION).installed
	$(call Config_Modul,$(GCC),$(GCC_VERSION)-stage2,$(BUILD_GCC_DIR)-stage2,--prefix=$(TOOLCHAIN) --target=$(TARGET),$(GC2_OPT))
$(SOURCE_DIR)/.$(GCC)-$(GCC_VERSION)-stage2.builded: $(SOURCE_DIR)/.$(GCC)-$(GCC_VERSION)-stage2.configured
	$(call Build_Modul,$(GCC),$(GCC_VERSION)-stage2,$(BUILD_GCC_DIR)-stage2)
$(SOURCE_DIR)/.$(GCC)-$(GCC_VERSION)-stage2.installed: $(SOURCE_DIR)/.$(GCC)-$(GCC_VERSION)-stage2.builded
	$(call Install_Modul,$(GCC),$(GCC_VERSION)-stage2,$(BUILD_GCC_DIR)-stage2,$(INST_OPT))

#************** Newlib (ANSI C library, math library, and collection of board support packages)
$(SOURCE_DIR)/.$(NLX)-$(NLX_VERSION).loaded:
	$(call Load_Modul,$(NLX),$(NLX_VERSION),$(NLX_URL),$(NLX_TAR))
$(SOURCE_DIR)/.$(NLX)-$(NLX_VERSION).extracted: $(SOURCE_DIR)/.$(NLX)-$(NLX_VERSION).loaded
	$(call Extract_Modul,$(NLX),$(NLX_VERSION),$(NLX_DIR),$(NLX_TAR),$(NLX_TAR_DIR))
$(SOURCE_DIR)/.$(NLX)-$(NLX_VERSION).configured: $(SOURCE_DIR)/.$(NLX)-$(NLX_VERSION).extracted $(SOURCE_DIR)/.$(GCC)-$(GCC_VERSION)-stage1.installed
	$(call Config_Modul,$(NLX),$(NLX_VERSION),$(BUILD_NLX_DIR),$(NLX_OPT1),--prefix=$(TOOLCHAIN) --target=$(TARGET),$(NLX_OPT))
$(SOURCE_DIR)/.$(NLX)-$(NLX_VERSION).builded: $(SOURCE_DIR)/.$(NLX)-$(NLX_VERSION).configured
	$(call Build_Modul,$(NLX),$(NLX_VERSION),$(BUILD_NLX_DIR),$(NLX_OPT1),all)
	@$(MAKE) $(MAKE_OPT) -C $(BUILD_NLX_DIR) $(QUIET)
$(SOURCE_DIR)/.$(NLX)-$(NLX_VERSION).installed: $(SOURCE_DIR)/.$(NLX)-$(NLX_VERSION).builded
	$(call Install_Modul,$(NLX),$(NLX_VERSION),$(BUILD_NLX_DIR),$(INST_OPT))

#************** Libhal (Hardware Abstraction Library for Xtensa LX106)
$(SOURCE_DIR)/.$(HAL)-$(HAL_VERSION).loaded:
	$(call Load_Modul,$(HAL),$(HAL_VERSION),$(HAL_URL),$(HAL_TAR))
$(SOURCE_DIR)/.$(HAL)-$(HAL_VERSION).extracted: $(SOURCE_DIR)/.$(HAL)-$(HAL_VERSION).loaded
	$(call Extract_Modul,$(HAL),$(HAL_VERSION),$(HAL_DIR),$(HAL_TAR),$(HAL_TAR_DIR))
	@cd $(HAL_DIR); autoreconf -i $(QUIET)
$(SOURCE_DIR)/.$(HAL)-$(HAL_VERSION).configured: $(SOURCE_DIR)/.$(HAL)-$(HAL_VERSION).extracted $(SOURCE_DIR)/.$(GCC)-$(GCC_VERSION)-stage2.installed
	$(call Config_Modul,$(HAL),$(HAL_VERSION),$(BUILD_HAL_DIR),--host=$(TARGET) -prefix=$(TOOLCHAIN)/$(TARGET),$(HAL_OPT))
$(SOURCE_DIR)/.$(HAL)-$(HAL_VERSION).builded: $(SOURCE_DIR)/.$(HAL)-$(HAL_VERSION).configured
	$(call Build_Modul,$(HAL),$(HAL_VERSION),$(BUILD_HAL_DIR))
$(SOURCE_DIR)/.$(HAL)-$(HAL_VERSION).installed: $(SOURCE_DIR)/.$(HAL)-$(HAL_VERSION).builded
	$(call Install_Modul,$(HAL),$(HAL_VERSION),$(BUILD_HAL_DIR),$(INST_OPT))

#************** GDB (The GNU debugger)
$(SOURCE_DIR)/.$(GDB)-$(GDB_VERSION).loaded:
	$(call Load_Modul,$(GDB),$(GDB_VERSION),$(GDB_URL),$(GDB_TAR))
$(SOURCE_DIR)/.$(GDB)-$(GDB_VERSION).extracted: $(SOURCE_DIR)/.$(GDB)-$(GDB_VERSION).loaded
	$(call Extract_Modul,$(GDB),$(GDB_VERSION),$(GDB_DIR),$(GDB_TAR),$(GDB_TAR_DIR))
$(SOURCE_DIR)/.$(GDB)-$(GDB_VERSION).configured: $(SOURCE_DIR)/.$(GDB)-$(GDB_VERSION).extracted
	$(call Config_Modul,$(GDB),$(GDB_VERSION),$(BUILD_GDB_DIR),--prefix=$(COMP_LIBS_DIR)/$(GDB)-$(GDB_VERSION),$(GDB_OPT))
$(SOURCE_DIR)/.$(GDB)-$(GDB_VERSION).builded: $(SOURCE_DIR)/.$(GDB)-$(GDB_VERSION).configured
	$(call Build_Modul,$(GDB),$(GDB_VERSION),$(BUILD_GDB_DIR))
$(SOURCE_DIR)/.$(GDB)-$(GDB_VERSION).installed: $(SOURCE_DIR)/.$(GDB)-$(GDB_VERSION).builded
	$(call Install_Modul,$(GDB),$(GDB_VERSION),$(BUILD_GDB_DIR),$(INST_OPT))

$(SOURCE_DIR)/.$(GDB)-$(GDB_VERSION).distributed:
ifeq ($(USE_DISTRIB),y)
	@$(MAKE) info-$(GDB) > $(BUILD_OS)-$(GDB)-$(GDB_VERSION).info
	@$(MAKE) distrib-info-$(GDB)
	@$(MKDIR) $(DIST_DIR)
	-@bsdtar -cz -f $(DIST_DIR)/$(BUILD_OS)-$(GDB)-$(GDB_VERSION).tar.gz $(COMP_LIBS)/$(GDB)-$(GDB_VERSION)
	@ls $(DIST_DIR)/$(BUILD_OS)-$(GDB)*
	@touch $@
endif

#************** LWIP
$(SOURCE_DIR)/.$(LWIP)-$(LWIP_VERSION).loaded:
	$(call Load_Modul,$(LWIP),$(LWIP_VERSION),$(LWIP_URL),$(LWIP_TAR))
$(SOURCE_DIR)/.$(LWIP)-$(LWIP_VERSION).extracted: $(SOURCE_DIR)/.$(LWIP)-$(LWIP_VERSION).loaded
	$(call Extract_Modul,$(LWIP),$(LWIP_VERSION),$(LWIP_DIR),$(LWIP_TAR),$(LWIP_TAR_DIR))
$(SOURCE_DIR)/.$(LWIP)-$(LWIP_VERSION).configured: $(SOURCE_DIR)/.$(LWIP)-$(LWIP_VERSION).extracted $(SOURCE_DIR)/.$(GCC)-$(GCC_VERSION)-stage2.installed $(SOURCE_DIR)/.$(SDK)-$(SDK_VERSION).installed
	@if ! test -f $(SOURCE_DIR)/.$(LWIP)-$(LWIP_VERSION).patched; then $(MAKE) $(LWIP)-$(LWIP_VERSION)_patch && touch $(SOURCE_DIR)/.$(LWIP)-$(LWIP_VERSION).patched; fi
	@touch $@
$(SOURCE_DIR)/.$(LWIP)-$(LWIP_VERSION).builded: $(SOURCE_DIR)/.$(LWIP)-$(LWIP_VERSION).configured
	$(call Build_Modul,$(LWIP),$(LWIP_VERSION),$(LWIP_DIR) -f Makefile.open CC=$(TOOLCHAIN)/bin/$(XGCC) AR=$(TOOLCHAIN)/bin/$(XAR) PREFIX=$(TOOLCHAIN))
$(SOURCE_DIR)/.$(LWIP)-$(LWIP_VERSION).installed: $(SOURCE_DIR)/.$(LWIP)-$(LWIP_VERSION).builded
	@cp -p -a $(LWIP_DIR)/include/arch $(LWIP_DIR)/include/lwip $(LWIP_DIR)/include/netif $(LWIP_DIR)/include/lwipopts.h $(TARGET_DIR)/include/
	@touch $@

#include unused-moduls.inc

#*******************************************
#************** patch section **************
#*******************************************

#include unused-sdk-patches.inc

$(SDK_DIR)/user_rf_cal_sector_set.o: $(SOURCE_DIR)/.$(SDK)-$(SDK_VERSION).extracted $(TOOLCHAIN)/bin/$(XGCC)
	@cp -p $(PATCHES_DIR)/$(SDK)/user_rf_cal_sector_set.c $(SDK_DIR)
	@cd $(SDK_DIR); $(TOOLCHAIN)/bin/$(XGCC) -O2 -I$(SDK_DIR)/include -c $(SDK_DIR)/user_rf_cal_sector_set.c

ESP8266_NONOS_SDK_V2.0.0_patch_16_08_09.zip:
	@$(WGET) --content-disposition "http://bbs.espressif.com/download/file.php?id=1654" --output-document $(PATCHES_DIR)/$(SDK)/$@
sdk-2.0.0_patch: ESP8266_NONOS_SDK_V2.0.0_patch_16_08_09.zip $(SDK_DIR)/user_rf_cal_sector_set.o
	@echo -e "#undef ESP_SDK_VERSION\n#define ESP_SDK_VERSION $(ESP_SDK_VERSION)" >>$(SDK_DIR)/include/esp_sdk_ver.h
	@$(UNTAR) $(PATCHES_DIR)/$(SDK)/ESP8266_NONOS_SDK_V2.0.0_patch_16_08_09.zip
	-@$(MOVE) libmain.a libnet80211.a libpp.a $(SDK_DIR_2.0.0)/lib/
	-@$(PATCH) -d $(SDK_DIR) -p1 -i $(PATCHES_DIR)/$(SDK)/c_types-c99_sdk_2.patch $(QUIET)
	@cd $(SDK_DIR)/lib; mkdir -p tmp; cd tmp; $(TOOLCHAIN)/bin/$(XAR) x ../libcrypto.a; cd ..; $(TOOLCHAIN)/bin/$(XAR) rs libwpa.a tmp/*.o; rm -R tmp
	@$(TOOLCHAIN)/bin/$(XAR) r $(SDK_DIR)/lib/libmain.a $(SDK_DIR)/user_rf_cal_sector_set.o
sdk-2.1.0_patch sdk-2.1.x_patch sdk-2.2.0_patch sdk-2.2.x_patch sdk-2.2.1_patch sdk-3.0_patch: $(SDK_DIR)/user_rf_cal_sector_set.o
	@echo -e "#undef ESP_SDK_VERSION\n#define ESP_SDK_VERSION $(ESP_SDK_VERSION)" >>$(SDK_DIR)/include/esp_sdk_ver.h
	-@$(PATCH) -d $(SDK_DIR) -p1 -i $(PATCHES_DIR)/$(SDK)/c_types-c99_sdk_2.patch $(QUIET)
	@cd $(SDK_DIR)/lib; mkdir -p tmp; cd tmp; $(TOOLCHAIN)/bin/$(XAR) x ../libcrypto.a; cd ..; $(TOOLCHAIN)/bin/$(XAR) rs libwpa.a tmp/*.o; rm -R tmp
	@$(TOOLCHAIN)/bin/$(XAR) r $(SDK_DIR)/lib/libmain.a $(SDK_DIR)/user_rf_cal_sector_set.o

sdk_patch:
	@$(MAKE) $(MAKE_OPT) sdk-$(SDK_VERSION)_patch

$(GMP)-$(GMP_VERSION)_patch:
ifneq "$(wildcard $(PATCHES_DIR)/$(GMP)/$(GMP_VERSION) )" ""
	-for i in $(PATCHES_DIR)/$(GMP)/$(GMP_VERSION)/*.patch; do $(PATCH) -d $(GMP_DIR) -p1 < $$i $(QUIET); done
endif

$(MPFR)-$(MPFR_VERSION)_patch:
ifneq "$(wildcard $(PATCHES_DIR)/$(MPFR)/$(MPFR_VERSION) )" ""
	-for i in $(PATCHES_DIR)/$(MPFR)/$(MPFR_VERSION)/*.patch; do $(PATCH) -d $(MPFR_DIR) -p1 < $$i $(QUIET); done
endif

$(MPC)-$(MPC_VERSION)_patch:
ifneq "$(wildcard $(PATCHES_DIR)/$(MPC)/$(MPC_VERSION) )" ""
	-for i in $(PATCHES_DIR)/$(MPC)/$(MPC_VERSION)/*.patch; do $(PATCH) -d $(MPC_DIR) -p1 < $$i $(QUIET); done
endif

$(GCC)-$(GCC_VERSION)-stage1_patch:

$(GCC)-$(GCC_VERSION)-stage2_patch:
ifneq "$(wildcard $(PATCHES_DIR)/$(GCC)/$(GCC_VERSION) )" ""
	-for i in $(PATCHES_DIR)/$(GCC)/$(GCC_VERSION)/*.patch; do $(PATCH) -d $(GCC_DIR) -p1 < $$i $(QUIET); done
endif

$(BIN)-$(BIN_VERSION)_patch:
ifneq "$(wildcard $(PATCHES_DIR)/$(BIN)/$(BIN_VERSION) )" ""
	-for i in $(PATCHES_DIR)/$(BIN)/$(BIN_VERSION)/*.patch; do $(PATCH) -d $(BIN_DIR) -p1 < $$i $(QUIET); done
endif

$(HAL)-$(HAL_VERSION)_patch:
ifneq "$(wildcard $(PATCHES_DIR)/$(HAL)/$(HAL_VERSION) )" ""
	-for i in $(PATCHES_DIR)/$(HAL)/$(HAL_VERSION)/*.patch; do $(PATCH) -d $(HAL_DIR) -p1 < $$i $(QUIET); done
endif

$(NLX)-$(NLX_VERSION)_patch:
ifneq "$(wildcard $(PATCHES_DIR)/$(NLX)/$(NLX_VERSION) )" ""
	-for i in $(PATCHES_DIR)/$(NLX)/$(NLX_VERSION)/*.patch; do $(PATCH) -d $(NLX_DIR) -p1 < $$i $(QUIET); done
	-@touch $(NLX_DIR)/$(NLX)/libc/sys/xtensa/include/xtensa/dummy.h
endif

$(GDB)-$(GDB_VERSION)_patch:
ifneq "$(wildcard $(PATCHES_DIR)/$(GDB)/$(GDB_VERSION) )" ""
	-for i in $(PATCHES_DIR)/$(GDB)/$(GDB_VERSION)/*.patch; do $(PATCH) -d $(GDB_DIR) -p1 < $$i $(QUIET); done
endif

$(LWIP)-$(LWIP_VERSION)_patch:
ifneq "$(wildcard $(PATCHES_DIR)/$(LWIP)/$(LWIP_VERSION) )" ""
	-for i in $(PATCHES_DIR)/$(LWIP)/$(LWIP_VERSION)/*.patch; do $(PATCH) -d $(LWIP_DIR) -p1 < $$i $(QUIET); done
endif

#include unused-patches.inc

#*******************************************
#*******************************************
#*******************************************

#************** Strip Debug
$(SOURCE_DIR)/.$(SDK)-$(SDK_VERSION).stripped:
	@$(OUTPUT_DATE)
	$(info $(STRIPLINE))
	$(info $(STRIP) stripping...)
	$(info $(STRIPLINE))
	@du -sh $(TOOLCHAIN)/bin
	-@find $(TOOLCHAIN) -maxdepth 2 -type f -perm $(FIND_MODE) -exec strip -s "{}" +
	@du -sh $(TOOLCHAIN)/bin
	@$(RM) $(SOURCE_DIR)/.$(SDK)-$(SDK_VERSION).distributed
	@touch $@

$(SOURCE_DIR)/.$(GDB)-$(GDB_VERSION).stripped:
	@$(OUTPUT_DATE)
	$(info $(STRIPLINE))
	$(info $(STRIP) strip $(GDB)...)
	$(info $(STRIPLINE))
	@du -sh $(COMP_LIBS_DIR)/$(GDB)-$(GDB_VERSION)
	-@find $(COMP_LIBS_DIR)/$(GDB)-$(GDB_VERSION) -maxdepth 2 -type f -perm $(FIND_MODE) -exec strip -s "{}" +
	@du -sh $(COMP_LIBS_DIR)/$(GDB)-$(GDB_VERSION)
	@$(RM) $(SOURCE_DIR)/.$(GDB).-$(GDB_VERSION)distributed
	@touch $@

#************** Compress via UPX
$(SOURCE_DIR)/.$(SDK)-$(SDK_VERSION).compressed:
	@$(OUTPUT_DATE)
	$(info $(STRIPLINE))
	$(info $(STRIP) compressing...)
	$(info $(STRIPLINE))
	@du -sh $(TOOLCHAIN)/bin
	-@find $(TOOLCHAIN) -maxdepth 2 -type f -perm $(FIND_MODE) -exec upx -q -1 "{}" +
	@$(OUTPUT_DATE)
	@du -sh $(TOOLCHAIN)/bin
	@$(RM) $(SOURCE_DIR)/.$(SDK)-$(SDK_VERSION).distributed
	@touch $@

#*******************************************
#************** clean section **************
#*******************************************
clean: clean-build clean-sdk

clean-build:
	$(info $(STRIPLINE))
	$(info $(STRIP) cleaning...)
	$(info $(STRIPLINE))
	-@$(RMDIR) $(TOOLCHAIN) $(COMP_LIBS_DIR)/ 
	@for DIR in $(BUILD_CORE_DIRS); do $(RMDIR) $$DIR; done
	@for DIR in $(CORE); do rm -f $(SOURCE_DIR)/.$$DIR*ed; done
	-@rm -f $(SOURCE_DIR)/.*ed
	@#$(MAKE) $(MAKE_OPT) -C $(LWIP_DIR) -f Makefile.open clean
	@$(MAKE) $(MAKE_OPT) clean-$(GDB)
clean-sdk:
	$(info $(STRIPLINE))
	$(info $(STRIP) clean-sdk...)
	$(info $(STRIPLINE))
	-@$(RMDIR) $(SDK_DIR)
clean-$(GDB):
	$(info $(STRIPLINE))
	$(info $(STRIP) clean-$(GDB)...)
	$(info $(STRIPLINE))
	@$(RMDIR) $(COMP_LIBS_DIR)/$(GDB)-$(GDB_VERSION) $(BUILD_GDB_DIR)
	@$(RM) $(SOURCE_DIR)/.$(GDB).*ed
purge: clean
	$(info $(STRIPLINE))
	$(info $(STRIP) purge...)
	$(info $(STRIPLINE))
	@for DIR in $(CORE_DIRS); do rm -rf $$DIR; done
	@for DIR in $(TOOL_DIRS); do rm -rf $$DIR; done
#rm -@rf $(TAR_DIR)/*.{zip,bz2,xz,gz}
