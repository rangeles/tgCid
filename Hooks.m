#import <CaptainHook/CaptainHook.h>
#import "MPIncomingPhoneCallController.h"
#import "CallManager.h"

CHDeclareClass(MPIncomingPhoneCallController);

CHOptimizedMethod(1, self, id, MPIncomingPhoneCallController, initWithCall, CTCallRef, call) {
    id orig = CHSuper(1, MPIncomingPhoneCallController, initWithCall, call);
    [[CallManager sharedManager] setupForController:orig withCall:call];
    return orig;
}

CHOptimizedMethod(0, self, void, MPIncomingPhoneCallController, dealloc) {
    [[CallManager sharedManager] teardownForController:self];
    CHSuper(0, MPIncomingPhoneCallController, dealloc);
}

CHOptimizedMethod(0, self, UIView *, MPIncomingPhoneCallController, newTopBar) {
    UIView *orig = CHSuper(0, MPIncomingPhoneCallController, newTopBar);
    [[CallManager sharedManager] setForController:self ABUID:[self incomingCallerABUID]];
    [orig addSubview:[[CallManager sharedManager] viewForController:self]];
    return orig;
}

CHOptimizedMethod(3, self, void, MPIncomingPhoneCallController, updateLCDWithName, NSString *, name, label, NSString *, aLabel, breakPoint, unsigned, aBreakPoint) {
    if ([[CallManager sharedManager] hasViewForController:self]) {
        aLabel = @" ";
    }
    CHSuper(3, MPIncomingPhoneCallController, updateLCDWithName, name, label, aLabel, breakPoint, aBreakPoint);
}

CHDeclareClass(SBPluginManager);

CHOptimizedMethod(1, self, Class, SBPluginManager, loadPluginBundle, NSBundle *, bundle) {
    id orig = CHSuper(1, SBPluginManager, loadPluginBundle, bundle);

    if ([[bundle bundleIdentifier] isEqualToString:@"com.apple.mobilephone.incomingcall"] && [bundle isLoaded]) {
        CHLoadLateClass(MPIncomingPhoneCallController);
        CHHook(1, MPIncomingPhoneCallController, initWithCall);
        CHHook(0, MPIncomingPhoneCallController, dealloc);
        CHHook(0, MPIncomingPhoneCallController, newTopBar);
        CHHook(3, MPIncomingPhoneCallController, updateLCDWithName, label, breakPoint);
    }

    return orig;
}

CHConstructor {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [CallManager sharedManager];

    CHLoadLateClass(SBPluginManager);
    CHHook(1, SBPluginManager, loadPluginBundle);

    [pool drain];
}
