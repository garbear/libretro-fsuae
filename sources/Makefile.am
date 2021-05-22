# Makefile.am for FS-UAE

USE_JIT = @USE_JIT@
USE_NEON = @USE_NEON@

SUBDIRS =

WARNINGS =

#ifeq ($(USE_JIT), 1)
#  AM_CFLAGS += -DJIT
#endif

#ifeq ($(USE_NEON), 1)
#  AM_CFLAGS += -DUSE_ARMNEON
#endif

DEFINES =   -DFPUEMU -DUNALIGNED_PROFITABLE -DAMAX -DAGA -DAUTOCONFIG -DFILESYS  -DFDI2RAW -DDEBUGGER -DSAVESTATE -DENFORCER -DACTION_REPLAY
#-DSCSIEMU -DSCSIEMU_LINUX_IOCTL -DUSE_SDL -DDRIVESOUND -DBSDSOCKET -DCDTV -DCD32  -DA2091 -DNCR  -DGAYLE


CM_CFLAGS =
CM_CFLAGS += @FREETYPE_CFLAGS@
# CM_CFLAGS += @GLEW_CFLAGS@
CM_CFLAGS += @GLIB_CFLAGS@
CM_CFLAGS += @LUA_CFLAGS@
CM_CFLAGS += @MIR_CFLAGS@
#CM_CFLAGS += @OPENAL_CFLAGS@
CM_CFLAGS += @OPENGL_CFLAGS@
# CM_CFLAGS += @OS_CFLAGS@
CM_CFLAGS += @PNG_CFLAGS@
#CM_CFLAGS += @QT_CFLAGS@
#CM_CFLAGS += @SDL2_CFLAGS@
# CM_CFLAGS += @X11_CFLAGS@
CM_CFLAGS += @ZLIB_CFLAGS@
CM_CFLAGS += $(WARNINGS)

if F_NO_STRICT_OVERFLOW
CM_CFLAGS += -fno-strict-overflow
endif
if F_NO_STRICT_ALIASING
CM_CFLAGS += -fno-strict-aliasing
endif
if W_MISSING_DECLARATIONS
CM_CFLAGS += -Wmissing-declarations
endif
if W_ADDRESS
CM_CFLAGS += -Waddress
endif
#if W_MISSING_FORMAT_ATTRIBUTE
#CM_CFLAGS += -Wmissing-format-attribute
#endif

CM_CFLAGS += -fvisibility=hidden

# TODO: Fix locating glib.h
CM_CFLAGS += -I/usr/include/glib-2.0

AM_CFLAGS =

AM_CXXFLAGS =

AM_CPPFLAGS =
AM_CPPFLAGS += @OS_CPPFLAGS@
AM_CPPFLAGS += -DUAE -DFSUAE $(DEFINES)

LIBS += @CARBON_LIBS@
LIBS += @FREETYPE_LIBS@
# LIBS += @GLEW_LIBS@
LIBS += @GLIB_LIBS@
LIBS += @IOKIT_LIBS@
# LIBS += @MIR_LIBS@
# LIBS += @OPENAL_LIBS@
# LIBS += @OPENGL_LIBS@
# LIBS += @OS_LIBS@
LIBS += @PNG_LIBS@
# LIBS += @QT_LIBS@
# LIBS += @SDL2_LIBS@
# LIBS += @X11_LIBS@
LIBS += @ZLIB_LIBS@

AM_LDFLAGS =
# AM_LDFLAGS += -rdynamic
AM_LDFLAGS += @OS_LDFLAGS@

if STATIC_BUILD
AM_LDFLAGS += -static
AM_CPPFLAGS += -DGLEW_STATIC
AM_CPPFLAGS += -DAL_LIBTYPE_STATIC
# Hack for OpenAL static missing libcommon.a
#LIBS += ../openal-soft/libcommon.a
# One or more .pc files are missing -liconv
LIBS += -liconv
endif

MSGFMT = @MSGFMT@
ZIP = @ZIP@

s = $(srcdir)
b = $(builddir)

bin_PROGRAMS = \
	fs-uae \
	fs-uae-device-helper

dist_doc_DATA = README COPYING

noinst_PROGRAMS = \
	gen/build68k \
	gen/genblitter \
	gen/gencomp \
	gen/gencpu \
	gen/genlinetoscr

