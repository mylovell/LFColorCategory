//
//  LFViewController.m
//  LFColorCategory
//
//  Created by mylovell on 06/04/2019.
//  Copyright (c) 2019 mylovell. All rights reserved.
//

#import "LFViewController.h"
#import "UIView+LFAnimation.h"

@interface LFViewController ()

@end

@implementation LFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor orangeColor];
    
    UIView *redV = [[UIView alloc] initWithFrame:CGRectMake(30, 90, 100, 100)];
    redV.backgroundColor = [UIColor redColor];
    [self.view addSubview:redV];
    
    [redV addAnimationForRotation];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
