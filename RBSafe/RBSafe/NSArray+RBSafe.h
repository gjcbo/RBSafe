//
//  NSArray+RBSafe.h
//  RBSafe
//
//  Created by RaoBo on 2018/8/24.
//  Copyright © 2018年 RaoBo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (RBSafe)
//NSArray常见导致奔溃的原因
/**
 1. 访问数组时，数组越界
 2. 创建数组时，插入 nil 对象
 */



#pragma mark - 一  创建数组时：有 nil 对象
//插入nil对象奔溃。
/**
 1、可能导致奔溃的代码
 
 //数组插入nil对象
 NSString *nilValue = nil;
 
 NSString *strings[3];
 strings[0] = @"张三";
 strings[1] = nilValue;
 
 [NSArray arrayWithObjects:strings count:2];
 NSArray *arr1 = @[@"张三",nilValue];
 
 
 2、奔溃原因、底层调用的方法是：reason: '*** -[__NSPlaceholderArray initWithObjects:count:]: attempt to insert nil object from objects[1]'
 
 3、避免奔溃：交换 __NSPlaceholderArray 这个类的 initWithObjects:count 这个方法。
 */

#pragma mark - 二 数组越界
/**
 1、数组越界: (空数组越界，非空数组越界) 底层调用的方法不一样
 
 2、奔溃原因：reason:
 2-1空数组越界 可能导致奔溃的代码、
 NSArray *arr1 = @[];
 //[arr1 objectAtIndex:4];
 NSLog(@"%@",arr1[0]);
 
 空数组越界 奔溃原因
 @[] -[__NSArray0 objectAtIndex:]: index 0 beyond bounds for empty NSArray'
 
 
 
 
 2-2非空数组越界 可能导致崩溃的代码
 NSArray *arr1 = @[@"杭州",@"武汉",@"成都"];
 // NSLog(@"%@",arr1[3]);
 [arr1 objectAtIndex:3];
 
 非空数组越界 奔溃原因
 '*** -[__NSArrayI objectAtIndexedSubscript:]: index 3 beyond bounds [0 .. 2]
 
 3、避免奔溃思路： 使用 runtime 对上述类和方法做方法交换
 
 4、TODO list: 关于不同系统版本，奔溃信息不一致的情况，目前没有测试出来。
 */


@end
