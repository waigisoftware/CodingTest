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
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (strong, nonatomic) NSObject *forecastRetrievedObserver;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) BOOL allowRetrieveForecast;

- (IBAction)onRefresh:(id)sender;

@end

@implementation WCTHomeViewController


#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _allowRetrieveForecast = YES;
    
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
    _temperatureLabel.text = nil;
    _summaryLabel.text = nil;
    _messageLabel.text = nil;
}

- (void)handleForecastRetrievedNotification:(NSNotification *)notification {
    [MBProgressHUD dismissAllModalViewInView:self.view animated:YES];
    
    NSDictionary *result = [notification userInfo];
    if (result) {
        BOOL succeeded = [(NSNumber *)[result objectForKey:WCTKeySucceed] boolValue];
        
        // do UI update accordingly
        if (succeeded) {
            WCTForecast *forecast = [result objectForKey:WCTKeyForecast];
            _iconImageView.image = forecast.iconImage;
            _temperatureLabel.text = forecast.celsiusTemperature;
            _summaryLabel.text = forecast.summary;
            _messageLabel.text = nil;
        } else {
            [self resetUI];
            NSString *message = [result objectForKey:WCTKeyErrorMessage];
            _messageLabel.text = message;
        }
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    if (_allowRetrieveForecast) {
        _allowRetrieveForecast = NO;
        [WCTForecast retrieveForecastAtLatitude:[NSNumber numberWithDouble:manager.location.coordinate.latitude]
                                      longitude:[NSNumber numberWithDouble:manager.location.coordinate.longitude]];
        
        [MBProgressHUD showMessage:@"Loading weather forecast"
                                in:self.view
                      dismissAfter:30
                          animated:YES];
    }
    
    // stop updating once got a location
    [_locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    [self resetUI];
    _allowRetrieveForecast = YES;
    
    [[[UIAlertView alloc] initWithTitle:@"Failed to get your location"
                                message:@"Please enable location service in setting."
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles: nil] show];
}

#pragma mark - Button action

- (IBAction)onRefresh:(id)sender {
    [self resetUI];
    _allowRetrieveForecast = YES;
    [_locationManager startUpdatingLocation];
}

@end
