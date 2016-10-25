//
//  HPRefreshHeader.h
//  HPRefreshDemo
//
//  Created by 付海鹏 on 2016/10/24.
//  Copyright © 2016年 Haipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HPRefreshHeader : UIView

@property (nonatomic, copy) void(^handle)();

- (void)endRefreshing;

@end
