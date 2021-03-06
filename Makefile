PLATFLAGS :=
USE_JIT = 1
USE_NEON = 0
# DEBUG=1
# PROFILE=1

ifeq ($(platform),)
platform = unix
ifeq ($(shell uname -a),)
   platform = win
else ifneq ($(findstring MINGW,$(shell uname -a)),)
   platform = win
else ifneq ($(findstring Darwin,$(shell uname -a)),)
   platform = osx
else ifneq ($(findstring win,$(shell uname -a)),)
   platform = win
else ifneq ($(findstring arm,$(shell uname -a)),)
    PLATFLAGS +=  -DARM
endif
endif

TARGET_ARCH := $(shell uname -m)
TARGET_NAME := fsuae

CORE_DIR  := .
ROOT_DIR  := .

CFLAGS += -pthread -I/usr/include/glib-2.0 -I/usr/lib/x86_64-linux-gnu/glib-2.0/include
LDFLAGS += -lgthread-2.0 -pthread -lglib-2.0

ifeq ($(platform), unix) ## (linux ARM: --enable-neon available)
   CFLAGS+=-DLINUX
   CC = gcc
   TARGET := $(TARGET_NAME)_libretro.so
   fpic := -fPIC
   LDFLAGS += -lz -lpthread
   SHARED := -shared -Wl,--version-script=$(CORE_DIR)/libretro/link.T
   ifeq ($(USE_JIT), 1)
      ifeq ($(TARGET_ARCH), x86_64) # JIT => address space 32 bits
	 # SHARED += -Wl,-Ttext-segment=0x200000
      endif
   endif
# use for raspberry pi
else ifeq ($(platform), osx)
   TARGET := $(TARGET_NAME)_libretro.dylib
   fpic := -fPIC -mmacosx-version-min=10.6
   SHARED := -dynamiclib
   PLATFLAGS +=  -DRETRO -DLSB_FIRST -DALIGN_DWORD
else ifeq ($(platform), android-armv7)
   CC = arm-linux-androideabi-gcc
   AR = @arm-linux-androideabi-ar
   LD = @arm-linux-androideabi-g++ 
   TARGET := $(TARGET_NAME)_libretro_android.so
   fpic := -fPIC
	LDFLAGS += -lz -lm
   SHARED :=  -Wl,--fix-cortex-a8 -shared -Wl,--version-script=$(CORE_DIR)/libretro/link.T -Wl,--no-undefined
   PLATFLAGS += -DANDROID -DRETRO -DAND -DLSB_FIRST -DALIGN_DWORD -DANDPORT -DA_ZIP
else ifeq ($(platform), android)
   CC = arm-linux-androideabi-gcc
   AR = @arm-linux-androideabi-ar
   LD = @arm-linux-androideabi-g++ 
   TARGET := $(TARGET_NAME)_libretro_android.so
   fpic := -fPIC
	LDFLAGS += -lz
   SHARED :=  -Wl,--fix-cortex-a8 -shared -Wl,--version-script=$(CORE_DIR)/libretro/link.T -Wl,--no-undefined
   PLATFLAGS += -DANDROID -DRETRO -DAND -DLSB_FIRST -DALIGN_DWORD -DANDPORT -DARM_OPT_TEST=1
else ifeq ($(platform), wii)
   TARGET := $(TARGET_NAME)_libretro_$(platform).a
   CC = $(DEVKITPPC)/bin/powerpc-eabi-gcc$(EXE_EXT)
   AR = $(DEVKITPPC)/bin/powerpc-eabi-ar$(EXE_EXT)   
   ZLIB_DIR = $(LIBUTILS)/zlib/
   CFLAGS += -DSDL_BYTEORDER=SDL_BIG_ENDIAN -DMSB_FIRST -DBYTE_ORDER=BIG_ENDIAN  -DBYTE_ORDER=BIG_ENDIAN \
	-DWIIPORT=1 -DHAVE_MEMALIGN -DHAVE_ASPRINTF -I$(ZLIB_DIR) -I$(DEVKITPRO)/libogc/include \
	-D__powerpc__ -D__POWERPC__ -DGEKKO -DHW_RVL -mrvl -mcpu=750 -meabi -mhard-float -D__ppc__
   LDFLAGS +=   -lm -lpthread -lc
   PLATFLAGS +=  -DRETRO -DALIGN_DWORD -DWIIPORT
