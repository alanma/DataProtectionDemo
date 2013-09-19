//
//  DPDKeychainStorage.h
//  DataProtectionDemo
//
//  Created by Erik Romijn on 9/19/13.
//  Copyright (c) 2013 Solid Links. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/SecItem.h>

@interface DPDKeychainStorage : NSObject

- (void)storeAllKeychainData:(NSData *)data;
- (NSArray *)retrieveAllKeychainData;

@end
