include $(THEOS)/makefiles/common.mk

TWEAK_NAME = tgCid
tgCid_FILES = CallManager.m ConstrictedUILabel.m Hooks.m ImageLabel.m IncomingCallView.m UIView-Center.m

tgCid_FRAMEWORKS = CoreGraphics CoreTelephony UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
include $(THEOS_MAKE_PATH)/package.mk
