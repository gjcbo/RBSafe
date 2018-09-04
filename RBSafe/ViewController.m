//
//  ViewController.m
//  RBSafe
//
//  Created by RaoBo on 2018/8/24.
//  Copyright © 2018年 RaoBo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

- (void)getName;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
//#define NSLog(FORMAT, ...)
    
//    fprintf(stderr,"%s:%d\t\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

   
}

- (IBAction)unrecognizeSelector:(id)sender {
    [self getName];
}


//#pragma mark - 一 数组奔溃
//- (void)testNSArray {
//    //1. 数组越界
////    NSArray *arr1 = @[@"蝶恋花"];
//
////    NSLog(@"%@",arr1[2]); //reason: '*** -[__NSSingleObjectArrayI objectAtIndex:]: index 2 beyond bounds [0 .. 0]'
////    [arr1 objectAtIndex:2]; //reason: '*** -[__NSSingleObjectArrayI objectAtIndex:]: index 2 beyond bounds [0 .. 0]'
//
//    //2. 插入 nil 对象
//    NSString *value = nil;
//    NSString *strings[2];
//    strings[0] = @"张三";
//    strings[1] = value;
//
//    NSArray *arr2 = [NSArray arrayWithObjects:strings count:2]; //reason: '*** -[__NSPlaceholderArray initWithObjects:count:]: attempt to insert nil object from objects[1]'
//
//}

@end
