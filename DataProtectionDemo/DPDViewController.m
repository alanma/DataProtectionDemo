//
//  DPDViewController.m
//  DataProtectionDemo
//
//  Created by Erik Romijn on 9/19/13.
//  Copyright (c) 2013 Solid Links. All rights reserved.
//

#import "DPDViewController.h"
#import "DPDKeychainStorage.h"
#import "DPDRawNSDataStorage.h"

@interface DPDViewController ()
@property (strong, nonatomic) DPDKeychainStorage *keychainStorage;
@property (strong, nonatomic) DPDRawNSDataStorage *rawNSDataStorage;
@property (readonly, nonatomic) NSData *secretData;
@end

@implementation DPDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.keychainStorage = [DPDKeychainStorage new];
    self.rawNSDataStorage = [DPDRawNSDataStorage new];
}

#pragma mark - Keychain

- (IBAction)keychainAdd:(id)sender {
    [self.keychainStorage storeKeychainData:self.secretData];
}

- (IBAction)keychainRetrieve:(id)sender {
    NSArray *keychainData = [self.keychainStorage retrieveKeychainData];
    NSArray *keychainStrings = [self dataArrayToStringArray:keychainData];
    NSLog(@"Received Keychain data: %@", keychainStrings);
}

- (IBAction)keychainRetrieveDelayed:(id)sender {
    NSLog(@"Scheduling background Keychain retrieve in 12 seconds");
    UIApplication *application = [UIApplication sharedApplication];
    UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        // Clean up any unfinished task business by marking where you
        // stopped or ending the task outright.
        [application endBackgroundTask:bgTask];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 12 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self keychainRetrieve:sender];
        [application endBackgroundTask:bgTask];
    });
}

#pragma mark - NSData

- (IBAction)saveNSData:(id)sender {
    [self.rawNSDataStorage storeNSData:self.secretData];
}

- (IBAction)retrieveNSData:(id)sender {
    NSArray *keychainData = [self.rawNSDataStorage retrieveNSData];
    NSArray *keychainStrings = [self dataArrayToStringArray:keychainData];
    NSLog(@"Received raw NSData data: %@", keychainStrings);
}

- (IBAction)retrieveNSDataDelayed:(id)sender {
    NSLog(@"Scheduling background NSData retrieve in 12 seconds");
    UIApplication *application = [UIApplication sharedApplication];
    UIBackgroundTaskIdentifier bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        // Clean up any unfinished task business by marking where you
        // stopped or ending the task outright.
        [application endBackgroundTask:bgTask];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 12 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self retrieveNSData:sender];
        [application endBackgroundTask:bgTask];
    });
}

#pragma mark - Utility functions


- (NSData *)secretData {
    return [self.secretField.text dataUsingEncoding:NSUTF8StringEncoding];
}

- (NSArray *)dataArrayToStringArray:(NSArray *)input {
    NSMutableArray *result = [NSMutableArray array];
    for (NSData *data in input) {
        NSString* string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [result addObject:string];
    }
    return result;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}
@end