noinst_LIBRARIES =

BUILT_SOURCES = \
	gen/linetoscr.c

# nodist_fs_uae_SOURCES =


if WINDOWS
# nodist_fs_uae_SOURCES += src/fs-uae/fs-uae.rc
.rc.o:
	windres $< -o $@ -I$(s)
endif

fs_uae_LDADD =

fs_uae_device_helper_SOURCES = \
	src/fs-uae/device-helper.c \
	src/fs-uae/paths.c

fs_uae_device_helper_LDADD =

noinst_LIBRARIES += libuae.a
AM_CPPFLAGS += -I$(s)/flac/include
AM_CPPFLAGS += -I$(b)/gen
AM_CPPFLAGS += -I$(s)/src
AM_CPPFLAGS += -I$(s)/src/jit
AM_CPPFLAGS += -I$(s)/src/include
AM_CPPFLAGS += -I$(s)/src/od-fs
AM_CPPFLAGS += -I$(s)/src/od-fs/include
AM_CPPFLAGS += -I$(s)/src/od-win32
AM_CPPFLAGS += -I$(s)/src/od-win32/caps
fs_uae_LDADD += libuae.a
# libuae_a_CXXFLAGS = $(CM_CFLAGS) -fpermissive
libuae_a_SOURCES =
nodist_libuae_a_SOURCES = \
	gen/blit.h \
	gen/blitfunc.c \
	gen/blitfunc.h \
	gen/blittable.c \
	gen/compemu.c \
	gen/compstbl.c \
	gen/comptbl.h \
	gen/cpudefs.c \
	gen/cpustbl.c \
	gen/cputbl.h
BUILT_SOURCES += $(nodist_libuae_a_SOURCES)

noinst_LIBRARIES += libcpuemu.a
fs_uae_LDADD += libcpuemu.a
nodist_libcpuemu_a_SOURCES = \
        gen/cpuemu_0.c \
        gen/cpuemu_11.c \
        gen/cpuemu_13.c \
        gen/cpuemu_20.c \
        gen/cpuemu_21.c \
        gen/cpuemu_22.c \
        gen/cpuemu_23.c \
        gen/cpuemu_24.c \
        gen/cpuemu_31.c \
        gen/cpuemu_32.c \
        gen/cpuemu_33.c \
        gen/cpuemu_40.c \
        gen/cpuemu_50.c
BUILT_SOURCES += $(nodist_libcpuemu_a_SOURCES)

noinst_LIBRARIES += libfsemu.a
AM_CPPFLAGS += -I$(s)/libfsemu/include
fs_uae_LDADD += libfsemu.a
fs_uae_device_helper_LDADD += libfsemu.a
libfsemu_a_SOURCES = 

if BUILTIN_CEF
AM_CPPFLAGS += -I$(s)/cef
fs_uae_LDADD += cef/libcef_dll/libcef_dll_wrapper.a -L $(s)/cef/Release -lcef
endif

#if BUILTIN_GLEE
#noinst_LIBRARIES += libglee.a
#AM_CPPFLAGS += -I$(s)/glee
#fs_uae_LDADD += libglee.a
#fs_uae_device_helper_LDADD += libglee.a
#libglee_a_SOURCES = \
#	glee/GLee.c \
#	glee/GLee.h
#endif


#if WITH_PEARPC_CPU
#noinst_LIBRARIES += libpearpc.a
#AM_CPPFLAGS += -I$(s)/src/ppc/pearpc
#fs_uae_LDADD += libpearpc.a
#libpearpc_a_SOURCES = \
#endif

#if WITH_PPC
# fs_uae_SOURCES += \
#	src/ppc/ppcd.c \
#	src/ppc/ppcd.h
#endif

