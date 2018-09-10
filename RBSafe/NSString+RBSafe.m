//
//  NSString+RBSafe.m
//  RBSafeExample
//
//  Created by RaoBo on 2018/9/10.
//  Copyright © 2018年 RB. All rights reserved.
//

#import "NSString+RBSafe.h"
#import "NSObject+RBSafe.h"
@implementation NSString (RBSafe)
+ (void)rb_openSafeProtector {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class cls = NSClassFromString(@"__NSCFConstantString");
        
        //前缀、后缀 有 nil 值导致的崩溃
        [self rb_exchangeInstanceMethodWithClass:cls originalSel:@selector(hasPrefix:) newSel:@selector(rb_hasPrefix:)];
        
        [self rb_exchangeInstanceMethodWithClass:cls originalSel:@selector(hasSuffix:) newSel:@selector(rb_hasSuffix:)];
    });
}

- (void)rb_hasPrefix:(NSString *)str {
    
    @try {
        [self rb_hasPrefix:str];
    }
    @catch (NSException *exception) {
        RBSafeProtectionCrashLog(exception, RBSafeCrashTypeNSString);
    }
    @finally {
    }
}

- (void)rb_hasSuffix:(NSString *)str {
    @try {
        [self rb_hasSuffix:str];
    }
    @catch (NSException *exception) {
        RBSafeProtectionCrashLog(exception, RBSafeCrashTypeNSString);        
    }
    @finally {
    }
}
@end
