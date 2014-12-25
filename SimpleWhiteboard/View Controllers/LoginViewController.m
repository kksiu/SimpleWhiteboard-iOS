//
//  ViewController.m
//  SimpleWhiteboard
//
//  Created by Kenneth Siu on 10/11/14.
//  Copyright (c) 2014 Kenneth Siu. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "LoginViewController.h"
#import "RootNavController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController {
    RootNavController* nav;
}

@synthesize userField, passField;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //set the navigation bar hidden
    [self.navigationController setNavigationBarHidden:YES];
    
    //alloc view and show log in menu
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //set navigation controller
    nav = (RootNavController*)self.navigationController;
    
//    //have a text view for username and for password
//    float widthPadding = [self.view frame].size.width / 9;
//    float height = [self.view frame].size.height / 15;
//    float widthLength = [self.view frame].size.width - (2 * widthPadding);
//    float cornerRadius = 5.0f;
//    float borderWidth = 1.0f;
//    
//    userField = [[InputTextView alloc] initWithFrame:CGRectMake(widthPadding, [self.view frame].size.height / 5, widthLength, height)];
//    userField.layer.cornerRadius = cornerRadius;
//    userField.layer.masksToBounds = YES;
//    userField.layer.borderColor = [[UIColor blackColor] CGColor];
//    userField.layer.borderWidth = borderWidth;
//    userField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    userField.placeholder = @"Username";
//    userField.delegate = self;
//    [userField setReturnKeyType:UIReturnKeyNext];
//    
//    passField = [[InputTextView alloc] initWithFrame:CGRectMake(widthPadding, [userField frame].origin.y + [userField frame].size.height + height / 2, widthLength, height)];
//    passField.layer.cornerRadius = cornerRadius;
//    passField.layer.masksToBounds = YES;
//    passField.layer.borderColor = [[UIColor blackColor] CGColor];
//    passField.layer.borderWidth = borderWidth;
//    passField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    passField.placeholder = @"Password";
//    passField.delegate = self;
//    [passField setReturnKeyType:UIReturnKeyDone];
//    passField.secureTextEntry = YES;
//    
//    
//    [self.view addSubview:userField];
//    [self.view addSubview:passField];
    
    
    //check if already have a session, if so, jump straight to the drawing VC
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded)
    {
        nav.drawVC.sessionID = FBSession.activeSession.accessTokenData.accessToken;
        nav.viewControllers = @[nav.drawVC];
    }
    
    //height of button
    float heightOfLoginFBButton = self.view.frame.size.height / 10;
    
    //set a login for facebook
    self.logInFacebook = [[UIButton alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height / 2.f) - (heightOfLoginFBButton / 2.f), self.view.frame.size.width, heightOfLoginFBButton)];
    
    [self.logInFacebook setBackgroundColor:[UIColor blueColor]];
    [self.logInFacebook setTitle:@"Login (Facebook)" forState:UIControlStateNormal];
    
    [self.logInFacebook addTarget:self action:@selector(logInFacebookSelected:) forControlEvents:UIControlEventTouchDown];
    
    [self.view addSubview:self.logInFacebook];
}

#pragma mark login in functions
-(void) logInFacebookSelected:(UIButton *)logInFacebook {
    //start up the log in facebook method
    // Open a session showing the user the login UI, use uid to store the image
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"] allowLoginUI:YES
                                  completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                      
                                      if (error) {
                                          NSLog(@"Facebook login failed. Error: %@", error);
                                      } else if (state == FBSessionStateOpen) {
                                          nav.drawVC.sessionID = FBSession.activeSession.accessTokenData.accessToken;
                                          nav.viewControllers = @[nav.drawVC];
                                      }
                                  }];
}

#pragma mark Text Field funcitons
-(BOOL) textFieldShouldReturn:(UITextField *)textField {
    
    //this will change the text fields when pressing the return keys
    if([textField isEqual:userField]) {
        [userField resignFirstResponder];
        [passField becomeFirstResponder];
    } else if([textField isEqual:passField]) {
        [passField resignFirstResponder];
    } else {
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
