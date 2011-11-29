//
//  CLMasterViewController.h
//  Physico
//
//  Created by Marcu Sabin on 11/21/11.
//  Copyright (c) 2011 Corn Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLWebView.h"

@class CLDetailViewController;

@interface CLMasterViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) CLDetailViewController *detailViewController;
@property (nonatomic, retain) NSMutableArray* obj;
@property (nonatomic, retain) CLWebView* webView;
@end
