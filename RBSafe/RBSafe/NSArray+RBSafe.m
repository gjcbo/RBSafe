//
//  NSArray+RBSafe.m
//  RBSafe
//
//  Created by RaoBo on 2018/8/24.
//  Copyright © 2018年 RaoBo. All rights reserved.
//

#import "NSArray+RBSafe.h"
#import "NSObject+RBSafe.h"
@implementation NSArray (RBSafe)
+ (void)rb_openSafeProtector {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //向数组中插入 nil 对象导致的奔溃
        [self rb_exchangeInstanceMethodWithClass:objc_getClass("__NSPlaceholderArray") originalSel:@selector(initWithObjects:count:) newSel:@selector(rb_initWithObjects:count:)];
        
        //空数组越界导致的奔溃
        [self rb_exchangeInstanceMethodWithClass:objc_getClass("__NSArray0") originalSel:@selector(objectAtIndex:) newSel:@selector(rb_objectAtIndex0:)];
        
        
        //非空数组越界导致的奔溃情况0:  arr[10]
        [self rb_exchangeInstanceMethodWithClass:objc_getClass("__NSArrayI") originalSel:@selector(objectAtIndexedSubscript:) newSel:@selector(rb_objectAtIndexedSubscriptI:)];
        
        //非空数组越界导致的奔溃情况2:   [arr1 objectAtIndex:3];
        [self rb_exchangeInstanceMethodWithClass:objc_getClass("__NSArrayI") originalSel:@selector(objectAtIndex:) newSel:@selector(rb_objectAtIndexI:)];
        
    });
}


#pragma mark - 一 Private method

//1、向数组中插入 nil 对象导致的奔溃
- (instancetype)rb_initWithObjects:(id _Nonnull const [])objects count:(NSUInteger)cnt {
    
    id instance = nil;
    
    @try {
       instance = [self rb_initWithObjects:objects count:cnt];
    }
    @catch(NSException *exception) {
        
        RBSafeProtectionCrashLog(exception, RBSafeCrashTypeNSArray);
        
        //错误处理: 去掉 nil 数据, 然后重新初始化数组
        NSInteger newIndex = 0;
        id newObjs[cnt];
        
        for (int i=0; i<cnt; i++) {
            if (objects[i] != nil) {
                newObjs[newIndex] = objects[i];
                newIndex++;
            }
        }
        
        instance = [self rb_initWithObjects:newObjs count:newIndex];
    }
    @finally {
        return instance;
    }
}

//2、空数组越界导致的奔溃
- (id)rb_objectAtIndex0:(NSUInteger)index {
    id object = nil;

    @try {
        object = [self rb_objectAtIndex0:index];
        
    }
    @catch(NSException *exception) {
        //回调异常
        RBSafeProtectionCrashLog(exception, RBSafeCrashTypeNSArray);
    }
    @finally {
        return object;
    }
}

//3、非空数组越界导致的奔溃情况0: arr[10]
- (id)rb_objectAtIndexedSubscriptI:(NSUInteger)index {
    
    id objc  =nil;
    
    @try {
        objc = [self rb_objectAtIndexedSubscriptI:index];
    }
    @catch(NSException *exception) {
        RBSafeProtectionCrashLog(exception, RBSafeCrashTypeNSArray);
    }
    @finally {
        return objc;
    }
}

//4、非空数组越界导致的奔溃情况1: [arr1 objectAtIndex:3];

- (id)rb_objectAtIndexI:(NSUInteger)index {
    id obj = nil;
    
    @try {
        obj = [self rb_objectAtIndexI:index];
    }
    @catch(NSException *exception) {
        //回调异常。
        RBSafeProtectionCrashLog(exception, RBSafeCrashTypeNSArray);
    }
    @finally {
        return obj;
    }
}

@end
