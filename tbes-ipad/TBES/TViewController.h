//
//  TViewController.h
//  TBES
//
//  Created by Danny Westfall on 12/4/12.
//  Copyright (c) 2012 TCU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface TViewController : UIViewController{

}

@property(readonly) NSUserDefaults* userDefaults;

-(void) showErrorMessage: (NSString*) message;

@end
