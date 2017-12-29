//
//  ViewController.h
//  iOSTB
//
//  Created by Doc Aiden on 12/16/17.
//  Copyright © 2017 iDoc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextView *outputShell;
@property (weak, nonatomic) IBOutlet UITextField *commandInput;
extern const char* Title[];
@property (nonatomic) NSString *cmdtxt;
@property (nonatomic) NSString *mainBundle;
@property (weak, nonatomic) IBOutlet UITextField *cmdarg;
@property (weak, nonatomic) IBOutlet UITextField *trustslist;

@end



