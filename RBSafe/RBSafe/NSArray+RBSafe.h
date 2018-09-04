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
//不同的iOS版本，底层调用的方法会有所不同。
//比如国际化 取出来的值也是不一样的。

/**
 数组越界
 arr[10];
 [arr objectAtIndexPath:10];
 
 iOS 8、9、10、11    [__NSSingleObjectArrayI objectAtIndex:]
 */





/**
 插入 nil 对象
 __NSPlaceholderArray
 reason: '*** -[__NSPlaceholderArray initWithObjects:count:]: attempt to insert nil object from objects[1]'
 */





@end
