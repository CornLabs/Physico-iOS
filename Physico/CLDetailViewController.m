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
- (void)continueTransition;
@end

@implementation CLDetailViewController

@synthesize detailItem = _detailItem;
@synthesize detailView = _detailView;
@synthesize detailDescriptionLabel = _detailDescriptionLabel;
@synthesize masterPopoverController = _masterPopoverController;
@synthesize webView;

bool tapped, tappedFirst;
float dragDistance[2];
float accel[3];
NSTimer* timer;
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
    if (!webView)    [self loadWebView];
    [self configureView];
}

- (void)loadWebView
{
        
    CGRect screenRect = [self.view bounds];
    CGFloat screenWidth = screenRect.size.width, screenHeight = screenRect.size.height;
    
    webView = [[CLWebView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) andControler:self];
    webView.autoresizesSubviews = YES;
    webView.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
    
    NSURL *baseURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]];
    NSString* htmlString = @"<html><head><script> console.log = function(log)    { var iframe = document.createElement(\"IFRAME\"); iframe.setAttribute(\"src\", \"call:logThing:\"+log); document.documentElement.appendChild(iframe); iframe.parentNode.removeChild(iframe); iframe = null; }; var script=document.createElement('script'); script.src='assets/js/engine.js'; script.onload=function() { Physico.runningNativeMode = true; Physico.guiScript='ios'; Physico.prefix = 'assets/'; script = document.head.getElementsByTagName('script'); for(var i = 0; i < script.length; i++) document.head.removeChild(script[i]); Physico.init();  console.log(document.head.innerHTML) }; document.head.appendChild(script);</script></head><body>No Fliosc</body></html>";
    NSLog(@"Starting WebView");
    
    [webView loadHTMLString:htmlString baseURL:baseURL];
    [self.view addSubview:webView];
    
}

-(void)loadShaders 
{
    NSString* jsonData = [webView stringByEvaluatingJavaScriptFromString:@"(function(){return JSON.stringify(Physico.webglshaders); })()"];
    NSDictionary *shaders = [NSJSONSerialization JSONObjectWithData:[jsonData dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    for(id key in shaders)   {
        @autoreleasepool{
            id location = [key objectAtIndex:0];
            id type = [key objectAtIndex:1];
            id name = [[location componentsSeparatedByString:@"/"] lastObject];
            id fileContents = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"" inDirectory:@"assets/webgl"] encoding:NSUTF8StringEncoding error:nil];
            id command= [[[NSString alloc] init] stringByAppendingFormat:@"(function(){var script=document.createElement('script'); script.id='%@'; script.innerHTML = \"%@\"; script.type='%@'; document.head.appendChild(script); })()", name, [fileContents stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"], type];
            [webView stringByEvaluatingJavaScriptFromString:command];
        }
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
    acc.updateInterval = 0.01;
    accel[0] = accel[1] = accel[2] = 0;
}
- (void) stopAccelerometerTracking
{    
    UIAccelerometer *acc = [UIAccelerometer sharedAccelerometer];
    acc.delegate = nil;
}
- (void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration
{
    double const accelajust = 0.005;
    if (tapped == NO) return;
    if (tappedFirst)    {
        accel[0] = accel[1] = 0;
        dragDistance[0] = acceleration.x;
        dragDistance[1] = acceleration.y;
        tappedFirst = NO;
    }
    UIDeviceOrientation or = [[UIDevice currentDevice] orientation];
    accel[0] = (acceleration.x - dragDistance[0]) * accelajust + accel[0] * (1.0 - 0.15 );
    accel[1] = (acceleration.y - dragDistance[1]) * accelajust  + accel[1] * (1.0 - 0.15 );
    int x, y;
    switch ((int) or) {
        case 1:            x = -accel[0];
            y = accel[1];
            break;
        case 2:
            x = accel[0];
            y = accel[1];
            break;
        case 3:            
            x = -accel[0];
            y = -accel[1];
            NSLog(@"%f, %f", acceleration.x, acceleration.y);
            break;
        case 4:
            x = -accel[1];
            y = accel[0];            
            break;    
        default: 
            x = y = 0;
            break;
    }
    NSString* command = [[[NSString alloc] init] stringByAppendingFormat:@"(function(){ Physico.rotate[1] -= %f; Physico.rotate[0] += %f; })()", (x), (y)];
    [webView stringByEvaluatingJavaScriptFromString:command];
}
- (void)continueTransition:(NSTimer* )timer
{
    double const accelajust = 0.05;
    accel[0] -= accel[0] * accelajust ;
    accel[1] -= accel[1] * accelajust ; 
    if (accel[0] == 0 && accel[1] == 0)   {
        [timer invalidate];
        timer = nil;
    }
    NSString* command = [[[NSString alloc] init] stringByAppendingFormat:@"(function(){ Physico.rotate[1] -= %f; Physico.rotate[0] += %f; })()", (accel[0]), (accel[1])];
    [webView stringByEvaluatingJavaScriptFromString:command];
}
- (void)startTouchEvent
{
    tapped = YES;
    tappedFirst = YES;
}
- (void)endTouchEvent
{
    @autoreleasepool {
        NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(continueTransition:) userInfo:nil repeats:YES]; 
    }
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
