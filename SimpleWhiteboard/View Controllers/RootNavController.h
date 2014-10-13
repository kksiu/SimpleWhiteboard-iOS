//
//  RootNavController.h
//  SimpleWhiteboard
//
//  Created by Kenneth Siu on 10/11/14.
//  Copyright (c) 2014 Kenneth Siu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "DrawViewController.h"

@interface RootNavController : UINavigationController

@property LoginViewController *logVC;

@property DrawViewController *drawVC;

@end
