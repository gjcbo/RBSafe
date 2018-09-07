//
//  NSMutableDictionary+RBSafe.h
//  RBSafeExample
//
//  Created by RaoBo on 2018/9/7.
//  Copyright © 2018年 RB. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (RBSafe)
//key 为nil 会导致奔溃(赋值时、删除元素时)
//value 为nil时 设值时会导致奔溃。

// key 为 nil 导致奔溃
// 导致奔溃的代码： dic1[nilKey] = @"";
//奔溃信息 -[__NSDictionaryM setObject:forKeyedSubscript:]: key cannot be nil'



// 导致奔溃的代码 (三种写法导致的奔溃信息是一样的)
//[dic1 setValue:@"九月" forKey:nilKey]; //KVC key为nil会导致奔溃 ❌
//[dic1 setObject:@"九月" forKey:nilKey]; //会导致奔溃 ❌
//[dic1 setObject:nilValue forKey:@"month"]; //会导致奔溃 ❌

//奔溃信息:
// -[__NSDictionaryM setObject:forKey:]: key cannot be nil'
// -[__NSDictionaryM setObject:forKey:]: object cannot be nil (key: month)'


//导致奔溃的代码
//[dicM removeObjectForKey:nilKey]; // 会导致奔溃 ❌

//奔溃信息: -[__NSDictionaryM removeObjectForKey:]: key cannot be nil'





@end
