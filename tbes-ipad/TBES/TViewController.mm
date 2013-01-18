//
//  TViewController.m
//  TBES
//
//  Created by Danny Westfall on 12/4/12.
//  Copyright (c) 2012 TCU. All rights reserved.
//

#import "TViewController.h"

@implementation TViewController

-(NSUserDefaults*) userDefaults{
    return [NSUserDefaults standardUserDefaults];
}

-(void) showErrorMessage: (NSString*) message{
    UIAlertView* errorAlert = [[UIAlertView alloc] initWithTitle: @"TBES Error" message: message delegate:nil cancelButtonTitle:@"Continue" otherButtonTitles:nil];
    [errorAlert show];
}

@end