#if WITH_SLIRP
#if WITH_BUILTIN_SLIRP
#noinst_LIBRARIES += libslirp.a
#AM_CPPFLAGS += -I$(s)/src/slirp/include
#fs_uae_LDADD += libslirp.a
#libslirp_a_SOURCES = \
#	src/slirp/bootp.c \
#	src/slirp/bootp.h \
#	src/slirp/cksum.c \
#	src/slirp/ctl.h \
#	src/slirp/debug.h \
#	src/slirp/icmp_var.h \
#	src/slirp/if.c \
#	src/slirp/if.h \
#	src/slirp/ip.h \
#	src/slirp/ip_icmp.c \
#	src/slirp/ip_icmp.h \
#	src/slirp/ip_input.c \
#	src/slirp/ip_output.c \
#	src/slirp/libslirp.h \
#	src/slirp/main.h \
#	src/slirp/mbuf.c \
#	src/slirp/mbuf.h \
#	src/slirp/misc.c \
#	src/slirp/misc.h \
#	src/slirp/sbuf.c \
#	src/slirp/sbuf.h \
#	src/slirp/slirp.c \
#	src/slirp/slirp.h \
#	src/slirp/slirp_config.h \
#	src/slirp/slirpdebug.c \
#	src/slirp/socket.c \
#	src/slirp/socket.h \
#	src/slirp/tcp.h \
#	src/slirp/tcp_input.c \
#	src/slirp/tcp_output.c \
#	src/slirp/tcp_subr.c \
#	src/slirp/tcp_timer.c \
#	src/slirp/tcp_timer.h \
#	src/slirp/tcp_var.h \
#	src/slirp/tcpip.h \
#	src/slirp/tftp.c \
#	src/slirp/tftp.h \
#	src/slirp/udp.c \
#	src/slirp/udp.h
#endif
#endif

if WITH_TOCCATA
# fs_uae_SOURCES += \	src/sndboard.c
endif

if PROWIZARD
noinst_LIBRARIES += libprowizard.a
AM_CPPFLAGS += -I$(s)/prowizard/include
fs_uae_LDADD += libprowizard.a
#fs_uae_SOURCES += src/moduleripper.c
#libprowizard_a_SOURCES = 
endif

if WITH_SOFTFLOAT
noinst_LIBRARIES += libsoftfloat.a
AM_CPPFLAGS += -I$(s)/softfloat
fs_uae_LDADD += libsoftfloat.a
libsoftfloat_a_SOURCES = \
	softfloat/softfloat-uae.h \
	softfloat/fprem.cc \
	softfloat/fpu_constant.h \
	softfloat/fsincos.cc \
	softfloat/poly.cc \
	softfloat/softfloat16.cc \
	softfloat/softfloat.cc \
	softfloat/softfloat-compare.h \
	softfloat/softfloat.h \
	softfloat/softfloat-macros.h \
	softfloat/softfloat-muladd.cc \
	softfloat/softfloat-round-pack.cc \
	softfloat/softfloat-round-pack.h \
	softfloat/softfloat-specialize.cc \
	softfloat/softfloat-specialize.h \
	softfloat/softfloatx80.cc \
	softfloat/softfloatx80.h
endif

#if BUILTIN_LIBMPEG2
# SUBDIRS += libmpeg2
#AM_CPPFLAGS += -I$(s)/libmpeg2/include
# fs_uae_LDADD += \
#	libmpeg2/libmpeg2/.libs/libmpeg2.a \
#	libmpeg2/libmpeg2/convert/.libs/libmpeg2convert.a
#else
#CM_CFLAGS += @LIBMPEG2_CFLAGS@
#LIBS += @LIBMPEG2_LIBS@
#endif

noinst_LIBRARIES += libdummy.a
nodist_libdummy_a_SOURCES = \
	gen/cdummy.c \
	gen/cppdummy.c
BUILT_SOURCES += $(nodist_libdummy_a_SOURCES)

gen/cdummy.c:
	echo "int cdummy;" > $(b)/gen/cdummy.c

gen/cppdummy.c:
	echo "int cppdummy;" > $(b)/gen/cppdummy.c

gen_build68k_SOURCES = \
	src/build68k.c \
	src/writelog.c

gen_genblitter_SOURCES = \
	src/blitops.c \
	src/genblitter.c \
	src/writelog.c

gen_gencomp_SOURCES = \
	src/jit/gencomp.c \
	src/missing.c \
	src/readcpu.c \
	src/writelog.c

nodist_gen_gencomp_SOURCES = \
	gen/cpudefs.c

gen_gencpu_SOURCES = \
	src/gencpu.c \
	src/missing.c \
	src/readcpu.c

nodist_gen_gencpu_SOURCES = \
	gen/cpudefs.c

