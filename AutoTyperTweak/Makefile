TARGET := iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = AutoTyper

AutoTyper_FILES = Tweak.x ATConfigViewController.m ATTypingManager.m
AutoTyper_CFLAGS = -fobjc-arc
AutoTyper_FRAMEWORKS = UIKit CoreGraphics QuartzCore AudioToolbox
AutoTyper_PRIVATE_FRAMEWORKS = UIKitCore

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
