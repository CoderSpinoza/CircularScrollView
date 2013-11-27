//
//  ViewController.m
//  VideoGame
//
//  Created by Hara Kang on 2013. 11. 24..
//  Copyright (c) 2013년 CoderSpinoza. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <InfiniteScrollViewDataSource, InfiniteScrollViewDelegate, NSXMLParserDelegate>

@property (strong, nonatomic) NSIndexPath *previousIndexPath;
@property (strong, nonatomic)NSIndexPath *currentIndexPath;
@property (strong, nonatomic) AVPlayer *currentPlayer;

@property (strong, nonatomic) NSXMLParser *parser;

@property (strong, nonatomic) NSString *element;
@property (strong, nonatomic) NSDictionary *column;
@property (strong, nonatomic) NSMutableArray *row;
@property (strong, nonatomic) NSDictionary *video;
@property (strong, nonatomic) NSString *fileName;
@property (strong, nonatomic) NSString *fileExtension;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.infiniteScrollView.numRows = 3;
    self.infiniteScrollView.numColumns = 3;
    
//    self.dataArray = [[NSMutableArray alloc] initWithCapacity:3];
//    for (int i = 0; i < 3; i++) {
//        [self.dataArray addObject:[[NSMutableArray alloc] initWithCapacity:3]];
//    }
    
    
    
    // Creating a data array. Currently hardcoded. Have to import from xml or json.
//    int k;
//    for (int i = 0; i < 3; i++) {
//        k = 0;
//        for (int j = 0; j < 3; j++) {
//            NSDictionary *data;
//            if (k == 0) {
//                data = @{@"filePath": @"fire"};
//            } else if (k == 1){
//                data = @{@"filePath": @"hills"};
//            } else {
//                data = @{@"filePath": @"dancing"};
//            }
//            
//            [[self.dataArray objectAtIndex:i] insertObject:data atIndex:j];
//            k++;
//            
//        }
//    }
    
    
    self.dataArray = [[NSMutableArray alloc] init];
    
    NSString *xmlPath = [[NSBundle mainBundle] pathForResource:@"videos" ofType:@"xml"];
    NSData *xmlData = [NSData dataWithContentsOfFile:xmlPath];
    
    self.parser = [[NSXMLParser alloc] initWithData:xmlData];
    self.parser.delegate = self;
    
    self.parser.shouldResolveExternalEntities = NO;
    [self.parser parse];
    
    self.infiniteScrollView.infiniteDelegate = self;
    self.infiniteScrollView.dataSource = self;
    
//    [self.infiniteScrollView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 InfiniteScrollViewDelegate
 */
- (void)infiniteScrollView:(InfiniteScrollView *)infiniteScrollView scrolledToIndexPath:(NSIndexPath *)indexPath {
    
    self.currentIndexPath = indexPath;
    if (![self.currentIndexPath isEqual: self.previousIndexPath]) {
        
        AVPlayerView *previousView = (AVPlayerView *) [infiniteScrollView viewForIndexPath:self.previousIndexPath];
        [previousView.playerLayer removeFromSuperlayer];
        [previousView.playerLayer.player pause];
        previousView.playerLayer = nil;
        
        AVPlayerView *view = (AVPlayerView *)[infiniteScrollView viewForIndexPath:indexPath];
        NSDictionary *data = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        
        NSString *resource = [NSString stringWithFormat:@"%@", [data objectForKey:@"filePath"]];
        
        AVPlayer *player = [[AVPlayer alloc] initWithPlayerItem:[[AVPlayerItem alloc] initWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:resource ofType:@"mov"]]]];
        
        AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
        playerLayer.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        
        playerLayer.videoGravity = AVLayerVideoGravityResize;
        view.playerLayer = playerLayer;
        [view.layer addSublayer:playerLayer];
        [player play];
        
        
        self.currentPlayer = player;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidReachEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:player.currentItem];
        
    }
}

- (void)infiniteScrollView:(InfiniteScrollView *)infiniteScrollView scrolledFromIndexPath:(NSIndexPath *)indexPath {
    self.previousIndexPath = indexPath;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.currentPlayer.currentItem];
    
    
    
}


/*
 InfiniteScrollViewDataSource
 */

- (UIView *)infiniteScrollView:(InfiniteScrollView *)infiniteScrollView viewForItemAtIndexPath:(NSIndexPath *)indexPath {
    AVPlayerView *view = [[AVPlayerView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = (UIImageView *)[view viewWithTag:1];
    if (!imageView) {
        NSDictionary *data = [[self.dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@", [data objectForKey:@"filePath"]] ofType:@"mov"]] options:nil];
        AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
        UIImage *image = [UIImage imageWithCGImage:[imageGenerator copyCGImageAtTime:CMTimeMake(0, 1) actualTime:nil error:nil]];
        
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        imageView.image = image;
        imageView.tag = 1;
        
        [view addSubview:imageView];
    }
    return view;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.infiniteScrollView setNeedsDisplay];
}

- (void)playerItemDidReachEnd:(NSNotification *)notification {
    AVPlayerItem *item = notification.object;
    [item seekToTime:kCMTimeZero];
    [self.currentPlayer play];
}

/*
 NSXMLParserDelegate
 */

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    self.element = elementName;
    
    NSLog(@"%@ started", self.element);
    if ([self.element isEqualToString:@"row"]) {
        self.row = [[NSMutableArray alloc] init];
    } else if ([self.element isEqualToString:@"column"]) {
    } else if ([self.element isEqualToString:@"video"]) {
        self.video = [[NSMutableDictionary alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    NSLog(@"%@ ended", self.element);
    if ([self.element isEqualToString:@"row"]) {
        [self.dataArray addObject:self.row];
    } else if ([self.element isEqualToString:@"column"]) {
        
    } else if ([self.element isEqualToString:@"video"]) {
        self.video = @{@"fileName": self.fileName, @"fileExtension": self.fileExtension};
        [self.row addObject:self.video];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([self.element isEqualToString:@"fileName"]) {
        self.fileName = string;
    } else if ([self.element isEqualToString:@"fileExtension"]) {
        self.fileExtension = string;
    }
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    
}
- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"%@", self.dataArray);
//    [self.infiniteScrollView reloadData];
}

@end