gen_genlinetoscr_SOURCES = \
	src/genlinetoscr.c

TESTS = \
	tests/dummy-test

EXTRA_TESTS = \
	tests/cppcheck-fs-uae \
	tests/cppcheck-libfsemu \
	tests/cppcheck-libmpeg2 \
	tests/cppcheck-lua \
	tests/cppcheck-manymouse \
	tests/cppcheck-od-fs \
	tests/cppcheck-pearpc \
	tests/cppcheck-ppc \
	tests/cppcheck-slirp \
	tests/cppcheck-uae

EXTRA_DIST = $(TESTS) $(EXTRA_TESTS) \
	debian/changelog \
	debian/compat \
	debian/control \
	debian/copyright \
	debian/rules \
	debian/source \
	debian/source/format \
	dist/linux/build.py \
	dist/arch.py \
	dist/linux/standalone.py \
	dist/macosx/fs-uae-config.icns \
	dist/macosx/fs-uae.icns \
	dist/macosx/PkgInfo \
	dist/macosx/sign.py \
	dist/macosx/standalone.py \
	dist/windows/clib.py \
	dist/windows/iscc.py \
	dist/windows/sign.py \
	flac/include/FLAC/all.h \
	flac/include/FLAC/assert.h \
	flac/include/FLAC/callback.h \
	flac/include/FLAC/export.h \
	flac/include/FLAC/format.h \
	flac/include/FLAC/metadata.h \
	flac/include/FLAC/ordinals.h \
	flac/include/FLAC/stream_decoder.h \
	flac/include/FLAC/stream_encoder.h \
	fs-uae.spec \
	icon/fs-uae.ico \
	libinih/ini.c \
	libinih/ini.h \
	libinih/LICENSE.txt \
	libudis86/README \
	licenses/fs-uae.txt \
	licenses/glib.txt \
	licenses/ipflib.txt \
	licenses/libgcc.txt \
	licenses/libintl.txt \
	licenses/libpng.txt \
	licenses/libstdc++.txt \
	licenses/lua.txt \
	licenses/zlib.txt \
	po \
	src/filesys_bootrom.c \
	src/fs-uae/fs-uae.rc.in \
	src/inputevents.def \
	src/jit/codegen_x86.c \
	src/jit/compemu_midfunc_x86.c \
	src/jit/compemu_prefs.c \
	src/jit/exception_handler.c \
	src/mame/tm34010/34010fld.c \
	src/mame/tm34010/34010tbl.c \
	src/mame/tm34010/34010ops.c \
	src/mame/tm34010/34010ops.h \
	src/mame/tm34010/34010gfx.c \
	src/od-fs/bsdsocket_posix.c \
	src/od-win32/bsdsock.c \
        src/od-win32/mman.c \
	src/p96_blit.c \
	src/sinctable.c \
	src/table68k \
	share/applications \
	share/fs-uae \
	share/icons \
	share/mime

CLEANFILES = $(BUILT_SOURCES)

#if CODEGEN

gen/blit.h: gen/genblitter$(EXEEXT)
	$(b)/gen/genblitter$(EXEEXT) i > $(b)/gen/blit.h

gen/blitfunc.c: gen/genblitter$(EXEEXT) gen/blitfunc.h
	$(b)/gen/genblitter$(EXEEXT) f > $(b)/gen/blitfunc.c

gen/blitfunc.h: gen/genblitter$(EXEEXT)
	$(b)/gen/genblitter$(EXEEXT) h > $(b)/gen/blitfunc.h

gen/blittable.c: gen/genblitter$(EXEEXT) gen/blitfunc.h
	$(b)/gen/genblitter$(EXEEXT) t > $(b)/gen/blittable.c

gen/compemu.c: gen/gencomp$(EXEEXT)
	$(b)/gen/gencomp$(EXEEXT)

gen/compstbl.c: gen/compemu.c

gen/comptbl.h: gen/compemu.c

gen/cpudefs.c: gen/build68k$(EXEEXT) src/table68k
	$(b)/gen/build68k$(EXEEXT) < $(s)/src/table68k > $(b)/gen/cpudefs.c

gen/cpuemu_0.c: gen/gencpu$(EXEEXT)
	cd $(b)/gen && ./gencpu$(EXEEXT) --optimized-flags

