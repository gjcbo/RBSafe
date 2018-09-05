//
//  NSObject+RBSafe.h
//  RBSafe
//
//  Created by RaoBo on 2018/8/24.
//  Copyright © 2018年 RaoBo. All rights reserved.
//

#import <Foundation/Foundation.h>
//在这里引入runtime头文件，省的在每个分类中都要引入一次。
#import <objc/runtime.h>

//#define  RBSafeLog(fmt, ...)  NSLog(fmt, ##__VA_ARGS__)
#define  RBSafeLog(fmt, ...) fprintf(stderr,"%s:%d\t\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:fmt, ##__VA_ARGS__] UTF8String]);

#define  RBSafeProtectionCrashLog(exception,crashtype) [NSObject rb_printCrashLogWithException:exception crashType:crashtype]


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
/**
 打开目前支持的所有防止crash的安全保护，block回调异常信息

 @param isDebug ✅上线时请传:NO ,开发时请随意 NO:不闪退、不打印奔溃信息; YES:闪退、打印奔溃信息。内部是通过NSAssert来实现的
 @param block 回调异常信息
 */
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
