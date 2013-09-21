//
//  DPDRawNSDataStorage.m
//  DataProtectionDemo
//
//  Created by Erik Romijn on 9/19/13.
//  Copyright (c) 2013 Solid Links. All rights reserved.
//

#import "DPDRawNSDataStorage.h"

NSString *const dataFilenameDefault = @"demo-nsdata-default.txt";
NSString *const dataFilenameNone = @"demo-nsdata-none.txt";
NSString *const dataFilenameFirstAuthentication = @"demo-nsdata-firstauthentication.txt";
NSString *const dataFilenameComplete = @"demo-nsdata-complete.txt";


@implementation DPDRawNSDataStorage

- (void)storeAllNSData:(NSData *)data {
    [self saveNSDataItem:data
                filename:dataFilenameDefault
           accessibility:0];
    [self saveNSDataItem:data
                filename:dataFilenameNone
           accessibility:NSDataWritingFileProtectionNone];
    [self saveNSDataItem:data
                filename:dataFilenameFirstAuthentication
           accessibility:NSDataWritingFileProtectionCompleteUntilFirstUserAuthentication];
    [self saveNSDataItem:data
                filename:dataFilenameComplete
           accessibility:NSDataWritingFileProtectionComplete];
}


- (NSArray *)retrieveAllNSData {
    NSMutableArray *result = [NSMutableArray array];
    [result addObject:[self loadNSDataItem:dataFilenameDefault]];
    [result addObject:[self loadNSDataItem:dataFilenameNone]];
    [result addObject:[self loadNSDataItem:dataFilenameFirstAuthentication]];
    [result addObject:[self loadNSDataItem:dataFilenameComplete]];
    return result;
}


- (void)saveNSDataItem:(NSData *)data filename:(NSString *)filename accessibility:(NSDataWritingOptions)accessibility {
    NSError *error;
    NSString *filepath = [self pathForFilename:filename];
    
    if([data writeToFile:filepath options:accessibility error:&error]) {
        NSLog(@"Wrote NSData to %@", filename);
    } else {
        NSLog(@"Failed to write NSData to %@", filename);
    }
}


- (NSData *)loadNSDataItem:(NSString *)filename {
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