gen/cpuemu_11.c: gen/cpuemu_0.c

gen/cpuemu_13.c: gen/cpuemu_0.c

gen/cpuemu_20.c: gen/cpuemu_0.c

gen/cpuemu_21.c: gen/cpuemu_0.c

gen/cpuemu_22.c: gen/cpuemu_0.c

gen/cpuemu_23.c: gen/cpuemu_0.c

gen/cpuemu_24.c: gen/cpuemu_0.c

gen/cpuemu_31.c: gen/cpuemu_0.c

gen/cpuemu_32.c: gen/cpuemu_0.c

gen/cpuemu_33.c: gen/cpuemu_0.c

gen/cpuemu_40.c: gen/cpuemu_0.c

gen/cpuemu_50.c: gen/cpuemu_0.c

gen/cpustbl.c: gen/cpuemu_0.c

gen/cputbl.h: gen/cpuemu_0.c

gen/linetoscr.c: gen/genlinetoscr$(EXEEXT)
	$(b)/gen/genlinetoscr$(EXEEXT) > $(b)/gen/linetoscr.c

#endif

catalogs = \
	share/locale/cs/LC_MESSAGES/fs-uae.mo \
	share/locale/da/LC_MESSAGES/fs-uae.mo \
	share/locale/de/LC_MESSAGES/fs-uae.mo \
	share/locale/eo/LC_MESSAGES/fs-uae.mo \
	share/locale/es/LC_MESSAGES/fs-uae.mo \
	share/locale/fi/LC_MESSAGES/fs-uae.mo \
	share/locale/fr/LC_MESSAGES/fs-uae.mo \
	share/locale/hu/LC_MESSAGES/fs-uae.mo \
	share/locale/it/LC_MESSAGES/fs-uae.mo \
	share/locale/nb/LC_MESSAGES/fs-uae.mo \
	share/locale/nl/LC_MESSAGES/fs-uae.mo \
	share/locale/pl/LC_MESSAGES/fs-uae.mo \
	share/locale/pt/LC_MESSAGES/fs-uae.mo \
	share/locale/pt_BR/LC_MESSAGES/fs-uae.mo \
	share/locale/sr/LC_MESSAGES/fs-uae.mo \
	share/locale/sv/LC_MESSAGES/fs-uae.mo \
	share/locale/tr/LC_MESSAGES/fs-uae.mo

share/locale/cs/LC_MESSAGES/fs-uae.mo: po/cs.po
	mkdir -p share/locale/cs/LC_MESSAGES
	$(MSGFMT) --verbose $(s)/po/cs.po -o $@

share/locale/da/LC_MESSAGES/fs-uae.mo: po/da.po
	mkdir -p share/locale/da/LC_MESSAGES
	$(MSGFMT) --verbose $(s)/po/da.po -o $@

share/locale/de/LC_MESSAGES/fs-uae.mo: po/de.po
	mkdir -p share/locale/de/LC_MESSAGES
	$(MSGFMT) --verbose $(s)/po/de.po -o $@

share/locale/eo/LC_MESSAGES/fs-uae.mo: po/eo.po
	mkdir -p share/locale/eo/LC_MESSAGES
	$(MSGFMT) --verbose $(s)/po/eo.po -o $@

share/locale/es/LC_MESSAGES/fs-uae.mo: po/es.po
	mkdir -p share/locale/es/LC_MESSAGES
	$(MSGFMT) --verbose $(s)/po/es.po -o $@

share/locale/fi/LC_MESSAGES/fs-uae.mo: po/fi.po
	mkdir -p share/locale/fi/LC_MESSAGES
	$(MSGFMT) --verbose $(s)/po/fi.po -o $@

share/locale/fr/LC_MESSAGES/fs-uae.mo: po/fr.po
	mkdir -p share/locale/fr/LC_MESSAGES
	$(MSGFMT) --verbose $(s)/po/fr.po -o $@

share/locale/hu/LC_MESSAGES/fs-uae.mo: po/hu.po
	mkdir -p share/locale/hu/LC_MESSAGES
	$(MSGFMT) --verbose $(s)/po/hu.po -o $@

