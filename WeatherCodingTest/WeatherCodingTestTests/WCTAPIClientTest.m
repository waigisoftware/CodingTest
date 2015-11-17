//
//  WCTForecastModelTest.m
//  WeatherCodingTest
//
//  Created by Can on 17/11/2015.
//  Copyright © 2015 Waigi. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCTAPIClient.h"
#import "WCTForecast.h"

@interface WCTForecastModelTest : XCTestCase

@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;

@end

@implementation WCTForecastModelTest
- (void)setUp {
    [super setUp];
    
    // Sydney latitude & longitude
    self.latitude = [NSNumber numberWithDouble:-33.878344];
    self.longitude = [NSNumber numberWithDouble:151.213748];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRestfulServiceCall {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Service Call Finished Expectation"];
    
    [[WCTAPIClient sharedInstance] weatherForecastAtLatitude:self.latitude
                                                   longitude:self.longitude
                                                     success:^(NSURLSessionDataTask *task, id responseObject) {
                                                         
                                                         NSDictionary *json = (NSDictionary *)responseObject;
                                                         WCTForecast *forecast = [WCTForecast forecastFromJson:json];
                                                         
                                                         XCTAssertNotNil(responseObject);
                                                         XCTAssertNotNil(forecast);
                                                         XCTAssertEqualObjects([json objectForKey:@"timezone"], @"Australia/Sydney");
                                                         [expectation fulfill];
                                                         
                                                     }
                                                     failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                     }
     ];
     
     [self waitForExpectationsWithTimeout:60.0 handler:^(NSError *error) {
        if(error) {
            XCTFail(@"Expectation Failed due to timeout with error: %@", error);
        }
    }];
}

@end
