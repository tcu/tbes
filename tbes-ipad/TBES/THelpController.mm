/*
 
 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 
*/

/* ---------------------------------------------------------------------------
 ** Texas Christian University
 **
 ** THelpController.mm
 ** TBES
 **
 ** Created on 12/4/12
 ** Kenneth Leising
 ** Catherine Urbano
 ** Danny Westfall
 ** 
 ** -------------------------------------------------------------------------*/

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

@interface THelpController(){
    UIFont* _textLabelFont;
    UIFont* _descriptionLabelFont;
}

@end

@implementation THelpController
@synthesize introController, shortcutsController, shapingController, simultaneousController, successiveController, labServerController, sourceCodeController;

-(void) awakeFromNib{
    _textLabelFont = [UIFont fontWithName: @"Helvetica-Bold" size: 12];
    _descriptionLabelFont = [UIFont fontWithName: @"Helvetica-Bold" size: 10];
}

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

-(float) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString* title = nil;
    NSString* desc = nil;
    if(indexPath.row == HelpItemIntro){
        title = TString(@"TBES_HELP_INTRO_TITLE");
        desc = TString(@"TBES_HELP_INTRO_DESC");
    }
    else if(indexPath.row == HelpItemShortcuts){
        title = TString(@"TBES_HELP_SHORTCUTS_TITLE");
        desc = TString(@"TBES_HELP_SHIRTCUTS_DESC");
    }
    else if(indexPath.row == HelpAutoShaping){
        title = TString(@"TBES_HELP_AUTO_SHAPING_TITLE");
        desc = TString(@"TBES_HELP_AUTO_SHAPING_DESC");
    }
    else if(indexPath.row == HelpSimultaneousDiscrimination){
        title = TString(@"TBES_HELP_SIM_DISCRIM_TITLE");
        desc = TString(@"TBES_HELP_SIM_DISCRIM_DESC");
    }
    else if(indexPath.row == HelpSuccessiveDiscrimination){
        title = TString(@"TBES_HELP_SUC_DESCRIM_TITLE");
        desc = TString(@"TBES_HELP_SUC_DESCRIM_DESC");
    }
    else if(indexPath.row == HelpServerSoftware){
        title = TString(@"TBES_HELP_SERVER_TITLE");
        desc = TString(@"TBES_HELP_SERVER_DESC");
    }
    else if(indexPath.row == HelpSourceCode){
        title = TString(@"TBES_HELP_SOURCE_TITLE");
        desc = TString(@"TBES_HELP_SOURCE_DESC");
    }
    
    CGSize titleSize = [title sizeWithFont: _textLabelFont constrainedToSize:CGSizeMake(300, 500)];
    CGSize descriptionSize = [desc sizeWithFont: _descriptionLabelFont constrainedToSize:CGSizeMake(300, 500)];
    float height = titleSize.height + descriptionSize.height + 25;
    
//    if(height < 75 ){
//        height = 75;
//    }
    
    
    return height;
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
    NSString* title = nil;
    NSString* desc = nil;
    if(indexPath.row == HelpItemIntro){
        title = TString(@"TBES_HELP_INTRO_TITLE");
        desc = TString(@"TBES_HELP_INTRO_DESC");
    }
    else if(indexPath.row == HelpItemShortcuts){
        title = TString(@"TBES_HELP_SHORTCUTS_TITLE");
        desc = TString(@"TBES_HELP_SHIRTCUTS_DESC");
    }
    else if(indexPath.row == HelpAutoShaping){
        title = TString(@"TBES_HELP_AUTO_SHAPING_TITLE");
        desc = TString(@"TBES_HELP_AUTO_SHAPING_DESC");
    }
    else if(indexPath.row == HelpSimultaneousDiscrimination){
        title = TString(@"TBES_HELP_SIM_DISCRIM_TITLE");
        desc = TString(@"TBES_HELP_SIM_DISCRIM_DESC");
    }
    else if(indexPath.row == HelpSuccessiveDiscrimination){
        title = TString(@"TBES_HELP_SUC_DESCRIM_TITLE");
        desc = TString(@"TBES_HELP_SUC_DESCRIM_DESC");
    }
    else if(indexPath.row == HelpServerSoftware){
        title = TString(@"TBES_HELP_SERVER_TITLE");
        desc = TString(@"TBES_HELP_SERVER_DESC");
    }
    else if(indexPath.row == HelpSourceCode){
        title = TString(@"TBES_HELP_SOURCE_TITLE");
        desc = TString(@"TBES_HELP_SOURCE_DESC");
    }
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = desc;
    CGSize titleSize = [cell.textLabel.text sizeWithFont: _textLabelFont constrainedToSize:CGSizeMake(300, 500)];
    CGSize descriptionSize = [cell.detailTextLabel.text sizeWithFont: _descriptionLabelFont constrainedToSize:CGSizeMake(300, 500)];
    cell.textLabel.numberOfLines = ceil(titleSize.height / 15);
    cell.detailTextLabel.numberOfLines = ceil(descriptionSize.height / 15);
    
    if(cell.backgroundView == nil){
        cell.backgroundView = [[UIView alloc] initWithFrame: cell.frame];
        cell.backgroundView.backgroundColor = [UIColor colorWithPatternImage: [UIImage imageNamed: @"gray_table_cell_background.png"] ];
    }
    
    
    return cell;
}

@end
