//
//  CLMasterViewController.m
//  Physico
//
//  Created by Marcu Sabin on 11/21/11.
//  Copyright (c) 2011 Corn Labs. All rights reserved.
//

#import "CLMasterViewController.h"

#import "CLDetailViewController.h"

@implementation CLMasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize obj;

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

NSMutableArray* elements;
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    obj = [[NSMutableArray alloc] initWithObjects:nil];
    NSMutableArray* arr[4];
    int i;
    for(i = 0; i < 4; i++) arr[i] = [[NSMutableArray alloc] initWithObjects: nil];
    
    [arr[0] addObject:@"Show me the Scene"];
    [arr[0] addObject:@"Reset Viewport"];
    [arr[0] addObject:@"Scramble Objects"];
    [obj addObject:arr[0]];
    [arr[1] addObject:@"Add one Object"];   
    [arr[1] addObject:@"Add 100 Objects"];    
    [arr[1] addObject:@"Add 1000 Objects"];
    [obj addObject:arr[1]];
    [arr[2] addObject:@"Remove one Object"];   
    [arr[2] addObject:@"Remove 100 Objects"];    
    [arr[2] addObject:@"Remove 1000 Objects"];
    [obj addObject:arr[2]];
    [arr[3] addObject:@"Toggle Gravity"];  
    [arr[3] addObject:@"Toggle Repulse"]; 
    [arr[3] addObject:@"Toggle Right Wind"]; 
    [arr[3] addObject:@"Toggle Left Wind"];   
    [obj addObject:arr[3]];
    
	// Do any additional setup after loading the view, typically from a nib.
    self.detailViewController = (CLDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView { 
    NSLog(@"%d", [[self obj] count]);
    return [[self obj] count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%d", [[[self obj] objectAtIndex:section] count]);
    return [[[self obj] objectAtIndex:section ] count];
}
-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuItem"];
    if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MenuItem"];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
      }
    cell.textLabel.text = [[obj objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:             
            switch (indexPath.row) {
                case 0: 
                    break;
                case 1: 
                    [[[self detailViewController] webView] stringByEvaluatingJavaScriptFromString:@"(function(){ Physico.scene = [0, 0, -15]; Physico.rotate = [0, 0, 0]; })()"];
                    break;
                case 2: 
                    [[[self detailViewController] webView] stringByEvaluatingJavaScriptFromString:@"Physico.ObjectList.scrambleObjects()"];
                    break;
            }

            break;
        case 1: 
            switch (indexPath.row) {
                case 0: 
                    [[[self detailViewController] webView] stringByEvaluatingJavaScriptFromString:@"Physico.ObjectList.addObject()"];
                    break;
                case 1: 
                    [[[self detailViewController] webView] stringByEvaluatingJavaScriptFromString:@"Physico.ObjectList.addObjects(100)"];
                    break;
                case 2: 
                    [[[self detailViewController] webView] stringByEvaluatingJavaScriptFromString:@"Physico.ObjectList.addObjects(1000)"];
                    break;
            }
            break;
        case 2: 
            switch (indexPath.row) {
                case 0: 
                    [[[self detailViewController] webView] stringByEvaluatingJavaScriptFromString:@"Physico.ObjectList.removeObject()"];
                    break;
                case 1: 
                    [[[self detailViewController] webView] stringByEvaluatingJavaScriptFromString:@"Physico.ObjectList.removeObjects(100)"];
                    break;
                case 2: 
                    [[[self detailViewController] webView] stringByEvaluatingJavaScriptFromString:@"Physico.ObjectList.removeObjects(1000)"];
                    break;
            }
            break;
        case 3: 
            switch (indexPath.row) {
                case 0: 
                    [[[self detailViewController] webView] stringByEvaluatingJavaScriptFromString:@"Physico.Animator.ToggleEnvForce(\"gravity\")"];
                    break;
                case 1: 
                    [[[self detailViewController] webView] stringByEvaluatingJavaScriptFromString:@"Physico.Animator.ToggleEnvForce(\"repulse\")"];
                    break;
                case 2: 
                    [[[self detailViewController] webView] stringByEvaluatingJavaScriptFromString:@"Physico.Animator.ToggleEnvForce(\"wind\")"];
                    break;
                case 3: 
                    [[[self detailViewController] webView] stringByEvaluatingJavaScriptFromString:@"Physico.Animator.ToggleEnvForce(\"inverse-wind\")"];
                    break;
            }
            break;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end
