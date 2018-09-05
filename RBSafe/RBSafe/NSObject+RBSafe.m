//
//  NSObject+RBSafe.m
//  RBSafe
//
//  Created by RaoBo on 2018/8/24.
//  Copyright © 2018年 RaoBo. All rights reserved.
//  参考了一下开源库
//https://github.com/chenfanfang/AvoidCrash
// 

#import "NSObject+RBSafe.h"

static RBSafeLogType rb_safeLogType = RBSafeLogTypeAll;
static RBSafeBlock rb_safeBlock;


/**作用:用来解决 unrecognize selector sent to xxxx的奔溃问题*/
@interface RBSafeProxy:NSObject
@property (nonatomic, strong) NSException *exception;
@property (nonatomic, weak) id safe_objc;
@end
@implementation RBSafeProxy
- (void)rb_printCrashLog { }
@end


@implementation NSObject (RBSafe)

+ (void)rb_openSafeProtector {
    //基类调此方法，用于解决 unrecognize selector sent to xxxx的奔溃问题。
    //子类完全重写该方法
    // 只有是NSObject的时候才做操作。
    if ([NSStringFromClass([NSObject class]) isEqualToString:@"NSObject"]) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{

            [self rb_exchangeInstanceMethodWithClass:[self class] originalSel:@selector(methodSignatureForSelector:) newSel:@selector(rb_methodSignatureForSelector:)];
            
            [self rb_exchangeInstanceMethodWithClass:[self class] originalSel:@selector(forwardInvocation:) newSel:@selector(rb_forwardInvocation:)];
        });
    }else {
        // 只有是NSObject的时候才做操作。
    }
}


+ (void)rb_openAllSafeWithIsDebug:(BOOL)isDebug block:(RBSafeBlock)block {
  
    if ([NSStringFromClass([self class]) isEqualToString:@"NSObject"]) {
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
           
            [NSObject rb_openSafeProtector];
            [NSArray rb_openSafeProtector];
            [NSMutableArray rb_openSafeProtector];
        });
        
        if (isDebug) { //YES 闪退、并打印奔溃信息
            rb_safeLogType = RBSafeLogTypeAll;
        }else { //NO  不闪退、不打印奔溃信息
            rb_safeLogType = RBSafeLogTypeNone;
        }
        rb_safeBlock = block;
        
    }else {
        RBSafeLog(@"----- 请使用 [NSObject rb_openAllSafeWithIsDebug: block:] 调用此方法");
    }
}


#pragma mark - 一 方法交换: 公用方法
//交换类方法
+ (void)rb_exchangeClassMethodWithClass:(Class)cls originalSel:(SEL)originalSel newSel:(SEL)newSel{
    //1.获取类 Method
    Method originMethod = class_getClassMethod(cls, originalSel);
    Method newMethod = class_getClassMethod(cls, newSel);
    
    //2.获取方法实现
    IMP newImp = method_getImplementation(newMethod);
    IMP originImp = method_getImplementation(originMethod);
    
    //3.获取类型编码
    const char *newTypeEncoding = method_getTypeEncoding(newMethod);
    const char *originTypeEncoding = method_getTypeEncoding(newMethod);
    
    //4.给类对象动态添加方法
    //YES: 原方法没有方法的实现  NO:有方法的实现
    BOOL isAdd = class_addMethod(cls, originalSel, newImp, newTypeEncoding);
    
    if (isAdd) {
        class_replaceMethod(cls, newSel, originImp, originTypeEncoding);
    }else {
        //添加失败：说明原方法不存在，尝试添加被替换的方法的实现
        method_exchangeImplementations(originMethod, newMethod);
    }
}

//交换对象方法
+ (void)rb_exchangeInstanceMethodWithClass:(Class)cls originalSel:(SEL)originalSel newSel:(SEL)newSel{
    //1.获取对象 Method
    Method originMethod = class_getInstanceMethod(cls, originalSel);
    Method newMethod = class_getInstanceMethod(cls, newSel);
    
    //2.获取方法的IMP
    IMP originIMP = method_getImplementation(originMethod);
    IMP newIMP = method_getImplementation(newMethod);

    //3.获取方法的类型编码
    const char *originTypeEncoding = method_getTypeEncoding(originMethod);
    const char *newTypeEncoding = method_getTypeEncoding(newMethod);
    
    BOOL isAdd = class_addMethod(cls, originalSel, newIMP, newTypeEncoding);
    
    if (isAdd) {
        class_replaceMethod(cls, newSel, originIMP, originTypeEncoding);
    }else {
        method_exchangeImplementations(originMethod, newMethod);
    }
}


