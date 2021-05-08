ARCHS = armv7 arm64

include $(THEOS)/makefiles/common.mk

XCODEPROJ_NAME = OCRuntime

OCRuntime_XCODEFLAGS = THEOS_FLAG=-DTHEOS
OCRuntime_CODESIGN_FLAGS = -Sentitlements.plist

include $(THEOS_MAKE_PATH)/xcodeproj.mk
