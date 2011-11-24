//
//  CLWebView.m
//  Physico
//
//  Created by Marcu Sabin on 11/22/11.
//  Copyright (c) 2011 Corn Labs. All rights reserved.
//

#import "CLWebView.h"


@implementation CLWebView
@synthesize controler;

-( void ) setWebGLEnabled:(BOOL)enableWebGL
{       
      
        id webDocumentView = [self performSelector:@selector(_browserView)];
        id backingWebView = [webDocumentView performSelector:@selector(webView)];
        [backingWebView _setWebGLEnabled:YES];
    
}
-( CLWebView* ) initWithFrame: (CGRect)frame  andControler:(id)ctr
{
    if (self = [super initWithFrame: frame])    {  
        
        self.delegate = self;
        self.controler = ctr;
        [self setWebGLEnabled: TRUE];
        
    }
    return self;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}
- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = request.URL;
    NSString *urlString = url.relativeString;
    NSRange urlrange = [[[request URL] absoluteString] rangeOfString:@"call:"];
    if (urlrange.length > 0)    {
        
        NSArray *components = [urlString componentsSeparatedByString:@":"];
        NSString *function = [components objectAtIndex:1];
        
        if ([function isEqualToString:@"logThing"]) NSLog(@"%@", [components objectAtIndex:2]);
        else if ([function isEqualToString:@"triggerEvent"]) [self.controler performSelector:NSSelectorFromString([[components objectAtIndex:2] stringByAppendingString:@"Event"]) withObject:[components objectAtIndex:3]];
        else if ([function isEqualToString:@"loadShaders"]) {
            NSLog(@"Loaded ShaderS");
            [self.controler performSelector:NSSelectorFromString(function)];
        }
    }
    
    return YES;
}

-(void) didFailLoadWithError: (NSError*)error 
{
    NSLog(@"ERROR : %@", error);
}
@end
