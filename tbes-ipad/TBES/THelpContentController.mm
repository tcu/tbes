//
//  THelpContentController.m
//  TBES
//
//  Created by Danny Westfall on 12/5/12.
//  Copyright (c) 2012 TCU. All rights reserved.
//

#import "THelpContentController.h"

@implementation THelpContentController
@synthesize nextController;

-(void) onNext: (id) sender{
    [self.navigationController pushViewController: self.nextController animated: YES];
}

-(void) viewWillAppear:(BOOL)animated{
    if(self.nextController != nil){
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style: UIBarButtonItemStyleBordered target:self action:@selector(onNext:)];
    }
}

@end
