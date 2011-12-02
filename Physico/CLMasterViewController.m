//
//  CLMasterViewController.m
//  Physico
//
//  Created by Marcu Sabin on 11/21/11.
//  Copyright (c) 2011 Corn Labs. All rights reserved.
//

#import "CLMasterViewController.h"
#import "CLDetailViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@implementation CLMasterViewController

@synthesize detailViewController = _detailViewController;
@synthesize obj;
@synthesize webView;

enum Sections{
    kHeaderSection = 0,
    kAddObjectSection,
    kRemoveObjectSection,
    kToggleForcesSection,
    kMusicPlayerSection,
    kModesSection,
    kFeedBackSection,
    NUM_SECTIONS
};

enum HeaderSection{
    kShowScene = 0,
    kResetViewport,
    kScrambleObjects,
    NUM_HEADER_ROWS
};

enum AddSection{
    kAddOneObject = 0,
    kAddOneHundredObjects,
    kAddOneThousandObjects,
    NUM_ADD_ROWS
};

enum RemoveSection{
    kRemoveOneObject = 0,
    kRemoveOneHundredObjects,
    kRemoveOneThousandObjects,
    NUM_REMOVE_ROWS
};

enum ToggleSection{
    kToggleGravity = 0,
    kToggleRepulse,
    kToggleRWind,
    kToggleLWind,
    NUM_TOGGLE_ROWS
};

enum MusicPlayerSection{
    kPlayMusic = 0,
    kPauseMusic,
    kShuffleTracks,
    NUM_MUSIC_ROWS
};

enum ModesSection{
    kTrolLMode = 0, 
    kPatriotMode,
    kToggleTextures,
    NUM_MODES_ROWS
};

enum FeedBackSection{
    kFeedBack,
    NUM_FEEDBACK_ROWS
};

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
        self.detailViewController.webView = [self webView];
    }
    [super awakeFromNib];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

UIStoryboardSegue* segue;
MPMusicPlayerController *mPlay;
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    obj = [[NSMutableArray alloc] initWithObjects:nil];
    NSMutableArray* arr[7];
    int i;
    for(i = 0; i < 7; i++) arr[i] = [[NSMutableArray alloc] initWithObjects: nil];
        
    [arr[kHeaderSection] addObject:@"Show me the Scene"];
    [arr[kHeaderSection] addObject:@"Reset Viewport"];
    [arr[kHeaderSection] addObject:@"Scramble Objects"];
    [obj addObject:arr[kHeaderSection]];
    [arr[kAddObjectSection] addObject:@"Add one Object"];   
    [arr[kAddObjectSection] addObject:@"Add 100 Objects"];    
    [arr[kAddObjectSection] addObject:@"Add 1000 Objects"];
    [obj addObject:arr[kAddObjectSection]];
    [arr[kRemoveObjectSection] addObject:@"Remove one Object"];   
    [arr[kRemoveObjectSection] addObject:@"Remove 100 Objects"];    
    [arr[kRemoveObjectSection] addObject:@"Remove 1000 Objects"];
    [obj addObject:arr[kRemoveObjectSection]];
    [arr[kToggleForcesSection] addObject:@"Toggle Gravity"];  
    [arr[kToggleForcesSection] addObject:@"Toggle Repulse"]; 
    [arr[kToggleForcesSection] addObject:@"Toggle Right Wind"]; 
    [arr[kToggleForcesSection] addObject:@"Toggle Left Wind"];   
    [obj addObject:arr[kToggleForcesSection]];
    [arr[kMusicPlayerSection] addObject:@"Play Track"];
    [arr[kMusicPlayerSection] addObject:@"Pause Track"];
    [arr[kMusicPlayerSection] addObject:@"Next Track"]; 
    [obj addObject:arr[kMusicPlayerSection]];
    [arr[kModesSection] addObject:@"Troll Mode"];
    [arr[kModesSection] addObject:@"Patriot Mode"];
    [arr[kModesSection] addObject:@"Toggle Textures"];
    [obj addObject: arr[kModesSection]];
    [arr[kFeedBackSection] addObject:@"Send Feedback"];
    [obj addObject:arr[kFeedBackSection]];
    
    mPlay = [MPMusicPlayerController applicationMusicPlayer];
    [mPlay setQueueWithQuery: [MPMediaQuery songsQuery]];
    [mPlay setShuffleMode:MPMusicShuffleModeSongs];
    [mPlay setRepeatMode:MPMusicRepeatModeAll];
    
