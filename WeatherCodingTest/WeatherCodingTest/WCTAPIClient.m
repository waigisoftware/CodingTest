//
//  WCTAPIClient.m
//  WeatherCodingTest
//
//  Created by Can on 17/11/2015.
//  Copyright © 2015 Waigi. All rights reserved.
//

#import "WCTAPIClient.h"

@implementation WCTAPIClient

+ (instancetype)sharedInstance {
    static WCTAPIClient *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [WCTAPIClient new];
    });
    
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:ForecastAPIBaseUrl]];
    }
    return self;
}

- (void)weatherForecastAtLatitude:(NSNumber *)latitude
                        longitude:(NSNumber *)longitude
                          success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSString *url = [NSString stringWithFormat:@"%@,%@", latitude, longitude];
    
    // request with AFNetworking
    [self.sessionManager GET:url
                  parameters:nil
                     success:success
                     failure:failure];
}

@end
