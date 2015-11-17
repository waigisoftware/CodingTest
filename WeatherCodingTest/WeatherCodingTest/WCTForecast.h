//
//  WCTForecast.h
//  WeatherCodingTest
//
//  Created by Can on 17/11/2015.
//  Copyright © 2015 Waigi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCTForecast : NSObject

@property (strong, nonatomic, nullable) NSString *summary;
@property (strong, nonatomic, nullable) NSString *icon;
@property (strong, nonatomic, nullable) NSNumber *temperature;
@property (strong, nonatomic, nonnull) NSNumber *latitude;
@property (strong, nonatomic, nonnull) NSNumber *longitude;

- (nonnull UIImage *)iconImage;

// convert Fahrenheit to Celsius
- (nonnull NSString *)celsiusTemperature;

+ (nullable instancetype)forecastFromJson:(nullable NSDictionary *)json;

/**
 * Retrieve weather forcast from server and notify result
 * @param latitude geographic coordinates of a location in decimal degrees
 * @param longitude geographic coordinates of a location in decimal degrees
 */
+ (void)retrieveForecastAtLatitude:(nonnull NSNumber *)latitude
                         longitude:(nonnull NSNumber *)longitude;

@end
