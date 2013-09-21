#import <Foundation/Foundation.h>
#import <Security/SecItem.h>

@interface DPDKeychainStorage : NSObject

- (void)storeAllKeychainData:(NSData *)data;
- (NSArray *)retrieveAllKeychainData;

@end
