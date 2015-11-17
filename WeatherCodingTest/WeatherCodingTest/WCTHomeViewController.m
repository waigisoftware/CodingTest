//
//  WCTHomeViewController.m
//  WeatherCodingTest
//
//  Created by Can on 17/11/2015.
//  Copyright © 2015 Waigi. All rights reserved.
//

#import "WCTHomeViewController.h"
#import "WCTForecast.h"

@interface WCTHomeViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

@property (strong, nonatomic) NSObject *forecastRetrievedObserver;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation WCTHomeViewController


#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self resetUI];
    [self setupLocationManager];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // add observer
    [self addForecastRetrievedObserver];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // remove observer
    [[NSNotificationCenter defaultCenter] removeObserver:self.forecastRetrievedObserver];
}

#pragma mark - setup

- (void)setupLocationManager {
    _locationManager = [CLLocationManager new];
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManager.delegate = self;
    [_locationManager requestWhenInUseAuthorization];
    [_locationManager startUpdatingLocation];
}

#pragma mark - Observers

- (void)addForecastRetrievedObserver {
    self.forecastRetrievedObserver = [[NSNotificationCenter defaultCenter] addObserverForName:WCTNotificationForecastRetrieved
                                                                                       object:nil
                                                                                        queue:[NSOperationQueue mainQueue]
                                                                                   usingBlock:^(NSNotification *notification) {
                                                                                       [self handleForecastRetrievedNotification:notification];
                                                                                   }];
}

#pragma mark - UI update

- (void)resetUI {
    _iconImageView.image = [UIImage imageNamed:@"unknown"];
    _temperatureLabel.text = @"";
    _summaryLabel.text = @"";
}

- (void)handleForecastRetrievedNotification:(NSNotification *)notification {
    [MBProgressHUD dismissAllModalViewInView:self.view animated:YES];
    
    NSDictionary *result = [notification userInfo];
    if (result) {
        BOOL succeeded = [result objectForKey:WCTKeySucceed];
        
        // do UI update accordingly
        if (succeeded) {
            WCTForecast *forecast = [result objectForKey:WCTKeyForecast];
            _iconImageView.image = forecast.iconImage;
            _temperatureLabel.text = forecast.celsiusTemperature;
            _summaryLabel.text = forecast.summary;
        } else {
            NSString *message = [result objectForKey:WCTKeyErrorMessage];
            [self resetUI];
            
            [MBProgressHUD showMessage:message
                                    in:self.view
                          dismissAfter:3
                              animated:YES];
        }
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [WCTForecast retrieveForecastAtLatitude:[NSNumber numberWithDouble:manager.location.coordinate.latitude]
                                      longitude:[NSNumber numberWithDouble:manager.location.coordinate.longitude]];
        
        [MBProgressHUD showMessage:@"Loading weather forecast"
                                in:self.view
                      dismissAfter:3000
                          animated:YES];
    });
    
    // stop updating once got a location
    [_locationManager stopUpdatingLocation];
}

@end
