//
//  RootNavController.m
//  SimpleWhiteboard
//
//  Created by Kenneth Siu on 10/11/14.
//  Copyright (c) 2014 Kenneth Siu. All rights reserved.
//

#import "RootNavController.h"

@interface RootNavController ()

@end

@implementation RootNavController
@synthesize logVC, drawVC;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //initialize both login vc and draw vc
    logVC = [[LoginViewController alloc] init];
    drawVC = [[DrawViewController alloc] init];
    
    
    //now that initializing is done, set the view controller to the login view
    [self setViewControllers:@[drawVC]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
