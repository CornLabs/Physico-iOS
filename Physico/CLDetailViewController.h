//
//  CLDetailViewController.h
//  Physico
//
//  Created by Marcu Sabin on 11/21/11.
//  Copyright (c) 2011 Corn Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLDetailViewController : UIViewController <UISplitViewControllerDelegate, UIAccelerometerDelegate>

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UIView *detailView;

-(void) loadWebView;
-(void) decideTap:(UITapGestureRecognizer *)rec ;
-(void) startTouchEvent;
-(void) endTouchEvent;
@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
