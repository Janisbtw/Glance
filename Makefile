export TARGET := iphone:clang:16.5:14.0
export ARCHS = arm64 arm64e
INSTALL_TARGET_PROCESSES = SpringBoard Preferences

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Glance

Glance_FILES = $(shell find Sources/Glance -name '*.swift') $(shell find Sources/GlanceC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
Glance_SWIFTFLAGS = -ISources/GlanceC/include
Glance_CFLAGS = -fobjc-arc -ISources/GlanceC/include -Wno-nullability-completeness
Glance_FRAMEWORKS += SpringBoard SpringBoardHome SpringBoardFoundation CoreServices Focus DoNotDisturb AppSupport BulletinBoard UserNotificationsUIKit
Glance_EXTRA_FRAMEWORKS += AltList

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += glanceprefs
include $(THEOS_MAKE_PATH)/aggregate.mk