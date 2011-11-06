#import <CaptainHook/CaptainHook.h>
#import "MPIncomingPhoneCallController.h"
#import "CallManager.h"

static CallManager *manager;

CHDeclareClass(MPIncomingPhoneCallController);

CHOptimizedMethod(1, self, id, MPIncomingPhoneCallController, initWithCall, CTCallRef, call) {
    NSLog(@"-[<MPIncomingPhoneCallController: %p> initWithCall:%@]", self, call);
    id ret = CHSuper(1, MPIncomingPhoneCallController, initWithCall, call);
    [manager setupForController:ret withCall:call];
    return ret;
}

CHOptimizedMethod(1, self, void, MPIncomingPhoneCallController, answerCall, CTCallRef, call) {
    NSLog(@"-[<MPIncomingPhoneCallController: %p> answerCall:%@]", self, call);
    [manager teardownForController:self];
    CHSuper(1, MPIncomingPhoneCallController, answerCall, call);
}

CHOptimizedMethod(0, self, UIView *, MPIncomingPhoneCallController, newTopBar) {
    NSLog(@"-[<MPIncomingPhoneCallController: %p> newTopBar]", self);
    UIView *ret = CHSuper(0, MPIncomingPhoneCallController, newTopBar);
    NSLog(@"%@", [manager viewForController:self]);
    [ret addSubview:[manager viewForController:self]];
    return ret;
}

CHOptimizedMethod(3, self, void, MPIncomingPhoneCallController, updateLCDWithName, id, name, label, id, _label, breakPoint, id, bp) {
    NSLog(@"-[<MPIncomingPhoneCallController: %p> updateLCDWithName:%@ label:%@ breakPoint:%@]", self, name, _label, bp);
    [manager setForController:self ABUID:[self incomingCallerABUID]];
    if ([manager hasViewForController:self]) {
        _label = @" ";
    }
    CHSuper(3, MPIncomingPhoneCallController, updateLCDWithName, name, label, _label, breakPoint, bp);
}

CHOptimizedMethod(0, self, void, MPIncomingPhoneCallController, ignore) {
    NSLog(@"-[<MPIncomingPhoneCallController: %p> ignore]", self);
    [manager teardownForController:self];
    CHSuper(0, MPIncomingPhoneCallController, ignore);
}

CHDeclareClass(MPPhoneCallWaitingController);

CHOptimizedMethod(0, self, void, MPPhoneCallWaitingController, ignore) {
    NSLog(@"-[<MPPhoneCallWaitingController: %p> ignore]", self);
    [manager teardownForController:self];
    CHSuper(0, MPPhoneCallWaitingController, ignore);
}

CHOptimizedMethod(1, self, void, MPPhoneCallWaitingController, answerCall, CTCallRef, call) {
    NSLog(@"-[<MPPhoneCallWaitingController: %p> answerCall:%@]", self, call);
    [manager teardownForController:self];
    CHSuper(1, MPPhoneCallWaitingController, answerCall, call);
}

CHDeclareClass(SBPluginManager);

CHOptimizedMethod(1, self, Class, SBPluginManager, loadPluginBundle, NSBundle *, bundle) {
    id ret = CHSuper(1, SBPluginManager, loadPluginBundle, bundle);

    if ([[bundle bundleIdentifier] isEqualToString:@"com.apple.mobilephone.incomingcall"] && [bundle isLoaded]) {
        CHLoadLateClass(MPIncomingPhoneCallController);
        CHHook(1, MPIncomingPhoneCallController, initWithCall);
        CHHook(1, MPIncomingPhoneCallController, answerCall);
        CHHook(0, MPIncomingPhoneCallController, newTopBar);
        CHHook(3, MPIncomingPhoneCallController, updateLCDWithName, label, breakPoint);
        CHHook(0, MPIncomingPhoneCallController, ignore);

        CHLoadLateClass(MPPhoneCallWaitingController);
        CHHook(1, MPPhoneCallWaitingController, answerCall);
        CHHook(0, MPPhoneCallWaitingController, ignore);
    }

    return ret;
}

CHConstructor {
    manager = [[CallManager alloc] init];

    CHLoadLateClass(SBPluginManager);
    CHHook(1, SBPluginManager, loadPluginBundle);
}
