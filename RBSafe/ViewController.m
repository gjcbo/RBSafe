//
//  ViewController.m
//  RBSafe
//
//  Created by RaoBo on 2018/8/24.
//  Copyright © 2018年 RaoBo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
- (void)getName;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - 一 方法找不到问题
//1.方法找不到
- (IBAction)unrecognizeSelector:(id)sender {
        [self getName];
}

#pragma mark - 二 NSArray 常见奔溃
- (IBAction)testArray:(id)sender {
    
    //数组掺入nil对象
    //    {
    //        NSString *nilValue = nil;
    //
    //        NSString *strings[3];
    //        strings[0] = @"张三";
    //        strings[1] = nilValue;
    //
    ////        [NSArray arrayWithObjects:strings count:2];
    //        NSArray *arr1 = @[@"张三",nilValue];
    //    }
    
    //数组越界
    {
        //        NSArray *arr1 = @[];
        //        //[arr1 objectAtIndex:4];
        //        NSLog(@"%@",arr1[0]);
        
        NSArray *arr1 = @[@"杭州",@"武汉",@"成都"];
        // NSLog(@"%@",arr1[3]);
        [arr1 objectAtIndex:3];
    }
}

#pragma mark - 三 NSMutableArray相关奔溃

- (IBAction)testNSMutableArray:(id)sender {
   
    //1.插入 nil 对象
    {
        NSMutableArray *arrM3 = [NSMutableArray array];
        NSString *nilValue = nil;
        [arrM3 addObject:nilValue];
    }
    
    //2.越界
    {
        NSMutableArray *arrM = [NSMutableArray array];
//        arrM[10];
//        [arrM objectAtIndex:10];
        
        for (int i = 0; i<3; i++) {
            [arrM addObject:[NSString stringWithFormat:@"%d月",i+1]];
        }
//        NSLog(@"%@",arrM[10]);
        [arrM objectAtIndex:10];
        [arrM objectAtIndexedSubscript:10];
        
        [arrM removeObjectAtIndex:10];
        [arrM replaceObjectAtIndex:10 withObject:@"12月"];
        NSString *nilValue = nil;
        [arrM replaceObjectAtIndex:10 withObject:nilValue];

    }
    
}

#pragma mark - 四 NSDictionary 常见奔溃
#pragma mark - 五 NSMutableDictionary 常见奔溃




@end
