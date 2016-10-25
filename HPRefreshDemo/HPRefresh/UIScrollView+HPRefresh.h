//
//  UIScrollView+HPRefresh.h
//  HPRefreshDemo
//
//  Created by 付海鹏 on 2016/10/24.
//  Copyright © 2016年 Haipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HPRefreshHeader;

@interface UIScrollView (HPRefresh)

@property (nonatomic, strong) HPRefreshHeader *header;

- (void)addRefreshHeaderWithHandle:(void(^)())handle;

@end
