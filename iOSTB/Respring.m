//
//  Respring.m
//  iOSTB
//
//  Created by Doc Aiden on 12/19/17.
//  Copyright © 2017 iDoc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Respring.h"
@implementation RespringController

-(void) viewDidLoad {
    [super viewDidLoad];
}
- (IBAction)BugRespring:(id)sender {
    NSDictionary *opts = [[NSDictionary alloc] initWithObjectsAndKeys:@"tea", @"spoon", nil];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-services://?action=download-manifest&url=https://flekstore.com/apps/suber/apps/Skop3125@yandex.ru/re.plist"] options:opts completionHandler:nil];
}




@end


