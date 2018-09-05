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
        
        //非空数组越界导致的奔溃情况
        
    });
}


#pragma mark - 一 Private method

//向数组中插入 nil 对象导致的奔溃
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

//空数组越界导致的奔溃

//非空数组越界导致的奔溃情况

@end
