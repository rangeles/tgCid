#ifndef __CFCoreTelephony__ 
#define __CFCoreTelephony__

#ifdef __cplusplus
extern "C" {
#endif

    // The typedef may need to be removed if you include SpringBoard headers
    typedef struct __CTCall* CTCallRef;

    extern NSString *CTCallCopyAddress(CFAllocatorRef, CTCallRef);
    extern NSString *CTCallCopyCountryCode(CFAllocatorRef, CTCallRef);
    extern NSString *CTCallCopyName(CFAllocatorRef, CTCallRef);
    extern CFUUIDRef CTCallCopyUUID(CFAllocatorRef, CTCallRef);
    extern int CTCallGetStatus(CTCallRef);

#ifdef __cplusplus
}
#endif

#endif
