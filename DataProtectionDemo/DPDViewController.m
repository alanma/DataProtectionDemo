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
    [self.keychainStorage storeAllKeychainData:self.secretData];
}

- (IBAction)keychainRetrieve:(id)sender {
    NSArray *keychainData = [self.keychainStorage retrieveAllKeychainData];
    NSArray *keychainStrings = [self dataArrayToStringArray:keychainData];
    NSLog(@"Received Keychain data: %@", keychainStrings);
}

- (IBAction)keychainRetrieveDelayed:(id)sender {
    NSLog(@"Scheduling background Keychain retrieve in 12 seconds");
    [self scheduleBackground:^{
        [self keychainRetrieve:sender];
    }];
}


#pragma mark - NSData

- (IBAction)saveNSData:(id)sender {
    [self.rawNSDataStorage storeAllNSData:self.secretData];
}

- (IBAction)retrieveNSData:(id)sender {
    NSArray *keychainData = [self.rawNSDataStorage retrieveAllNSData];
    NSArray *keychainStrings = [self dataArrayToStringArray:keychainData];
    NSLog(@"Received raw NSData data: %@", keychainStrings);
}

- (IBAction)retrieveNSDataDelayed:(id)sender {
    NSLog(@"Scheduling background NSData retrieve in 12 seconds");
    [self scheduleBackground:^{
        [self retrieveNSData:sender];
    }];
}


#pragma mark - Utility functions

- (void)scheduleBackground:(dispatch_block_t)block {
    UIApplication *application = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask = UIBackgroundTaskInvalid;
    bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 12 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        block();
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    });
}

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


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    return YES;
}
@end
