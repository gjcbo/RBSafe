//
//  NSMutableDictionary+RBSafe.m
//  RBSafeExample
//
//  Created by RaoBo on 2018/9/7.
//  Copyright © 2018年 RB. All rights reserved.
//

#import "NSMutableDictionary+RBSafe.h"
#import "NSObject+RBSafe.h"


@implementation NSMutableDictionary (RBSafe)

+ (void)rb_openSafeProtector {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        
        //
        Class cls = NSClassFromString(@"__NSDictionaryM");
        
        [self rb_exchangeInstanceMethodWithClass:cls originalSel:@selector(setObject:forKeyedSubscript:) newSel:@selector(rb_setObject:forKeyedSubscript:)];
        
        [self rb_exchangeInstanceMethodWithClass:cls originalSel:@selector(setObject:forKey:) newSel:@selector(rb_setObject:forKey:)];
        
        [self rb_exchangeInstanceMethodWithClass:cls originalSel:@selector(removeObjectForKey:) newSel:@selector(rb_removeObjectForKey:)];
    });
}


- (void)rb_setObject:(id)anObj forKeyedSubscript:(id<NSCopying>)aKey {
 
    @try {
        [self rb_setObject:anObj forKeyedSubscript:aKey];
    }
    @catch (NSException *exception) {
        RBSafeProtectionCrashLog(exception, RBSafeCrashTypeNSMutableDictionary);
    }
    @finally {
    }
}

- (void)rb_setObject:(id)anObj forKey:(id<NSCopying>)akey {
    
    @try {
        [self rb_setObject:anObj forKey:akey];
    }
    @catch (NSException *exception) {
        RBSafeProtectionCrashLog(exception, RBSafeCrashTypeNSMutableDictionary);
    }
    @finally {
    }
}

- (void)rb_removeObjectForKey:(id)aKey {
    
    @try {
        [self rb_removeObjectForKey:aKey];
    }
    @catch (NSException *exception) {
        RBSafeProtectionCrashLog(exception, RBSafeCrashTypeNSMutableDictionary);
    }
    @finally {
    }
}

@end
