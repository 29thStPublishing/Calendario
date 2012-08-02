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
}


-(id)init;
-(void)setFrame:(CGRect)frame;

-(void) drawDateGrid;

-(void)drawMonthTitle;


-(void)nextMonth:(id)sender;
-(void)prevMonth:(id)sender;
-(void)clearSubviews;


@end
