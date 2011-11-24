//
//  CLDetailViewController.m
//  Physico
//
//  Created by Marcu Sabin on 11/21/11.
//  Copyright (c) 2011 Corn Labs. All rights reserved.
//

#import "CLDetailViewController.h"
#import "CLWebView.h"


@interface CLDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation CLDetailViewController

@synthesize detailItem = _detailItem;
@synthesize detailView = _detailView;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize masterPopoverController = _masterPopoverController;

CLWebView* webView;
bool tapped, tappedFirst;
float dragDistance[2];
#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self loadWebView];
    [self configureView];
}

- (void)loadWebView
{
        
    CGRect screenRect = [self.view bounds];
    CGFloat screenWidth = screenRect.size.width, screenHeight = screenRect.size.height;
    
    webView = [[CLWebView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) andControler:self];
    webView.autoresizesSubviews = YES;
    webView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    
    NSError* error;
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    NSString* htmlString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"] encoding:NSUTF8StringEncoding error:&error];
    NSLog(@"Starting WebView");
    [webView loadHTMLString:htmlString baseURL:baseURL];
    
    self.view = webView;
    
}

-(void)loadShaders 
{
    NSString* jsonData = [webView stringByEvaluatingJavaScriptFromString:@"(function(){return JSON.stringify(Physico.webglshaders); })()"];
    NSDictionary *shaders = [NSJSONSerialization JSONObjectWithData:[jsonData dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    NSString* fileContents;
    NSString* command;
    NSString* name;
    for(id key in shaders)   {
        id location = [key objectAtIndex:0];
        id type = [key objectAtIndex:1];
        name = [[location componentsSeparatedByString:@"/"] lastObject];
        fileContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"" inDirectory:@"webgl"] encoding:NSUTF8StringEncoding error:nil];
        command= @"(function(){var script=document.createElement('script'); script.id='";
        command = [command stringByAppendingString: name];
        command = [command stringByAppendingString: @"'; script.innerHTML = \""];
        command = [command stringByAppendingString: [fileContents stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"]];         
        command = [command stringByAppendingString: @"\"; script.type = '"];                                          
        command = [command stringByAppendingString: type];
        command = [command stringByAppendingString: @"'; document.head.appendChild(script);"];
        command = [command stringByAppendingString:@" })()"];
        [webView stringByEvaluatingJavaScriptFromString:command];
    }
    [webView stringByEvaluatingJavaScriptFromString:@"Physico.completeLoad()"];
}

- (void)viewDidUnload
{
    [self setDetailView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void) startAccelerometerTracking
{
    UIAccelerometer *acc = [UIAccelerometer sharedAccelerometer];
    acc.delegate = self;
    acc.updateInterval = 0.25;
}
- (void) stopAccelerometerTracking
{    
    UIAccelerometer *acc = [UIAccelerometer sharedAccelerometer];
    acc.delegate = nil;
}
- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    double const ajustment = 0.6;
    if (tapped == NO) return;
    if (tappedFirst)    {
        dragDistance[0] = acceleration.x;
        dragDistance[1] = acceleration.y;
        tappedFirst = NO;
    }
    NSLog(@"%f - %f", ((acceleration.y - dragDistance[0])), ((acceleration.y - dragDistance[1])));
    NSString* command = [[[NSString alloc] init] stringByAppendingFormat:@"(function(){ Physico.rotate[1] -= %f; Physico.rotate[0] += %f; })()", ((acceleration.x - dragDistance[0]) *ajustment), ((acceleration.y - dragDistance[1]) *ajustment)];
    [webView stringByEvaluatingJavaScriptFromString:command];
}
- (void)startTouchEvent
{
    tapped = YES;
    tappedFirst = YES;
}
- (void)endTouchEvent
{
    tapped = NO;
}
- (void)viewDidAppear:(BOOL)animated
{
    [self startAccelerometerTracking];
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self stopAccelerometerTracking];
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
        return !tapped;
    } else {
        return YES;
    }
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [webView stringByEvaluatingJavaScriptFromString:@"(function(){if(typeof(Physico.canvas) != \"undefined\")Physico.GL.updateViewport()})()"];
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setRightBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setRightBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
