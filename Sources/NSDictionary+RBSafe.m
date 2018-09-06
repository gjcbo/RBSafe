//
//  NSDictionary+RBSafe.m
//  RBSafe
//
//  Created by RaoBo on 2018/9/6.
//  Copyright © 2018年 RaoBo. All rights reserved.
//

#import "NSDictionary+RBSafe.h"
#import "NSObject+RBSafe.h"

@implementation NSDictionary (RBSafe)
+ (void)rb_openSafeProtector {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self rb_exchangeInstanceMethodWithClass:NSClassFromString(@"__NSPlaceholderDictionary") originalSel:@selector(initWithObjects:forKeys:count:) newSel:@selector(rb_initWithObjects:forKeys:count:)];
        
        [self rb_exchangeInstanceMethodWithClass:NSClassFromString(@"__NSPlaceholderDictionary")  originalSel:@selector(initWithObjects:forKeys:) newSel:@selector(rb_initWithObjects:forKeys:)];
    });
}


-(instancetype)rb_initWithObjects:(NSArray *)objects forKeys:(NSArray<id<NSCopying>> *)keys
{
    id instance = nil;
    @try {
        instance = [self rb_initWithObjects:objects forKeys:keys];
    }
    @catch (NSException *exception) {
        
        RBSafeProtectionCrashLog(exception, RBSafeCrashTypeNSDictionary);
        //处理错误的数据，重新初始化一个字典
        NSUInteger count=MIN(objects.count, keys.count);
        NSMutableArray *newObjects=[NSMutableArray array];
        NSMutableArray *newKeys=[NSMutableArray array];
        for (int i = 0; i < count; i++) {
            if (objects[i] && keys[i]) {
                [newObjects addObject:objects[i]];
                [newKeys addObject:keys[i]];
            }
        }
        instance = [self rb_initWithObjects:newObjects forKeys:newKeys];
    }
    @finally {
        return instance;
    }
}
-(instancetype)rb_initWithObjects:(id  _Nonnull const [])objects forKeys:(id<NSCopying>  _Nonnull const [])keys count:(NSUInteger)cnt
{
    
    id instance = nil;
    @try {
        instance = [self rb_initWithObjects:objects forKeys:keys count:cnt];
    }
    @catch (NSException *exception) {
        
        RBSafeProtectionCrashLog(exception, RBSafeCrashTypeNSDictionary);
        
        //处理错误的数据，重新初始化一个字典
        NSUInteger index = 0;
        id   newObjects[cnt];
        id   newkeys[cnt];
        
        for (int i = 0; i < cnt; i++) {
            if (objects[i] && keys[i]) {
                newObjects[index] = objects[i];
                newkeys[index] = keys[i];
                index++;
            }
        }
        instance = [self rb_initWithObjects:newObjects forKeys:newkeys count:index];
    }
    @finally {
        return instance;
    }
}

@end
