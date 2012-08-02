//
//  OuterViewController.h
//  Calendario
//
//  Created by Natalie Podrazik on 8/2/12.
//  Copyright (c) 2012 29th Street Publishing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalVC;
@interface OuterViewController : UIViewController {
    CalVC * calendar;
}


@property (weak, nonatomic) IBOutlet UIView *calendarView;


@end
