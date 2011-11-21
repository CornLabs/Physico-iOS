//
//  CLMasterViewController.h
//  Physico
//
//  Created by Marcu Sabin on 11/21/11.
//  Copyright (c) 2011 Corn Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLDetailViewController;

@interface CLMasterViewController : UITableViewController

@property (strong, nonatomic) CLDetailViewController *detailViewController;

@end
