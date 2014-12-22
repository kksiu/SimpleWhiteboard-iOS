//
//  DrawViewController.h
//  SimpleWhiteboard
//
//  Created by Kenneth Siu on 10/11/14.
//  Copyright (c) 2014 Kenneth Siu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACEDrawingView.h"

@interface DrawViewController : UIViewController

//drawing view
@property ACEDrawingView *drawView;

//used to send the button to Imgur location
@property UIButton *sendButton;

@end
