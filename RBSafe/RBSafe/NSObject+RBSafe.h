//
//  NSObject+RBSafe.h
//  RBSafe
//
//  Created by RaoBo on 2018/8/24.
//  Copyright © 2018年 RaoBo. All rights reserved.
//

#import <Foundation/Foundation.h>
#define  RBSafeLog(fmt, ...)  NSLog(fmt, ##__VA_ARGS__)
#define  LSSafeProtectionCrashLog(exception,crash) [NSObject rb_printCrashLogWithException:exception crashType:crash]

//fprintf(stderr,"%s:%d\t\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);


//打印log类型
typedef NS_ENUM(NSInteger, RBSafeLogType) {
    RBSafeLogTypeNone, //所有log都不打印
    RBSafeLogTypeAll   //打印所有log
};


//奔溃类型
typedef NS_ENUM(NSInteger, RBSafeCrashType) {
    RBSafeCrashTypeSelector = 0,
    RBSafeCrashTypeKVO,
    RBSafeCrashTypeNSArray,
    RBSafeCrashTypeNSMutableArray,
    RBSafeCrashTypeNSDictionary,
    RBSafeCrashTypeNSMutableDictionary,
    RBSafeCrashTypeNSString,
    RBSafeCrashTypeNSMutableString,
};

//异常的block回调
typedef void(^RBSafeBlock)(NSException *exception, RBSafeCrashType carshType);


@interface NSObject (RBSafe)
/**打开目前支持的所有防止crash的安全保护，回调block*/
+ (void)rb_openAllSafeWithIsDebug:(BOOL)isDebug block:(RBSafeBlock)block;


/**打开当前类的安全保护, 交给子类去重写*/
+ (void)rb_openSafeProtector;


#pragma mark - 方法交换 swizzing
/**交换类方法*/
+ (void)rb_exchangeClassMethodWithClass:(Class)cls originalSel:(SEL)originalSel newSel:(SEL)newSel;

/**交换对象方法*/
+ (void)rb_exchangeInstanceMethodWithClass:(Class)cls originalSel:(SEL)originalSel newSel:(SEL)newSel;

/**打印crash的堆栈信息*/
+ (void)rb_printCrashLogWithException:(NSException *)exception crashType:(RBSafeCrashType)carshType;
@end