#pragma mark - 二 方法签名+消息转发
//当发生 unrecognize selector sent to xxxx 最终会调用methodSignatureForSelector:(SEL)aSelector 和 forwardInvocation:(NSInvocation *)anInvocation
- (NSMethodSignature *)rb_methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *ms = [self rb_methodSignatureForSelector:aSelector];
    
    if ([self respondsToSelector:aSelector]) {
        return ms;
    }else {
        return [RBSafeProxy instanceMethodSignatureForSelector:@selector(rb_printCrashLog)];
    }
}

- (void)rb_forwardInvocation:(NSInvocation *)anInvocation {
    @try {
        [self rb_forwardInvocation:anInvocation];
    }
    @catch (NSException *exception) {
        //打印奔溃信息
        
        RBSafeProtectionCrashLog(exception, RBSafeCrashTypeSelector);
    }
    @finally {
    }
}


+ (void)rb_printCrashLogWithException:(NSException *)exception crashType:(RBSafeCrashType)crashType  {
    //1.获取堆栈数组
    NSArray *callStackSymbolArr = [NSThread callStackSymbols];
    
    //2.正则匹配 
    NSString *mainMsg = [self rb_getMainCallStackSymbolMessageWithCallStackSymbolString:callStackSymbolArr[2]];
    
    if (mainMsg == nil) {
        mainMsg = @"奔溃方法定位失败,请查看函数调用栈查找crash原因";
    }
    
    NSString *crashName = [NSString stringWithFormat:@"\t\t[Crash Type]: %@",exception.name];
    NSString *crashReason = [NSString stringWithFormat:@"\t\t[Crash Reason]:%@",exception.reason];
    NSString *crashLocation = [NSString stringWithFormat:@"\t\t[Crash Location]: %@",mainMsg];
    
    NSString *fullMsg = [NSString stringWithFormat:@"\n-------------------------------------Crash Start-------------------------------------\n%@\n%@\n%@\n函数堆栈:\n%@\n-------------------------------------Crash End-------------------------------------",crashName, crashReason,crashLocation,exception.callStackSymbols];
    
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[@"callStackSymbols"] = [NSString stringWithFormat:@"%@",exception.callStackSymbols];
    userInfo[@"location"] = mainMsg;
    
    NSException *newException = [NSException exceptionWithName:exception.name reason:exception.reason userInfo:userInfo];
    
    //回调异常
    if (rb_safeBlock) {
        rb_safeBlock(newException,crashType);
    }
    
    RBSafeLogType logtype = rb_safeLogType;
    if (logtype == RBSafeLogTypeNone) { //如果isDebug = NO 不闪退、不打印奔溃信息
        NSLog(@"11111");
    }else if (logtype == RBSafeLogTypeAll) { //如果是 YES ，（是否闪退：看具体的方法实现）打印崩溃信息。
        RBSafeLog(@"%@",fullMsg);
        //NSAssert 的使用 https://www.jianshu.com/p/526dfd5cbb19
        //条件是反着的。
        NSAssert(NO, @"检查到崩溃,请查看上面的详细信息");
        NSLog(@"222222");
    }
}

#pragma mark - 三 Private method 正则匹配，简化堆栈信息
+ (NSString *)rb_getMainCallStackSymbolMessageWithCallStackSymbolString:(NSString *)callStackString {
    
    //格式为： +[类名 方法名]  -[类名  方法名]
    __block NSString *mainCallStackSymbolMsg = nil;
    
    //正则表达式
    NSString *regularExpString = @"[-\\+]\\[.+\\]";
    
    NSRegularExpression *regularExp = [[NSRegularExpression alloc] initWithPattern:regularExpString options:(NSRegularExpressionCaseInsensitive) error:nil];
    
    [regularExp enumerateMatchesInString:callStackString options:NSMatchingReportProgress range:NSMakeRange(0, callStackString.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
    
        if (result) {
            mainCallStackSymbolMsg = [callStackString substringWithRange:result.range];
            
            *stop = YES;
        }
    }];
    
    return mainCallStackSymbolMsg;
}


@end
