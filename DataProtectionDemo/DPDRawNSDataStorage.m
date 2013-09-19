//
//  DPDRawNSDataStorage.m
//  DataProtectionDemo
//
//  Created by Erik Romijn on 9/19/13.
//  Copyright (c) 2013 Solid Links. All rights reserved.
//

#import "DPDRawNSDataStorage.h"

NSString *const dataFilenameNone = @"demo-nsdata-none.txt";
NSString *const dataFilenameFirstAuthentication = @"demo-nsdata-firstauthentication.txt";
NSString *const dataFilenameComplete = @"demo-nsdata-complete.txt";

@implementation DPDRawNSDataStorage

- (void)storeNSData:(NSData *)data {
    [self saveNSData:data
            filename:dataFilenameNone
       accessibility:NSDataWritingFileProtectionNone];
    [self saveNSData:data
            filename:dataFilenameFirstAuthentication
       accessibility:NSDataWritingFileProtectionCompleteUntilFirstUserAuthentication];
    [self saveNSData:data
            filename:dataFilenameComplete
       accessibility:NSDataWritingFileProtectionComplete];
}


- (NSArray *)retrieveNSData {
    NSMutableArray *result = [NSMutableArray array];
    [result addObject:[self loadNSData:dataFilenameNone]];
    [result addObject:[self loadNSData:dataFilenameFirstAuthentication]];
    [result addObject:[self loadNSData:dataFilenameComplete]];
    return result;
}


- (void)saveNSData:(NSData *)data filename:(NSString *)filename accessibility:(NSDataWritingOptions)accessibility {
    NSError *error;
    NSString *filepath = [self pathForFilename:filename];
    
    if([data writeToFile:filepath options:accessibility error:&error]) {
        NSLog(@"Wrote NSData to %@", filename);
    } else {
        NSLog(@"Failed to write NSData to %@", filename);
    }
}

- (NSData *)loadNSData:(NSString *)filename {
    NSError *error;
    NSData *result = [NSData dataWithContentsOfFile:[self pathForFilename:filename] options:0 error:&error];
    if (!result) {
        NSLog(@"Failed to read NSData from %@: %@", filename, error);
        return [NSData data];
    }
    return result;
}

- (NSString *)pathForFilename:(NSString *)filename {
    NSString *docsDir;
    NSArray *dirPaths;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    return [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:filename]];
}

@end
