//
//  InputTextView.m
//  SimpleWhiteboard
//
//  Created by Kenneth Siu on 10/11/14.
//  Copyright (c) 2014 Kenneth Siu. All rights reserved.
//

#import "InputTextView.h"

@implementation InputTextView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds , 10, 10 );
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset( bounds , 10, 10 );
}

@end
