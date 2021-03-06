//
//  MNCDetailWeatherData.m
//  WeatherForecastDemo
//
//  Created by thomasmeng on 2018/7/19.
//  Copyright © 2018年 thomasmeng. All rights reserved.
//

#import "MNCDetailWeatherData.h"
#import "MNCWeatherPropertiesFile.h"
#import "MNCHeader.h"

@interface MNCDetailWeatherData ()
@property (strong, nonatomic) MNCWeatherPropertiesFile *dataFile;
@property (strong, nonatomic) NSString *cityLatitude;     //城市纬度
@property (strong, nonatomic) NSString *cityLongitude;    //城市经度
@property (strong, nonatomic) NSString *parentCity;       //该城市的上级城市
@property (strong, nonatomic) NSString *administrationZone;   //所属行政区域
@property (strong, nonatomic) NSString *country;          //城市所属国家名称
@property (strong, nonatomic) NSString *cityTimeZone;     //城市所在时区
@property (strong, nonatomic) NSString *windDirection;    //风向
@property (strong, nonatomic) NSString *windSpeed;        //风速 公里/小时
@property (strong, nonatomic) NSString *precipitation;    //降水量
@property (strong, nonatomic) NSString *pressure;         //大气压强
@property (strong, nonatomic) NSString *visibility;       //能见度
@end

@implementation MNCDetailWeatherData

#pragma mark - Lift cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updataPropertiesFromPlist:)
                                                 name:kMNCWeatherPropertiesFileDidChangeToDetailNotification
                                               object:nil];
    
    return self;
}

#pragma mark - Overridden methods

- (NSString *)description {
    return [NSString stringWithFormat: @"location: %@, cnty: %@, tz: %@, adminArea: %@, cityLon: %@, cityLat: %@, parentCity: %@, temperatureMax: %@, hum: %@, windSpeed: %@, pres: %@, vis: %@, windDirection: %@, condTxtDay: %@, condTxtNight: %@, currentTime: %@, temperatureMin: %@, windForce: %@", self.cityName, self.country, self.cityTimeZone, self.administrationZone, self.cityLongitude, self.cityLatitude, self.parentCity, self.temperatureMax, self.humidity, self.windSpeed, self.pressure, self.visibility, self.windDirection, self.conditionDay, self.conditionNight, self.date, self.temperatureMin, self.windForce];
}

#pragma mark - Private methods

- (void)updataDetailWeatherPropertiesFromPlist {
    if (![self.dataFile.dataArray count]) {
        return;
    }
    for (NSUInteger i = 0; i < self.dataFile.dataArray.count; i ++) {
        for (NSDictionary *dict in self.dataFile.dataArray) {
            if (dict[kMNCWeatherClassifyToday]) {
                for (NSString *weatherProperty in [dict allKeys]) {
                    if ([weatherProperty isEqualToString:kMNCWeatherPropertiesFileColumnsKeyAdministrationZone]) {
                        self.administrationZone = [dict objectForKey:weatherProperty];
                    } else if ([weatherProperty isEqualToString:kMNCWeatherPropertiesFileColumnsKeyConditionDay]) {
                        self.conditionDay = [dict objectForKey:weatherProperty];
                    } else if ([weatherProperty isEqualToString:kMNCWeatherPropertiesFileColumnsKeyConditionNight]) {
                        self.conditionNight = [dict objectForKey:weatherProperty];
                    } else if ([weatherProperty isEqualToString:kMNCWeatherPropertiesFileColumnsKeyDate]) {
                        self.date = [dict objectForKey:weatherProperty];
                    } else if ([weatherProperty isEqualToString:kMNCWeatherPropertiesFileColumnsKeyWindForce]) {
                        self.windForce = [dict objectForKey:weatherProperty];
                    } else if ([weatherProperty isEqualToString:kMNCWeatherPropertiesFileColumnsKeyCityName]) {
                        self.cityName = [dict objectForKey:weatherProperty];
                    } else if ([weatherProperty isEqualToString:kMNCWeatherPropertiesFileColumnsKeyTemperatureMax]) {
                        self.temperatureMax = [dict objectForKey:weatherProperty];
                    } else if ([weatherProperty isEqualToString:kMNCWeatherPropertiesFileColumnsKeyTemperatureMin]) {
                        self.temperatureMin = [dict objectForKey:weatherProperty];
                    } else if ([weatherProperty isEqualToString:kMNCWeatherPropertiesFileColumnsKeyVisibility]) {
                        self.visibility = [dict objectForKey:weatherProperty];
                    } else if ([weatherProperty isEqualToString:kMNCWeatherPropertiesFileColumnsKeyHumidity]) {
                        self.humidity = [dict objectForKey:weatherProperty];
                    }
                }
            }
        }
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kMNCDetailDataDidChangeNotification object:self];
}

#pragma mark - Notification

- (void)updataPropertiesFromPlist:(NSNotification *)notification {
    self.dataFile = notification.object;
    [self updataDetailWeatherPropertiesFromPlist];
}



@end

