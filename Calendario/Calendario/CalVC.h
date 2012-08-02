//
//  CalVC.h
//  Calendario
//
//  Created by Natalie Podrazik on 8/2/12.
//  Copyright (c) 2012 29th Street Publishing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalVC : UIViewController {
    
    NSDate * activeDate;
    NSMutableArray * dateMap;
    
}


-(id)init;
-(void)setFrame:(CGRect)frame;

-(void) drawDateGrid;

-(void)drawMonthTitle;


-(void)nextMonth:(id)sender;
-(void)prevMonth:(id)sender;
-(void)clearSubviews;

+(int)monthForDate:(NSDate*)date;
+(int)yearForDate:(NSDate*)date;


+(NSString*)readableWeekdayForDate:(NSDate*)date;
+(int)weekdayForDate:(NSDate*)date;
+(NSString*)stringForDayOfWeek:(int)dayOfWeek;
+(int)numDaysInMonth:(NSDate*)date;
+(NSDate*)getFirstDayOfMonth:(NSDate*)date;
-(void)updateDateMap:(NSDate*)firstDay;

@end
