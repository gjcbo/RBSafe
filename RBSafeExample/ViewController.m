//
//  ViewController.m
//  RBSafeExample
//
//  Created by RaoBo on 2018/9/6.
//  Copyright © 2018年 RB. All rights reserved.
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
        //        [arrM3 addObject:nilValue];
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
        //        [arrM objectAtIndex:10];
        //        [arrM objectAtIndexedSubscript:10];
        
        //        [arrM removeObjectAtIndex:10];
        [arrM replaceObjectAtIndex:10 withObject:@"12月"];
        //        NSString *nilValue = nil;
        //        [arrM replaceObjectAtIndex:10 withObject:nilValue];
    }
}

#pragma mark - 四 NSDictionary 常见奔溃

- (IBAction)testNSDictionary:(id)sender {
    //    NSLog(@"点击了 %d 行",__LINE__);
    //key 为 nil
    
    NSString *nilKey = nil;
    NSString *nilValue = nil;
    
    {
        //key 为 nil 会导致奔溃
        //        NSDictionary *dic2 = @{@"name":@"今日简史",nilKey:@58.0,@"author":@"赫拉利"};
        
        //value 为 nil 会导致奔溃
        NSDictionary *dic3 = @{@"name":@"今日简史",@"price":nilKey ,@"author":@"赫拉利"};
    }
}

#pragma mark - 五 NSMutableDictionary 常见奔溃

- (IBAction)testNSMutableDic:(id)sender {
    
    //正常情况
    {
//        NSMutableDictionary *dicM = [[NSMutableDictionary alloc] initWithObjects:@[@"张三",@"18",@"男"] forKeys:@[@"name",@"age",@"gender"]];
//        NSLog(@"%@",dicM);
    }
    
    
    
    NSString *nilKey = nil;
    //key 为 nil 导致的奔溃。
    {
        //这种方式首先会导致数的奔溃(插入nil值)、其次才是字典导致的奔溃。
//        NSMutableDictionary *dicM = [[NSMutableDictionary alloc] initWithObjects:@[@"张三",@"18",@"男"] forKeys:@[@"name",@"age",nilKey]];
//        NSLog(@"%@",dicM);
    }
   
    
    //key 为nil 导致奔溃
    {
        NSString *nilKey = nil;
        NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
//        dic1[nilKey] = @""; //会导致奔溃 ❌
        //奔溃信息 -[__NSDictionaryM setObject:forKeyedSubscript:]: key cannot be nil'
        
        
        
        //以下三种方式导致的奔溃信息是一样的。(底层调用的是同一个方法)
//        [dic1 setValue:@"九月" forKey:nilKey]; //KVC key为nil会导致奔溃 ❌
//        [dic1 setObject:@"九月" forKey:nilKey]; //会导致奔溃 ❌
        // -[__NSDictionaryM setObject:forKey:]: key cannot be nil'
        
        
        NSString *nilValue = nil;
//        [dic1 setObject:nilValue forKey:@"month"]; //会导致奔溃 ❌
        // [__NSDictionaryM setObject:forKey:]: object cannot be nil (key: month)'
        // -[__NSDictionaryM setObject:forKey:]: key cannot be nil'
    }
    
    
    //value 为 nil 不会导致奔溃
    {
        NSString *nilValue = nil;
        NSMutableDictionary *dic1=[NSMutableDictionary dictionary];
        dic1[@"d"] = nilValue;
    }
    
    
    // removeObjectForkey 时 key 为 nil 导致的奔溃。
    {
        NSString *nilKey = nil;
        NSMutableDictionary *dicM = @{@"name":@"RB",@"age":@"18",@"gender":@"man"}.mutableCopy;
        
        [dicM removeObjectForKey:nilKey]; // 会导致奔溃 ❌
        // -[__NSDictionaryM removeObjectForKey:]: key cannot be nil'
    }
}

@end

