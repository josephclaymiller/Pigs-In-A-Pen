//
//  pigPenViewController.m
//  Pigs In A Pen
//
//  Created by Joe Miller on 1/9/13.
//  Copyright (c) 2013 Joe Miller. All rights reserved.
//

#import "pigPenViewController.h"

#define k_pig_image_name @"pig.png"
#define ANIMATION_INTERVAL 0.1f

@interface pigPenViewController ()

@end

@implementation pigPenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _pigs = [[NSMutableArray alloc] init];
    [self start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)start
{
    // Set animation timer to move the pigs
	animationTimer = [NSTimer scheduledTimerWithTimeInterval: ANIMATION_INTERVAL target: self selector: @selector(animationTimerFired:) userInfo: nil repeats: YES];
    [self addPigs:6];
}

- (void)addPigs:(int)pigs
{
    for (int i=0; i < pigs; i++) {
        [self addPig:i];
    }
}

- (void)addPig:(int)tag
{
    NSLog(@"add pig");
    NSString *pigImageName = k_pig_image_name;
    UIImage *newPigImage = [UIImage imageNamed:pigImageName];
    UIImageView *pigImageView = [[UIImageView alloc] initWithImage:newPigImage];
    // Set size and position
    float width = pigImageView.frame.size.width;
    float height = pigImageView.frame.size.height;
    int rangeX = self.view.frame.size.width - width;
    int rangeY = self.view.frame.size.height - height;
    int randomX = (arc4random() % rangeX);
    int randomY = (arc4random() % rangeY);
    //CGRectMake(x,y,width,height);
    CGRect newPigRect = CGRectMake(randomX,randomY,width,height);
    [pigImageView setFrame:newPigRect];
    // Tag pig
    pigImageView.tag = tag;
    // Move pig so it doesn't collide with other pigs
    [self movePig:pigImageView];
    // Add Image View to View Controller
    [self.view addSubview:pigImageView];
    [_pigs addObject:pigImageView];
    NSLog(@"New pig %i at x:%i y:%i",pigImageView.tag,randomX,randomY);
}

-(BOOL)pigsCollideWithPigTag:(int)pigTag withMove:(CGRect) pigMove
// Returns TRUE if collisions between pig and other pigs, FALSE otherwise
{
    for (UIImageView *otherPig in _pigs) {
        bool differentPig = otherPig.tag != pigTag;
        if(differentPig && CGRectIntersectsRect(pigMove, otherPig.frame)) {
            return TRUE;
        }
    }
    return FALSE;
}

-(BOOL)pigEscape:(CGRect) pigMove fromPen:(UIView *)pen
// Returns TRUE if pig collides with edge of pen, FALSE otherwise
{
    if(pigMove.origin.x < pen.frame.origin.x) {
        NSLog(@"pig escape to the left");
        return TRUE;
    } else if((pigMove.origin.x + pigMove.size.width) > (pen.frame.origin.x + pen.frame.size.width)) {
        NSLog(@"pig escape to the right");
        return TRUE;
    } else if(pigMove.origin.y < pen.frame.origin.y) {
        NSLog(@"pig escape up");
        return TRUE;
    } else if((pigMove.origin.y + pigMove.size.height) > (pen.frame.origin.y + pen.frame.size.height)) {
        NSLog(@"pig escape to the down");
        return TRUE;
    } else {
        return FALSE;
    }
}

- (void)movePig:(UIImageView *)pig
{  // Set size and position
    float width = pig.frame.size.width;
    float height = pig.frame.size.height;
    int rangeX = width * 2;
    int rangeY = height * 2;
    int randomX = (arc4random() % rangeX) - width + pig.frame.origin.x;
    int randomY = (arc4random() % rangeY) - height + pig.frame.origin.y;
    CGRect newPigRect = CGRectMake(randomX,randomY,width,height);
    // check that move is not collision
    while ([self pigsCollideWithPigTag:pig.tag withMove:newPigRect] || [self pigEscape:newPigRect fromPen:self.view]){
        randomX = (arc4random() % rangeX) - width + pig.frame.origin.x;
        randomY = (arc4random() % rangeY) - height + pig.frame.origin.y;
        newPigRect = CGRectMake(randomX,randomY,width,height);
        //NSLog(@"stuck in while loop");
    }
    [pig setFrame:newPigRect];
}

- (void)movePigs
{
    //NSLog(@"moving pigs");
    for (UIImageView *pig in _pigs) {
        [self movePig:pig];
    }
}

// Timer events
- (void)animationTimerFired:(NSTimer*) timer {
	//NSLog(@"Timer");
    [self movePigs];
}

@end
