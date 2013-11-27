//
//  ViewController.h
//  VideoGame
//
//  Created by Hara Kang on 2013. 11. 24..
//  Copyright (c) 2013년 CoderSpinoza. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfiniteScrollView.h"
#import "AVPlayerView.h"

@import AVFoundation;

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet InfiniteScrollView *infiniteScrollView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end