else ifeq ($(platform), ps3)
   TARGET := $(TARGET_NAME)_libretro_$(platform).a
   CC = $(CELL_SDK)/host-win32/ppu/bin/ppu-lv2-gcc.exe
   AR = $(CELL_SDK)/host-win32/ppu/bin/ppu-lv2-ar.exe
   ZLIB_DIR = $(LIBUTILS)/zlib/
   LDFLAGS +=   -lm -lpthread -lc
   CFLAGS += -DSDL_BYTEORDER=SDL_BIG_ENDIAN -DMSB_FIRST -DBYTE_ORDER=BIG_ENDIAN  -DBYTE_ORDER=BIG_ENDIAN \
	-D__CELLOS_LV2 -DPS3PORT=1 -DHAVE_MEMALIGN -DHAVE_ASPRINTF -I$(ZLIB_DIR) 
   PLATFLAGS +=  -DRETRO -DALIGN_DWORD 
else


ifeq ($(subplatform), 32)
   CC = i586-mingw32msvc-gcc
else
   CC = x86_64-w64-mingw32-gcc
   CFLAGS += -fno-aggressive-loop-optimizations
endif
   PLATFLAGS +=  -DRETRO -DLSB_FIRST -DALIGN_DWORD -DWIN32PORT -DWIN32
   TARGET := $(TARGET_NAME)_libretro.dll
   fpic := -fPIC
   SHARED := -shared -static-libgcc -s -Wl,--version-script=$(CORE_DIR)/libretro/link.T -Wl,--no-undefined 
	LDFLAGS += -lm -lz
endif

ifeq ($(DEBUG), 1)
#-DDEBUG_MEM
   CFLAGS += -O0 -g -DDEBUG -DLOG_ALLOCATIONS
else
   CFLAGS += -O2
endif

ifeq ($(PROFILE), 1)
   CFLAGS += -pg
endif

ifeq ($(USE_NEON), 1)
   CFLAGS += -DUSE_ARMNEON
endif

ifeq ($(USE_FSUAEDIRS), 1)
   DEFINES += -DUSE_FSUAEDIRS
endif

DEFINES +=   -DFPUEMU -DUNALIGNED_PROFITABLE -DAMAX -DAGA -DAUTOCONFIG -DFILESYS  -DFDI2RAW -DDEBUGGER -DSAVESTATE -DENFORCER -DACTION_REPLAY
#-DSCSIEMU -DSCSIEMU_LINUX_IOCTL -DUSE_SDL -DDRIVESOUND -DBSDSOCKET -DCDTV -DCD32  -DA2091 -DNCR  -DGAYLE
DEFINES += -D__LIBRETRO__
CFLAGS += $(DEFINES) -DRETRO=1 -DINLINE="inline" -std=gnu11

CFLAGS += -DHAVE_CONFIG_H
include Makefile.common

OBJECTS += $(SOURCES_C:.c=.o) $(SOURCES_CXX:.cpp=.o) $(SOURCES_ASM:.S=.o)

INCDIRS := $(EXTRA_INCLUDES) $(INCFLAGS) -I/usr/include/glib-2.0 -I/usr/lib/x86_64-linux-gnu/glib-2.0/include

all: $(TARGET)

$(TARGET): $(OBJECTS) 
ifeq ($(STATIC_LINKING),1)
	$(AR) rcs $@ $(OBJECTS) 
else
	$(CC) $(fpic) $(SHARED) $(INCDIRS) -o $@ $(OBJECTS) $(LDFLAGS)
endif

%.o: %.c
	$(CC) $(fpic) $(CFLAGS) $(PLATFLAGS) $(INCDIRS) -c -o $@ $<

%.o: %.S
	$(CC_AS) $(CFLAGS) -c $^ -o $@

clean:
	rm -f $(OBJECTS) $(TARGET) 

distclean: clean
	rm -Rf config.log config.status stamp-h1 configure autom4te.cache/ compile depcomp missing ltmain.sh aclocal.m4 config.h test-driver config.guess config.sub install-sh config.h.in config.h.in~
	find . -name .deps | xargs rm -Rf;
	find . -name .dirstamp | xargs rm -f;
	find . -name "*.o" | xargs rm -f;
	rm -f sources/Makefile sources/Makefile.in;
	rm -Rf sources/gen;
	rm -Rf Makefile

.PHONY: clean

gen:
	(unset ARCH; cd sources; mkdir -p gen)
	(unset ARCH; cd sources; make gen/build68k gen/genblitter gen/gencomp gen/gencpu gen/genlinetoscr)
	(unset ARCH; cd sources; make gen/cpudefs.c gen/comptbl.h gen/compemu.c gen/linetoscr.c gen/cpuemu_0.c gen/blit.h gen/blitfunc.c gen/blitfunc.h gen/blittable.c )
	(make clean)

clean_gen:
	rm -f sources/gen/{*.h,*.c,build68k,genblitter,gencomp,gencpu,genlinetoscr}

check_d:
	for f in in $$(find sources/src sources/gen  -type f); do basename "$$f";done| sort | uniq -d

nm: $(TARGET)
	nm -S $(TARGET) | grep " U "
