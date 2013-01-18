//
//  THelpController.m
//  TBES
//
//  Created by Danny Westfall on 12/4/12.
//  Copyright (c) 2012 TCU. All rights reserved.
//

#import "THelpController.h"
#import <QuartzCore/QuartzCore.h>

#define TBES_HELP_CELL @"TBES_HELP_CELL"

typedef enum{
    HelpItemIntro,
    HelpItemShortcuts,
    HelpAutoShaping,
    HelpSuccessiveDiscrimination,
    HelpSimultaneousDiscrimination,
    HelpServerSoftware,
    HelpSourceCode
}HelpItem;

@implementation THelpController
@synthesize introController, shortcutsController, shapingController, simultaneousController, successiveController, labServerController, sourceCodeController;

-(void) viewWillAppear:(BOOL)animated{
    
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

-(float) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* headerView = [[UIView alloc] initWithFrame: CGRectMake(10, 0, tableView.frame.size.width, 40)];
    headerView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"GrayGradientCellBackground.jpg"] ];
    headerView.layer.borderColor = [[UIColor darkGrayColor] CGColor];
    headerView.layer.borderWidth = 0.5f;
    
    UILabel* lbl = [[UILabel alloc] initWithFrame: headerView.frame];
    lbl.text = @"Touchscreen Behavioral Evaluation System";
    lbl.textColor = [UIColor blackColor];
    lbl.contentMode = UIViewContentModeCenter;
    lbl.backgroundColor = [UIColor clearColor];
    [headerView addSubview: lbl];
    
    return headerView;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    if(indexPath.row == HelpItemIntro){
        [self.navigationController pushViewController: self.introController animated: YES];
    }
    else if(indexPath.row == HelpItemShortcuts){
        [self.navigationController pushViewController: self.shortcutsController animated: YES];
    }
    else if(indexPath.row == HelpAutoShaping){
        [self.navigationController pushViewController: self.shapingController animated: YES];
    }
    else if(indexPath.row == HelpSimultaneousDiscrimination){
        [self.navigationController pushViewController: self.simultaneousController animated: YES];
    }
    else if(indexPath.row == HelpSuccessiveDiscrimination){
        [self.navigationController pushViewController: self.successiveController animated: YES];
    }
    else if(indexPath.row == HelpServerSoftware){
        [self.navigationController pushViewController: labServerController animated: YES];
    }
    else if(indexPath.row == HelpSourceCode){
        [self.navigationController pushViewController: sourceCodeController animated: YES];
    }
}

-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: TBES_HELP_CELL];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: TBES_HELP_CELL];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }
    
    if(indexPath.row == HelpItemIntro){
        cell.textLabel.text = @"Introduction";
        cell.detailTextLabel.text = @"An overview of the system and what it can be used for";
    }
    else if(indexPath.row == HelpItemShortcuts){
        cell.textLabel.text = @"Shortcuts";
        cell.detailTextLabel.text = @"Tap and Gestures techniques that make using the app easier";
    }
    else if(indexPath.row == HelpAutoShaping){
        cell.textLabel.text = @"Auto Shaping";
        cell.detailTextLabel.text = @"Getting the desired behavior over successive trials.";
    }
    else if(indexPath.row == HelpSimultaneousDiscrimination){
        cell.textLabel.text = @"Simultaneous Discrimination";
        cell.detailTextLabel.text = @"Presenting two or more stimuli at the same time.";
    }
    else if(indexPath.row == HelpSuccessiveDiscrimination){
        cell.textLabel.text = @"Successive Discrimination";
        cell.detailTextLabel.text = @"Presenting two or more stimu one at a time.";
    }
    else if(indexPath.row == HelpServerSoftware){
        cell.textLabel.text = @"Lab Server Software";
        cell.detailTextLabel.text = @"Downloading and Installing the lab server software.";
    }
    else if(indexPath.row == HelpSourceCode){
        cell.textLabel.text = @"Source Code";
        cell.detailTextLabel.text = @"TBES is an open source application";
    }
    
    
    
    if(cell.backgroundView == nil){
        cell.backgroundView = [[UIView alloc] initWithFrame: cell.frame];
        cell.backgroundView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"gray_table_cell_background.png"] ];
    }
    
    
    return cell;
}

@end
