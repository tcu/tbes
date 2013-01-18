//
//  TConnectionDetailsController.m
//  TBES
//
//  Created by Danny Westfall on 1/9/13.
//  Copyright (c) 2013 TCU. All rights reserved.
//

#import "TConnectionDetailsController.h"
#include <sstream>

@interface TConnectionDetailsController(){
    NSTimer* updateConnectionDetailsTimer;
    NSDate* connectedTime;
    NSString* connectedHost;
}

@end

@implementation TConnectionDetailsController

-(void) OnUpdateDetails: (id) sender{
    
    NSDate* startDate = connectedTime;
	NSDate *endDate = [NSDate date];
    NSTimeInterval lastDiff = [endDate timeIntervalSinceNow];
    NSTimeInterval todaysDiff = [startDate timeIntervalSinceNow];
    NSTimeInterval dateDiff = lastDiff - todaysDiff;
    float seconds = dateDiff;
    int days = seconds / 86400;
    int days_seconds = 86400 * days;
    seconds = seconds - days_seconds;
    int hours = seconds / 3600;
    int hours_seconds = 3600 * hours;
    seconds = seconds - hours_seconds;
    int minutes = seconds / 60;
    int minutes_seconds = 60 * minutes;
    seconds = seconds - minutes_seconds;
    
    TLog(@"Days: %d", days);
    TLog(@"Hours: %d", hours);
    TLog(@"Minutes: %d", minutes);
    TLog(@"Seconds: %f", seconds);
    
    std::stringstream stream;
    
    if(days > 0){
        stream << days << " Days ";
    }
    if(hours > 0){
        stream << hours << " Hours ";
    }
    if(minutes > 0){
        stream << minutes << " Minutes ";
    }
    
    stream << (int) seconds << " Seconds ";
    
    connectionTimeLabel.text = [NSString stringWithCString: stream.str().c_str() encoding: NSUTF8StringEncoding];
    connectionServerLabel.text = connectedHost;
}

-(void) showConnectionDetails: (NSDate*) date: (NSString*) hostName{
    updateConnectionDetailsTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(OnUpdateDetails:) userInfo:nil repeats:YES];
    connectedTime = date;
    connectedHost = hostName;
}

@end
