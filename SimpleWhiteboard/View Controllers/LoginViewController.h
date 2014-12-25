//
//  ViewController.h
//  SimpleWhiteboard
//
//  Created by Kenneth Siu on 10/11/14.
//  Copyright (c) 2014 Kenneth Siu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputTextView.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property InputTextView *userField;
@property InputTextView *passField;

@property UIButton *logInFacebook;

@end

