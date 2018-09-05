//
//  ViewController.m
//  RBSafe
//
//  Created by RaoBo on 2018/8/24.
//  Copyright © 2018年 RaoBo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>


- (void)getName;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

#pragma mark - 常见奔溃问题
//1.方法找不到
- (IBAction)unrecognizeSelector:(id)sender {
    //    [self getName];
    
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
//        NSLog(@"%@",arr1[3]);
        [arr1 objectAtIndex:3];
    }
    
}





//#pragma mark - 一 数组奔溃
//- (void)testNSArray {
//    //1. 数组越界
////    NSArray *arr1 = @[@"蝶恋花"];
//
////    NSLog(@"%@",arr1[2]); //reason: '*** -[__NSSingleObjectArrayI objectAtIndex:]: index 2 beyond bounds [0 .. 0]'
////    [arr1 objectAtIndex:2]; //reason: '*** -[__NSSingleObjectArrayI objectAtIndex:]: index 2 beyond bounds [0 .. 0]'
//
//    //2. 插入 nil 对象
//    NSString *value = nil;
//    NSString *strings[2];
//    strings[0] = @"张三";
//    strings[1] = value;
//
//    NSArray *arr2 = [NSArray arrayWithObjects:strings count:2]; //reason: '*** -[__NSPlaceholderArray initWithObjects:count:]: attempt to insert nil object from objects[1]'
//
//}

@end
