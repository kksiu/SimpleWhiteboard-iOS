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

#define TOOLBAR_HEIGHT 50

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
//    float startHeightOfSendbutton = self.view.frame.size.height / (20.f);
//    float startWidthOfSendbutton = self.view.frame.size.width * (9.f / 10.f);
//    float heightOfSendbutton = self.view.frame.size.height / 20.0f;
//    
//    self.sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    
//    self.sendButton.frame = CGRectMake(startWidthOfSendbutton, startHeightOfSendbutton, self.view.frame.size.width - startWidthOfSendbutton, heightOfSendbutton);
//    
//    [self.sendButton setTitle:@"Send!" forState:UIControlStateNormal];
//    [self.sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [self.sendButton setBackgroundColor:[UIColor blueColor]];
//    
//    [self.view addSubview:self.sendButton];
    
    
    //set up width slider
    float sliderHeight = self.view.frame.size.height / 15.f;
    self.widthSlider = [[UISlider alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 4.f, self.view.frame.size.height -  sliderHeight, self.view.frame.size.width / (2.f), sliderHeight)];
    [self.widthSlider addTarget:self action:@selector(widthChanged:) forControlEvents:UIControlEventValueChanged];
    [self.widthSlider setHidden:YES];
    [self.widthSlider setValue:0.5f];
    [self.view addSubview:self.widthSlider];
    
    //when send button is selected, upload to imgur
    [self.sendButton addTarget:self action:@selector(sendButtonPressed:) forControlEvents:UIControlEventTouchDown];
    
    //set up toolbar
    self.toolbarArray = [[NSMutableArray alloc] init];
    UIBarButtonItem *colorItem = [[UIBarButtonItem alloc]
                                    initWithTitle:@"Color" style:UIBarButtonItemStylePlain
                                    target:self action:@selector(colorSelected:)];
    UIBarButtonItem *typeItem = [[UIBarButtonItem alloc]
                                  initWithTitle:@"Type" style:UIBarButtonItemStylePlain
                                  target:self action:@selector(typeSelected:)];
    UIBarButtonItem *widthItem = [[UIBarButtonItem alloc]
                                  initWithTitle:@"Width" style:UIBarButtonItemStylePlain
                                  target:self action:@selector(widthSelected:)];
    UIBarButtonItem *clearItem = [[UIBarButtonItem alloc]
                                 initWithTitle:@"Clear" style:UIBarButtonItemStylePlain
                                 target:self action:@selector(clearSelected:)];
    UIBarButtonItem *undoItem = [[UIBarButtonItem alloc]
                                initWithTitle:@"Undo" style:UIBarButtonItemStylePlain
                                target:self action:@selector(undoSelected:)];
    UIBarButtonItem *redoItem = [[UIBarButtonItem alloc]
                                 initWithTitle:@"Redo" style:UIBarButtonItemStylePlain
                                 target:self action:@selector(redoSelected:)];
    UIBarButtonItem *sendItem = [[UIBarButtonItem alloc]
                                 initWithTitle:@"Send!" style:UIBarButtonItemStylePlain target:self action:@selector(sendButtonPressed:)];

    //for flexible space
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                  target:nil action:nil];
    
    [self.toolbarArray addObject:flexSpace];
    [self.toolbarArray addObject:colorItem];
    [self.toolbarArray addObject:flexSpace];
    [self.toolbarArray addObject:typeItem];
    [self.toolbarArray addObject:flexSpace];
    [self.toolbarArray addObject:widthItem];
    [self.toolbarArray addObject:flexSpace];
    
    [self.toolbarArray addObject:flexSpace];
    [self.toolbarArray addObject:clearItem];
    [self.toolbarArray addObject:flexSpace];
    [self.toolbarArray addObject:undoItem];
    [self.toolbarArray addObject:flexSpace];
    [self.toolbarArray addObject:redoItem];
    [self.toolbarArray addObject:flexSpace];
    
    [self.toolbarArray addObject:flexSpace];
    [self.toolbarArray addObject:sendItem];
    [self.toolbarArray addObject:flexSpace];
    
    self.toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height, self.view.frame.size.width, TOOLBAR_HEIGHT)];
    
    [self.toolbar setItems:_toolbarArray];
    
    [self.view addSubview:self.toolbar];
    
    float startHeightOfDrawView = self.toolbar.frame.origin.y + self.toolbar.frame.size.height;
    
    //set up draw view
    self.drawView = [[ACEDrawingView alloc] initWithFrame:CGRectMake(0, startHeightOfDrawView, self.view.frame.size.width, self.view.frame.size.height - startHeightOfDrawView)];
    
    [self.view addSubview:self.drawView];
    
    //set up the alert views
    self.colorArray = @[@"Black", @"Red", @"Orange", @"Yellow", @"Green", @"Blue", @"Purple", @"Brown", @"Gray", @"Pink"];
    self.colorAlertView = [[UIAlertView alloc] initWithTitle:@"Select Color" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    
    for(NSString *color in self.colorArray) {
        [self.colorAlertView addButtonWithTitle:color];
    }
    
    //set the full allowable line width of the draw view
    self.fullLineWidth = [self.drawView lineWidth] / 0.5f;
    
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
    
    [self.view sendSubviewToBack:self.drawView];
}

#pragma mark Toolbar Selectors

-(IBAction)colorSelected:(id)sender {
    [self.colorAlertView show];
}

-(IBAction)typeSelected:(id)sender {
    
}

-(IBAction)widthSelected:(id)sender {
    [self.widthSlider setHidden:![self.widthSlider isHidden]];
}

-(IBAction)clearSelected:(id)sender {
    [self.drawView clear];
}

-(IBAction)undoSelected:(id)sender {
    [self.drawView undoLatestStep];
}

-(IBAction)redoSelected:(id)sender {
    [self.drawView redoLatestStep];
}

#pragma mark Other Selectors

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

-(IBAction)widthChanged:(id)sender {
    [self.drawView setLineWidth:[self.widthSlider value] * self.fullLineWidth];
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