share/locale/it/LC_MESSAGES/fs-uae.mo: po/it.po
	mkdir -p share/locale/it/LC_MESSAGES
	$(MSGFMT) --verbose $(s)/po/it.po -o $@

share/locale/nb/LC_MESSAGES/fs-uae.mo: po/nb.po
	mkdir -p share/locale/nb/LC_MESSAGES
	$(MSGFMT) --verbose $(s)/po/nb.po -o $@

share/locale/nl/LC_MESSAGES/fs-uae.mo: po/nl.po
	mkdir -p share/locale/nl/LC_MESSAGES
	$(MSGFMT) --verbose $(s)/po/nl.po -o $@

share/locale/pl/LC_MESSAGES/fs-uae.mo: po/pl.po
	mkdir -p share/locale/pl/LC_MESSAGES
	$(MSGFMT) --verbose $(s)/po/pl.po -o $@

share/locale/pt/LC_MESSAGES/fs-uae.mo: po/pt.po
	mkdir -p share/locale/pt/LC_MESSAGES
	$(MSGFMT) --verbose $(s)/po/pt.po -o $@

share/locale/pt_BR/LC_MESSAGES/fs-uae.mo: po/pt_BR.po
	mkdir -p share/locale/pt_BR/LC_MESSAGES
	$(MSGFMT) --verbose $(s)/po/pt_BR.po -o $@

share/locale/sr/LC_MESSAGES/fs-uae.mo: po/sr.po
	mkdir -p share/locale/sr/LC_MESSAGES
	$(MSGFMT) --verbose $(s)/po/sr.po -o $@

share/locale/sv/LC_MESSAGES/fs-uae.mo: po/sv.po
	mkdir -p share/locale/sv/LC_MESSAGES
	$(MSGFMT) --verbose $(s)/po/sv.po -o $@

share/locale/tr/LC_MESSAGES/fs-uae.mo: po/tr.po
	mkdir -p share/locale/tr/LC_MESSAGES
	$(MSGFMT) --verbose $(s)/po/tr.po -o $@

mo: $(catalogs)

fs-uae.dat: $(catalogs)
	rm -f fs-uae.dat
	cd $(s) && $(ZIP) -r $(abs_builddir)/fs-uae.dat share
	cd $(b) && $(ZIP) -r $(abs_builddir)/fs-uae.dat share

all-local: mo fs-uae.dat

install-data-hook: mo fs-uae.dat
	chmod -R u+w $(s)/share/
	mkdir -p $(DESTDIR)$(datadir)/applications
	cp -R $(s)/share/applications/* $(DESTDIR)$(datadir)/applications
	mkdir -p $(DESTDIR)$(datadir)/fs-uae
	cp -R $(s)/share/fs-uae/* $(DESTDIR)$(datadir)/fs-uae
	mkdir -p $(DESTDIR)$(datadir)/icons
	cp -R $(s)/share/icons/* $(DESTDIR)$(datadir)/icons
	mkdir -p $(DESTDIR)$(datadir)/locale
	cp -R $(b)/share/locale/* $(DESTDIR)$(datadir)/locale
	mkdir -p $(DESTDIR)$(datadir)/mime
	cp -R $(s)/share/mime/* $(DESTDIR)$(datadir)/mime
	cp fs-uae.dat $(DESTDIR)$(datadir)/fs-uae

uninstall-local:
	rm -f $(DESTDIR)$(datadir)/applications/fs-uae.desktop
	rm -Rf $(DESTDIR)$(datadir)/fs-uae
	find $(DESTDIR)$(datadir)/icons/hicolor -name fs-uae.png -delete
	find $(DESTDIR)$(datadir)/locale -name fs-uae.mo -delete
	rm -f $(DESTDIR)$(datadir)/mime/packages/fs-uae.xml

clean-local:
	rm -f fs-uae.dat
	find share -name fs-uae.mo -delete

fs-uae-dist:
	$(MAKE) -C dist/@OS_NAME@

standalone: fs-uae$(EXEEXT) fs-uae.dat
	@echo "Stripping fs-uae$(EXEEXT)"
	strip fs-uae$(EXEEXT)
	@echo "Appending fs-uae.dat"
	cat fs-uae.dat >> fs-uae$(EXEEXT)
	@echo "Correcting zip offsets"
	zip -A fs-uae$(EXEEXT)
