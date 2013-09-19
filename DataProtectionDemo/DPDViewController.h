//
//  DPDViewController.h
//  DataProtectionDemo
//
//  Created by Erik Romijn on 9/19/13.
//  Copyright (c) 2013 Solid Links. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DPDViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *secretField;

- (IBAction)keychainAdd:(id)sender;
- (IBAction)keychainRetrieve:(id)sender;
- (IBAction)keychainRetrieveDelayed:(id)sender;

- (IBAction)saveNSData:(id)sender;
- (IBAction)retrieveNSData:(id)sender;
- (IBAction)retrieveNSDataDelayed:(id)sender;

@end
