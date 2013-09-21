#import <Foundation/Foundation.h>

@interface DPDRawNSDataStorage : NSObject

- (void)storeAllNSData:(NSData *)data;
- (NSArray *)retrieveAllNSData;

@end
