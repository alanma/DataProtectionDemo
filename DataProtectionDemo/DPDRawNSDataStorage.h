//
//  DPDRawNSDataStorage.h
//  DataProtectionDemo
//
//  Created by Erik Romijn on 9/19/13.
//  Copyright (c) 2013 Solid Links. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPDRawNSDataStorage : NSObject

- (void)storeNSData:(NSData *)data;
- (NSArray *)retrieveNSData;

@end
