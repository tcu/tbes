//
//  THelpController.h
//  TBES
//
//  Created by Danny Westfall on 12/4/12.
//  Copyright (c) 2012 TCU. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TViewController.h"
#import "THelpContentController.h"

@interface THelpController : TViewController<UITableViewDataSource, UITableViewDelegate>{

}

@property(nonatomic, strong) IBOutlet THelpContentController* introController;
@property(nonatomic, strong) IBOutlet THelpContentController* shortcutsController;
@property(nonatomic, strong) IBOutlet THelpContentController* shapingController;
@property(nonatomic, strong) IBOutlet THelpContentController* successiveController;
@property(nonatomic, strong) IBOutlet THelpContentController* simultaneousController;
@property(nonatomic, strong) IBOutlet THelpContentController* labServerController;
@property(nonatomic, strong) IBOutlet THelpContentController* sourceCodeController;

@end
