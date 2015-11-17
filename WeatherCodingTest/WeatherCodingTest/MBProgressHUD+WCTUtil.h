//
//  MBProgressHUD+WCTUtil.h
//  WeatherCodingTest
//
//  Created by Can on 17/11/2015.
//  Copyright © 2015 Waigi. All rights reserved.
//

@interface MBProgressHUD (WCTUtil)

+ (void)showMessage:(NSString *)message
                 in:(UIView *)view
       dismissAfter:(int)secondsDelay
           animated:(BOOL)animated;

+ (void)dismissAllModalViewInView:(UIView *)view
                         animated:(BOOL)animated;

@end
