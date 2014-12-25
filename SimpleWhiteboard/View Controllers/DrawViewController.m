//
//  DrawViewController.m
//  SimpleWhiteboard
//
//  Created by Kenneth Siu on 10/11/14.
//  Copyright (c) 2014 Kenneth Siu. All rights reserved.
//

#import <FacebookSDK/FacebookSDK.h>
#import "DrawViewController.h"
#import "SecretKeys.h"
#import "IMGImage.h"
#import "IMGImageRequest.h"

@interface DrawViewController ()

@end

@implementation DrawViewController {
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    [self.navigationController setNavigationBarHidden:YES];
    
    //set the view
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //get the drawing context
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    //button to send the image
    float startHeightOfSendbutton = self.view.frame.size.height / 10.f;
    
    self.sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    self.sendButton.frame = CGRectMake(0, self.view.frame.size.height - startHeightOfSendbutton, self.view.frame.size.width, startHeightOfSendbutton);
    
    [self.sendButton setTitle:@"Send Image" forState:UIControlStateNormal];
    [self.sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:self.sendButton];
    
    //when send button is selected, upload to imgur
    [self.sendButton addTarget:self action:@selector(sendButtonPressed:) forControlEvents:UIControlEventTouchDown];
    
    //set up draw view
    self.drawView = [[ACEDrawingView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.sendButton.frame.origin.y)];
    
    [self.view addSubview:self.drawView];
    
    //session
    [IMGSession anonymousSessionWithClientID:[SecretKeys getImgurClientID] withDelegate:self];
    
    //init firebase
    self.firebase = [[Firebase alloc] initWithUrl:@"https://simplewhiteboard.firebaseio.com"];
    
    //session ID has been retrieved so you can use it with firebase
    [self.firebase authWithOAuthProvider:@"facebook" token:self.sessionID
                withCompletionBlock:^(NSError *error, FAuthData *authData) {
                    if (error) {
                        NSLog(@"Login failed. %@", error);
                    } else {
                        NSLog(@"Logged in!");
                        
                        //get the uid and store it
                        self.uid = [authData.auth objectForKey:@"uid"];
                    }
                }];
}


//action when the send button has been pressed, upload image to imgur
-(IBAction)sendButtonPressed:(id)sender {
    
    NSData* dataToSend = UIImagePNGRepresentation(self.drawView.image);
    
    [IMGImageRequest uploadImageWithData:dataToSend
                                   title:@"Note!"
                                 success:^(IMGImage* sentImage) {
                                     [self imageUploaded:sentImage];
                                 }
                                progress:nil
                                 failure:^(NSError* error) {
                                     [self imageFailedToUpload:error];
                                 }];
}

-(void) imageUploaded:(IMGImage*)image {
    //now that image has been uploaded, set it in firebase
    
    //check to see if user id is nil
    if(self.uid == nil) {
        //return since needs a user
        return;
    }
    
    NSDictionary *userDictionary = @{@"image" : [image.url absoluteString] };
    [self.firebase setValue:@{self.uid : userDictionary} withCompletionBlock:^(NSError *error, Firebase *ref) {
    
    }];
}

-(void) imageFailedToUpload:(NSError*)error {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
