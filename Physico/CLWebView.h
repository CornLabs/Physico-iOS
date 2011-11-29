//
//  CLWebView.h
//  Physico
//
//  Created by Marcu Sabin on 11/22/11.
//  Copyright (c) 2011 Corn Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLWebView : UIWebView <UIWebViewDelegate>

@property (retain) id controler;
-( CLWebView* ) initWithFrame: (CGRect)frame andControler:(id)controler;
-( void ) setWebGLEnabled:(BOOL)enableWebGL;

@end
