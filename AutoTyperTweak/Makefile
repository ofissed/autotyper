ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:15.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AutoTyper

AutoTyper_FILES = Tweak.x ATConfigViewController.m ATTypingManager.m
AutoTyper_CFLAGS = -fobjc-arc -Wno-deprecated-declarations
AutoTyper_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
