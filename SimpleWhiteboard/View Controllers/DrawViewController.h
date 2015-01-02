//
//  DrawViewController.h
//  SimpleWhiteboard
//
//  Created by Kenneth Siu on 10/11/14.
//  Copyright (c) 2014 Kenneth Siu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Firebase/Firebase.h>
#import "ACEDrawingView.h"
#import "IMGSession.h"

@interface DrawViewController : UIViewController <IMGSessionDelegate>

//drawing view
@property ACEDrawingView *drawView;

//used to send the button to Imgur location
@property UIButton *sendButton;

//firebase variable
@property Firebase *firebase;

//user id that is specific to the current user
@property NSString *uid;

//sessionID for facebook
@property NSString *sessionID;

//array of buttons in the ui toolbar
@property NSMutableArray *toolbarArray;

//toolbar
@property UIToolbar* toolbar;

//slider for width
@property UISlider* widthSlider;

//get the full line width allowed
@property CGFloat fullLineWidth;

//color alert view
@property UIAlertView *colorAlertView;

//color array
@property NSArray *colorArray;

//type alert view
@property UIAlertView *typeAlertView;



@end
