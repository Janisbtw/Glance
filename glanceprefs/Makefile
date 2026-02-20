ARCHS = arm64 arm64e
TARGET := iphone:clang:16.5:14.0

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = glanceprefs

glanceprefs_FILES = $(shell find Sources/glanceprefs -name '*.swift') $(shell find Sources/glanceprefsC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
glanceprefs_SWIFTFLAGS = -ISources/glanceprefsC/include
glanceprefs_CFLAGS = -fobjc-arc
glanceprefs_FRAMEWORKS = SwiftUI AppSupport
glanceprefs_INSTALL_PATH = /Library/PreferenceBundles

include $(THEOS_MAKE_PATH)/bundle.mk
