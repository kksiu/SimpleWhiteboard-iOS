//
//  DrawViewController.m
//  SimpleWhiteboard
//
//  Created by Kenneth Siu on 10/11/14.
//  Copyright (c) 2014 Kenneth Siu. All rights reserved.
//

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
}


//action when the send button has been pressed, upload image to imgur
-(IBAction)sendButtonPressed:(id)sender {
    
    NSData* dataToSend = UIImagePNGRepresentation(self.drawView.image);
    
    [IMGImageRequest uploadImageWithData:dataToSend title:@"Note!" success:^(IMGImage* sentImage) {
        NSLog(@"%@", [sentImage.url absoluteString]); }
                                progress:nil failure:^(NSError* error) {
                                    NSLog(@"ERROR");
                                }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
