//
//  ViewController.m
//  DataTigerDemo
//
//  Created by BruceZCQ on 5/22/15.
//  Copyright (c) 2015 BruceZCQ. All rights reserved.
//

#import "ViewController.h"
#import <DataTiger/DataTiger.h>


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Tiger authWithAppkey:@"41acc3b9dc86a3fa946dd03c6d81a36a"];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(100, 100, 100, 100);
    button.backgroundColor = [UIColor redColor];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(log) forControlEvents:UIControlEventTouchUpInside];
}

- (void)log
{
    [Tiger logDataWithCore:@"zcq" data:@"{\"name\":\"name_data\",\"address\":\"address_data\"}"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
