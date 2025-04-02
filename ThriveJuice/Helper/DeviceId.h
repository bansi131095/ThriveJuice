//
//  DeviceId.h
//  yanntaxi
//
//  Created by IOS-Developer-1 on 13/06/18.
//  Copyright © 2018 IOS-Developer-1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceId : NSObject

+ (NSString *)GetDeviceID ;

+(void) setObject:(NSString*) object forKey:(NSString*) key;

+(NSString*) objectForKey:(NSString*) key;

@end
