//
//  NSMutableArray+RBSafe.m
//  RBSafe
//
//  Created by RaoBo on 2018/9/5.
//  Copyright © 2018年 RaoBo. All rights reserved.
//

#import "NSMutableArray+RBSafe.h"
#import "NSObject+RBSafe.h"

@implementation NSMutableArray (RBSafe)


+ (void)rb_openSafeProtector {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        
        //注意: 是 objc_getClass 不是 object_getClass
//        Class cls = object_getClass(@"__NSArrayM"); ❌
//        Class cls = objc_getClass("__NSArrayM");
        Class cls = NSClassFromString(@"__NSArrayM");
        
        
        //交换可能会导致奔溃的系统方法
        
        [self rb_exchangeInstanceMethodWithClass:cls originalSel:@selector(insertObject:atIndex:) newSel:@selector(rb_insertObject:atIndex:)];
        
        [self rb_exchangeInstanceMethodWithClass:cls originalSel:@selector(objectAtIndexedSubscript:) newSel:@selector(rb_objectAtIndexedSubscript:)];
        
        [self rb_exchangeInstanceMethodWithClass:cls originalSel:@selector(objectAtIndex:) newSel:@selector(rb_objectAtIndex:)];
        
        [self rb_exchangeInstanceMethodWithClass:cls originalSel:@selector(removeObjectAtIndex:) newSel:@selector(rb_removeObjectAtIndex:)];
        
        [self rb_exchangeInstanceMethodWithClass:cls originalSel:@selector(replaceObjectAtIndex:withObject:) newSel:@selector(rb_replaceObjectAtIndex:withObject:)];
    
    });
}


//1.插入 nil 对象
- (void)rb_insertObject:(id)anObjc atIndex:(NSUInteger)index {
    @try {
        [self rb_insertObject:anObjc atIndex:index];
    }
    @catch (NSException *exception) {
        RBSafeProtectionCrashLog(exception, RBSafeCrashTypeNSMutableArray);
    }
    @finally {
        
    }
}

//2.数组越界-1
- (id) rb_objectAtIndexedSubscript:(NSUInteger)index {
    id object = nil;
    
    @try {
        object = [self rb_objectAtIndexedSubscript:index];
    }
    @catch (NSException *exception) {
        RBSafeProtectionCrashLog(exception, RBSafeCrashTypeNSMutableArray);
    }
    @finally {
        return object;
    }
}

//2.数组越界-2
- (id) rb_objectAtIndex:(NSUInteger)index {
    id object = nil;
    
    @try {
        object = [self rb_objectAtIndex:index];
    }
    @catch (NSException *exception) {
        RBSafeProtectionCrashLog(exception, RBSafeCrashTypeNSMutableArray);
    }
    @finally {
        //方法有返回值，记得要 return
        return object;
    }
}

//2.数组越界-3 删除元素越界
- (void)rb_removeObjectAtIndex:(NSUInteger)index {
    @try {
        [self rb_removeObjectAtIndex:index];
    }
    @catch (NSException *exception) {
        RBSafeProtectionCrashLog(exception, RBSafeCrashTypeNSMutableArray);
    }
    @finally {
        
    }
}

//2.数组越界-4 替换数组元素时越界 || 替换数组时传入 nil 对象
- (void)rb_replaceObjectAtIndex:(NSUInteger)index withObject:(id)objc {
    @try {
        [self rb_replaceObjectAtIndex:index withObject:objc];
    }
    @catch (NSException *exception) {
        RBSafeProtectionCrashLog(exception, RBSafeCrashTypeNSMutableArray);
    }
    @finally {
        
    }
}

@end