//    segue = [[UIStoryboardSegue alloc] initWithIdentifier:@"getDetail" source:self destination:[self detailViewController]];
    
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
    return NUM_SECTIONS;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section)    {
        case kHeaderSection : return NUM_HEADER_ROWS; break;
        case kAddObjectSection : return NUM_ADD_ROWS; break;
        case kRemoveObjectSection : return NUM_REMOVE_ROWS; break;
        case kToggleForcesSection : return NUM_TOGGLE_ROWS; break;
        case kMusicPlayerSection : return NUM_MUSIC_ROWS; break;
        case kModesSection : return NUM_MODES_ROWS; break;
        case kFeedBackSection : return NUM_FEEDBACK_ROWS; break;
        default: return 0;
    }
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
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch ( section )  {
        case kHeaderSection: return @"Basic Stuff";
        case kAddObjectSection: return @"Add objects";
        case kRemoveObjectSection: return @"Remove objects";
        case kToggleForcesSection: return @"Forces Zone";
        case kMusicPlayerSection: return @"Music Player";
        case kModesSection: return @"Mods";
        case kFeedBackSection: return @"Feedback";
        default: return @"";
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    switch ( section )  {
        case kHeaderSection: return @"Basic controls to get you started.";
        case kAddObjectSection: return @"For now, just some random values.";
        case kRemoveObjectSection: return @"Again, only random values, sorry.";
        case kToggleForcesSection: return @"Just some presets, for now. Custom forces coming up in v1.1, prommise (:";
        case kMusicPlayerSection: return @"Hope you like our new ambiental player";
        case kModesSection: return @"Some alterations to the main app";
        case kFeedBackSection: return @"Leave some feedback, don't be an ass...";
        default: return @"";
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case kHeaderSection:             
            switch (indexPath.row) {
                case kShowScene: 
                    [self performSegueWithIdentifier:@"viewScene" sender:self];
                    break;
                case kResetViewport: 
                    [[[self detailViewController] webView] stringByEvaluatingJavaScriptFromString:@"(function(){ Physico.scene = [0, 0, -15]; Physico.rotate = [0, 0, 0]; })()"];
                    break;
                case kScrambleObjects: 
                    [[[self detailViewController] webView] stringByEvaluatingJavaScriptFromString:@"Physico.ObjectList.scrambleObjects()"];
                    break;
            }

            break;
        case kAddObjectSection: 
            switch (indexPath.row) {
                case kAddOneObject: 
                    [[[self detailViewController] webView] stringByEvaluatingJavaScriptFromString:@"Physico.ObjectList.addObject()"];
                    break;
                case kAddOneHundredObjects: 
                    [[[self detailViewController] webView] stringByEvaluatingJavaScriptFromString:@"Physico.ObjectList.addObjects(100)"];
                    break;
                case kAddOneThousandObjects: 
                    [[[self detailViewController] webView] stringByEvaluatingJavaScriptFromString:@"Physico.ObjectList.addObjects(1000)"];
                    break;
            }
            break;
        case kRemoveObjectSection: 
            switch (indexPath.row) {
                case kRemoveOneObject: 
                    [[[self detailViewController] webView] stringByEvaluatingJavaScriptFromString:@"Physico.ObjectList.removeObject()"];
                    break;
                case kRemoveOneHundredObjects: 
                    [[[self detailViewController] webView] stringByEvaluatingJavaScriptFromString:@"Physico.ObjectList.removeObjects(100)"];
                    break;
                case kRemoveOneThousandObjects: 
                    [[[self detailViewController] webView] stringByEvaluatingJavaScriptFromString:@"Physico.ObjectList.removeObjects(1000)"];
                    break;
            }
            break;
        case kToggleForcesSection: 
            switch (indexPath.row) {
                case kToggleGravity: 
                    [[[self detailViewController] webView] stringByEvaluatingJavaScriptFromString:@"Physico.Animator.ToggleEnvForce(\"gravity\")"];
                    break;
                case kToggleRepulse: 
                    [[[self detailViewController] webView] stringByEvaluatingJavaScriptFromString:@"Physico.Animator.ToggleEnvForce(\"repulse\")"];
                    break;
                case kToggleRWind: 
                    [[[self detailViewController] webView] stringByEvaluatingJavaScriptFromString:@"Physico.Animator.ToggleEnvForce(\"wind\")"];
                    break;
                case kToggleLWind: 
                    [[[self detailViewController] webView] stringByEvaluatingJavaScriptFromString:@"Physico.Animator.ToggleEnvForce(\"inverse-wind\")"];
                    break;
            }
            break;
        case kMusicPlayerSection:
            switch (indexPath.row)   {
                case kPlayMusic: 
                    [mPlay play];
                    break;
                case kPauseMusic: 
                    [mPlay pause];
                    break;
                case kShuffleTracks: 
                    [mPlay skipToNextItem];
                    break;
            }
            break;
        case kModesSection: 
            switch (indexPath.row) {
                case kTrolLMode: 
//                    [TestFlight passCheckpoint:@"TROLL_MODE"];
                    [[[self detailViewController] webView] stringByEvaluatingJavaScriptFromString:@"Physico.GL.toggleTroll()"];
                    break;
                case kPatriotMode: 
//                    [TestFlight passCheckpoint:@"PATRIOT_MODE"];
                    [[[self detailViewController] webView] stringByEvaluatingJavaScriptFromString:@"Physico.GL.togglePatriot()"];
                    break;
                case kToggleTextures: 
//                    [TestFlight passCheckpoint:@"TOGGLE_TEXTURES"];
                    [[[self detailViewController] webView] stringByEvaluatingJavaScriptFromString:@"Physico.GL.toggleTextures()"];
                    break;
            }
            break;
        case kFeedBackSection:
            switch (indexPath.row)   {
                case kFeedBack: 
//                    [TestFlight openFeedbackView];
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
