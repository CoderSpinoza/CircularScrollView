//
//  AVPlayerView.m
//  VideoGame
//
//  Created by Hara Kang on 2013. 11. 25..
//  Copyright (c) 2013년 CoderSpinoza. All rights reserved.
//

#import "AVPlayerView.h"

@implementation AVPlayerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews {
    
    [self.layer.sublayers enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CALayer *sublayer = (CALayer *)obj;
        sublayer.frame = self.bounds;
    }];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
}


@end
