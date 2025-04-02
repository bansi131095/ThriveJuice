//
//  DeviceId.m
//  yanntaxi
//
//  Created by IOS-Developer-1 on 13/06/18.
//  Copyright © 2018 IOS-Developer-1. All rights reserved.
//

#import "DeviceId.h"
#import "SFHFKeychainUtils.h"

@implementation DeviceId

+ (NSString *)GetDeviceID {
    NSString *udidString;
    udidString = [self objectForKey:@"deviceID"];
    if(!udidString)
    {
        CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
        udidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
        CFRelease(cfuuid);
        [self setObject:udidString forKey:@"deviceID"];
    }
    return udidString;
}

+(void) setObject:(NSString*) object forKey:(NSString*) key
{
    NSString *objectString = object;
    NSError *error = nil;
    [SFHFKeychainUtils storeUsername:key
                         andPassword:objectString
                      forServiceName:@"LIB"
                      updateExisting:YES
                               error:&error];
    
    if(error)
        NSLog(@"%@", [error localizedDescription]);
}

+(NSString*) objectForKey:(NSString*) key
{
    NSError *error = nil;
    NSString *object = [SFHFKeychainUtils getPasswordForUsernameV2:key
                                                  andServiceName:@"LIB"
                                                           error:&error];
    if(error)
        NSLog(@"%@", [error localizedDescription]);
    
    return object;
}

@end
