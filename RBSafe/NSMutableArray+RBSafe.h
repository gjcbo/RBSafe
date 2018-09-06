//
//  NSMutableArray+RBSafe.h
//  RBSafe
//
//  Created by RaoBo on 2018/9/5.
//  Copyright © 2018年 RaoBo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (RBSafe)

#pragma mark - 一 插入 nil 对象
/**
 1、创建时插入 nil 对象，这种情况和NSArray的解决方式是一样的、
 //插入 nil 对象 和 NSArray的的报错方式一样 [__NSPlaceholderArray initWithObjects:count:]: attempt to insert nil object
 {
 
 //        NSString *nilValue = nil;
 //        NSString *strings[3];
 //        strings[0] = @"未来简史";
 //        strings[1] = nilValue;
 //        strings[2] = @"人类简史";
 ////        NSMutableArray *arrM = [NSMutableArray arrayWithObjects:strings count:3];
 //        NSMutableArray *arrM2 = @[@"孔子",nilValue,@"老子"].mutableCopy;
 }
 
 
 
 2、使用过程中插入nil 对象
 2-1奔溃代码
 {
    NSMutableArray *arrM3 = [NSMutableArray array];
    NSString *nilValue = nil;
    [arrM3 addObject:nilValue];
 }
 
 2-2奔溃原因、底层调用代码
  -[__NSArrayM insertObject:atIndex:]: object cannot be nil'
 
 2-3防崩思路 替换上述方法
 
 */


#pragma mark - 数组越界
/**
 arr[10]  或者  [arrM objectAtIndexedSubscript:10];
 对应的底层调用代码为
 -[__NSArrayM objectAtIndexedSubscript:]: index 10 beyond bounds for empty array'
 
 
 [arrM objectAtIndex:10] 对应的底层调用代码为
 -[__NSArrayM objectAtIndex:]: index 10 beyond bounds for empty array'

 
 删除：[arrM removeObjectAtIndex:10]; 对应的底层调用代码为：
 '*** -[__NSArrayM removeObjectsInRange:]: range {10, 1} extends beyond bounds [0 .. 2]'
 
 
 
 
 替换：
 
 [arrM replaceObjectAtIndex:10 withObject:@"12月"]; 对应的底层代码是：
 -[__NSArrayM replaceObjectAtIndex:withObject:]: index 10 beyond bounds [0 .. 2]'

 
 NSString *nilValue = nil;
 [arrM replaceObjectAtIndex:10 withObject:nilValue]; 对应的底层代码是：
 
 -[__NSArrayM replaceObjectAtIndex:withObject:]: object cannot be nil'
 */

 


@end
