//
//  MBProgressHUD+WCTUtil.m
//  WeatherCodingTest
//
//  Created by Can on 17/11/2015.
//  Copyright © 2015 Waigi. All rights reserved.
//

#import "MBProgressHUD+WCTUtil.h"

@implementation MBProgressHUD (WCTUtil)

+ (void)showMessage:(NSString *)message
                 in:(UIView *)view
       dismissAfter:(int)secondsDelay
           animated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
        hud.mode = MBProgressHUDModeText;
        hud.labelText = message;
        hud.margin = 10.f;
        hud.yOffset = 150.f;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES afterDelay:secondsDelay];
    });
}

+ (void)dismissAllModalViewInView:(UIView *)view
                         animated:(BOOL)animated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:view animated:animated];
    });
}

@end
