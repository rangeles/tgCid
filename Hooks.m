#import <CaptainHook/CaptainHook.h>
#import "MPIncomingPhoneCallController.h"
#import "CallManager.h"

static CallManager *manager;

CHDeclareClass(MPIncomingPhoneCallController);

CHOptimizedMethod(1, self, id, MPIncomingPhoneCallController, initWithCall, CTCallRef, call) {
    id orig = CHSuper(1, MPIncomingPhoneCallController, initWithCall, call);
    [manager setupForController:orig withCall:call];
    return orig;
}

CHOptimizedMethod(0, self, void, MPIncomingPhoneCallController, dealloc) {
    [manager teardownForController:self];
    CHSuper(0, MPIncomingPhoneCallController, dealloc);
}

CHOptimizedMethod(0, self, UIView *, MPIncomingPhoneCallController, newTopBar) {
    UIView *orig = CHSuper(0, MPIncomingPhoneCallController, newTopBar);
    [manager setForController:self ABUID:[self incomingCallerABUID]];
    [orig addSubview:[manager viewForController:self]];
    return orig;
}

CHOptimizedMethod(3, self, void, MPIncomingPhoneCallController, updateLCDWithName, NSString *, name, label, NSString *, aLabel, breakPoint, unsigned, aBreakPoint) {
    if ([manager hasViewForController:self]) {
        aLabel = @" ";
    }
    CHSuper(3, MPIncomingPhoneCallController, updateLCDWithName, name, label, aLabel, breakPoint, aBreakPoint);
}

CHDeclareClass(SBPluginManager);

CHOptimizedMethod(1, self, Class, SBPluginManager, loadPluginBundle, NSBundle *, bundle) {
    id ret = CHSuper(1, SBPluginManager, loadPluginBundle, bundle);

    if ([[bundle bundleIdentifier] isEqualToString:@"com.apple.mobilephone.incomingcall"] && [bundle isLoaded]) {
        CHLoadLateClass(MPIncomingPhoneCallController);
        CHHook(1, MPIncomingPhoneCallController, initWithCall);
        CHHook(0, MPIncomingPhoneCallController, dealloc);
        CHHook(0, MPIncomingPhoneCallController, newTopBar);
        CHHook(3, MPIncomingPhoneCallController, updateLCDWithName, label, breakPoint);
    }

    return ret;
}

CHConstructor {
    manager = [[CallManager alloc] init];

    CHLoadLateClass(SBPluginManager);
    CHHook(1, SBPluginManager, loadPluginBundle);
}
