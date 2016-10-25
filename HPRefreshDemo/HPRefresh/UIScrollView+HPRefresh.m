//
//  UIScrollView+HPRefresh.m
//  HPRefreshDemo
//
//  Created by 付海鹏 on 2016/10/24.
//  Copyright © 2016年 Haipeng. All rights reserved.
//

#import "UIScrollView+HPRefresh.h"
#import <objc/runtime.h>
#import "HPRefreshHeader.h"

@implementation UIScrollView (HPRefresh)

- (void)addRefreshHeaderWithHandle:(void (^)())handle {
    HPRefreshHeader *header = [[HPRefreshHeader alloc] init];
    header.handle = handle;
    self.header = header;
    [self insertSubview:header atIndex:0];
}


#pragma mark - Associate

- (void)setHeader:(HPRefreshHeader *)header {
    objc_setAssociatedObject(self, @selector(header), header, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (HPRefreshHeader *)header {
    return objc_getAssociatedObject(self, @selector(header));
}

#pragma mark - Swizzle
+ (void)load {
    Method originalMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc"));
    Method swizzleMethod = class_getInstanceMethod([self class], NSSelectorFromString(@"hp_dealloc"));
    method_exchangeImplementations(originalMethod, swizzleMethod);
}

- (void)hp_dealloc {
    self.header = nil;
    [self hp_dealloc];
}

@end
