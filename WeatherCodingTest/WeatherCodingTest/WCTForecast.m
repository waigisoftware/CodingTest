//
//  WCTForecast.m
//  WeatherCodingTest
//
//  Created by Can on 17/11/2015.
//  Copyright © 2015 Waigi. All rights reserved.
//

#import "WCTForecast.h"

@implementation WCTForecast

+ (nullable instancetype)forecastFromJson:(nullable NSDictionary *)json {
    WCTForecast *forecast = nil;
    
    if (json) {
        forecast = [WCTForecast new];
        if (![[json objectForKey:@"currently"] isKindOfClass:[NSNull class]]) {
            NSDictionary *currentlyJson = [json objectForKey:@"currently"];
            if (![[currentlyJson objectForKey:@"summary"] isKindOfClass:[NSNull class]]) {
                forecast.summary = [currentlyJson objectForKey:@"summary"];
            }
            if (![[currentlyJson objectForKey:@"icon"] isKindOfClass:[NSNull class]]) {
                forecast.icon = [currentlyJson objectForKey:@"icon"];
            }
            if (![[currentlyJson objectForKey:@"temperature"] isKindOfClass:[NSNull class]]) {
                forecast.temperature = [currentlyJson objectForKey:@"temperature"];
            }
        }
        if (![[json objectForKey:@"latitude"] isKindOfClass:[NSNull class]]) {
            forecast.latitude = [json objectForKey:@"latitude"];
        }
        if (![[json objectForKey:@"longitude"] isKindOfClass:[NSNull class]]) {
            forecast.longitude = [json objectForKey:@"longitude"];
        }
    }
    
    return forecast;
}

+ (void)retrieveForecastAtLatitude:(nonnull NSNumber *)latitude
                         longitude:(nonnull NSNumber *)longitude
{
    [[WCTAPIClient sharedInstance] weatherForecastAtLatitude:latitude
                                                   longitude:longitude
                                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                                         
                                                         NSDictionary *json = (NSDictionary *)responseObject;
                                                         WCTForecast *forecast = [WCTForecast forecastFromJson:json];
                                                         BOOL succeeded = forecast ? YES : NO;
                                                         NSString *errormessage = succeeded ? nil : @"Failed to get weather forecast at your location.";
                                                         
                                                         [WCTForecast postResultNotificationSucceeded:succeeded
                                                                                             forecast:forecast
                                                                                              message:errormessage];
                                                         
                                                     }
                                                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                         NSString *errormessage = [NSString stringWithFormat:@"Failed to get weather forecast at your location. \nReason : %@", error.localizedDescription];
                                                         
                                                         [WCTForecast postResultNotificationSucceeded:NO
                                                                                             forecast:nil
                                                                                              message:errormessage];
                                                     }
     ];

}

+ (void)postResultNotificationSucceeded:(BOOL) succeeded
                               forecast:(nullable WCTForecast *)forecast
                                message:(nullable NSString *)message
{
    [[NSNotificationCenter defaultCenter] postNotificationName:WCTNotificationForecastRetrieved
                                                        object:nil
                                                      userInfo:@{WCTKeySucceed : [NSNumber numberWithBool:succeeded],
                                                                 WCTKeyForecast : forecast ? : [NSNull null],
                                                                 WCTKeyErrorMessage : message ? : [NSNull null]}];
}

- (nonnull UIImage *)iconImage {
    //clear-day, clear-night, rain, snow, sleet, wind, fog, cloudy, partly-cloudy-day, or partly-cloudy-night
    UIImage *image = [UIImage imageNamed:self.icon];
    return image ? image : [UIImage imageNamed:@"unknown"];
}

- (nonnull NSString *)celsiusTemperature {
    if (self.temperature) {
        double celsiusDegree = (self.temperature.doubleValue - 32) / 1.8;

        static NSNumberFormatter *numberFormatter = nil;
        static dispatch_once_t oncetoken;
        dispatch_once(&oncetoken, ^{
            numberFormatter = [NSNumberFormatter new];
            [numberFormatter setMinimumFractionDigits:0];
            [numberFormatter setMaximumFractionDigits:1];
        });
        
        return [NSString stringWithFormat:@"%@ ℃", [numberFormatter stringFromNumber:[NSNumber numberWithDouble:celsiusDegree]]];
    }
    return @"";
}

@end
