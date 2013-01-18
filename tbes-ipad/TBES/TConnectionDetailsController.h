//
//  TConnectionDetailsController.h
//  TBES
//
//  Created by Danny Westfall on 1/9/13.
//  Copyright (c) 2013 TCU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TViewController.h"

@interface TConnectionDetailsController : TViewController{
    IBOutlet UILabel* connectionTimeLabel;
    IBOutlet UILabel* connectionServerLabel;
}

-(void) showConnectionDetails: (NSDate*) date: (NSString*) hostName;

@end
