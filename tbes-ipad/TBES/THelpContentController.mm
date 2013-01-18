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
 ** THelpContentController.mm
 ** TBES
 **
 ** Created on 12/5/12
 ** Kenneth Leising
 ** Catherine Urbano
 ** Danny Westfall
 ** 
 ** -------------------------------------------------------------------------*/

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
