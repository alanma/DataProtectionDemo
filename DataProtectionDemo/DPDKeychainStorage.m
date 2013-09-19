//
//  DPDKeychainStorage.m
//  DataProtectionDemo
//
//  Created by Erik Romijn on 9/19/13.
//  Copyright (c) 2013 Solid Links. All rights reserved.
//

#import "DPDKeychainStorage.h"

// Note that "always" in keychain means "always available".
NSString *const keychainAccountAlways = @"demo-always";
NSString *const keychainAccountAfterFirstUnlock = @"demo-afterfirstunlock";
NSString *const keychainAccountWhenUnlocked = @"demo-whenunlocked";


@implementation DPDKeychainStorage

- (void)storeAllKeychainData:(NSData *)data {
    [self storeKeychainItem:data
                    account:keychainAccountAlways
              accessibility:kSecAttrAccessibleAlways];
    [self storeKeychainItem:data
                    account:keychainAccountAfterFirstUnlock
              accessibility:kSecAttrAccessibleAfterFirstUnlock];
    [self storeKeychainItem:data
                    account:keychainAccountWhenUnlocked
              accessibility:kSecAttrAccessibleWhenUnlocked];
}


- (NSArray *)retrieveAllKeychainData {
    NSMutableArray *result = [NSMutableArray array];
    [result addObject:[self retrieveKeychainItem:keychainAccountAlways]];
    [result addObject:[self retrieveKeychainItem:keychainAccountAfterFirstUnlock]];
    [result addObject:[self retrieveKeychainItem:keychainAccountWhenUnlocked]];
    return result;
}


- (void)storeKeychainItem:(NSData *)data account:(NSString *)account accessibility:(CFTypeRef)accessibility {
    // Note that metadata, like the account name, is not encrypted.
    NSDictionary *item = @{
        (__bridge id)kSecAttrAccount: account,
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrAccessible: (__bridge id)accessibility,
        (__bridge id)kSecValueData: data,
    };
    
    OSStatus error = SecItemAdd((__bridge CFDictionaryRef)item, NULL);
    if(error) {
        NSLog(@"Failed to create Keychain item for %@: %d", account, (int)error);
    } else {
        NSLog(@"Created Keychain item for %@", account);
    }
}


- (NSData *)retrieveKeychainItem:(NSString *)account {
    NSDictionary *query = @{
                            (__bridge id)kSecAttrAccount: account,
                            (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
                            (__bridge id)kSecReturnData: (__bridge id)kCFBooleanTrue,
                          };
    

    CFDataRef result = NULL;
    OSStatus error = SecItemCopyMatching((__bridge CFDictionaryRef)query, (CFTypeRef *)&result);
    if(error) {
        NSLog(@"Failed to create Keychain item for %@: %d", account, (int)error);
        return [NSData data];
    } else {
        NSLog(@"Retrieved Keychain item for %@", account);
    }
    return (__bridge NSData *)result;
}

@end
