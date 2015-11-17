//
//  WCTAPIClient.h
//  WeatherCodingTest
//
//  Created by Can on 17/11/2015.
//  Copyright © 2015 Waigi. All rights reserved.
//

@interface WCTAPIClient : NSObject

@property(strong) AFHTTPSessionManager* sessionManager;

+ (instancetype)sharedInstance;

- (void)weatherForecastAtLatitude:(NSNumber *)latitude
                        longitude:(NSNumber *)longitude
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

@end
