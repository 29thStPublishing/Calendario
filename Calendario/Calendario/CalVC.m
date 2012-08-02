//
//  CalVC.m
//  Calendario
//
//  Created by Natalie Podrazik on 8/2/12.
//  Copyright (c) 2012 29th Street Publishing. All rights reserved.
//

#import "CalVC.h"

#define MONTH_LABEL_HEIGHT 50

@implementation CalVC

-(id)init {    
    self = [super init];
    
    if (self) {
        
    }
       
    
    return self;
}

-(void)setFrame:(CGRect)frame {
    
    int buffer = 10;

    CGRect adjustedFrame = CGRectMake(buffer, buffer, frame.size.width - (buffer * 2),
                                      frame.size.height - (buffer * 2));
    [self.view setFrame:adjustedFrame];
    
    
    NSLog(@"in initializer, self.view.frame.size.width = %.2f\n", self.view.frame.size.width);
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidLoad];
    
    
    activeDate = [[NSDate alloc] init];

    [self drawCalendarView];
}

-(void)clearSubviews {
    // if there are any subviews within the scrollview, clear them.
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    viewsToRemove = nil;
}

-(void)drawCalendarView {
    // draw the month first.
    
    [self clearSubviews];
    
    [self drawMonthTitle];
    
    [self drawDateGrid];
    
}

-(void)drawMonthTitle {
    NSLog(@"self.view.frame.size.width = %.2f\n", self.view.frame.size.width);
    
    CGRect monthFrame = CGRectMake(0, 0, 
                            self.view.frame.size.width, MONTH_LABEL_HEIGHT);

    int button_width = 50;
    UIButton * prevMonthButton = [[UIButton alloc] initWithFrame:CGRectMake(monthFrame.origin.x, monthFrame.origin.y, button_width, monthFrame.size.height)];
    
    
    [prevMonthButton addTarget:self action:@selector(prevMonth:) forControlEvents:UIControlEventTouchUpInside];                    

    
    prevMonthButton.titleLabel.text = @"P";
    
    UIButton * nextMonthButton = [[UIButton alloc] initWithFrame:CGRectMake(monthFrame.origin.x + (monthFrame.size.width - button_width),
                                                                            monthFrame.origin.y, 
                                                                            button_width,
                                                                            monthFrame.size.height)];
    
    nextMonthButton.titleLabel.text = @"N";
    [nextMonthButton addTarget:self action:@selector(nextMonth:) forControlEvents:UIControlEventTouchUpInside];                    

    
    
    [self.view addSubview:prevMonthButton];
    [self.view addSubview:nextMonthButton];
    
    prevMonthButton = nil;
    nextMonthButton = nil;
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(monthFrame.origin.x + button_width,
                                                                monthFrame.origin.y,
                                                                (monthFrame.size.width - (2 * button_width)),
                                                                 monthFrame.size.height)];
    
    
    [label setBackgroundColor:[UIColor yellowColor]];
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@ "MMMM YYYY"];    
    
    //[formatter setTimeZone:<#(NSTimeZone *)#>
    
    
    NSString * dateString = [formatter stringFromDate:activeDate];
    
    label.text = dateString;
    label.textAlignment = UITextAlignmentCenter;
    
    
    [self.view addSubview:label];
    
    label = nil;
}

-(void)nextMonth:(id)sender {
    
    NSCalendar * cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents * components = [[NSDateComponents alloc] init];
    
    components.month = 1;
    
    activeDate = [cal dateByAddingComponents:components toDate:activeDate options:0];
    
    [self drawCalendarView];
}

-(void)prevMonth:(id)sender {
    
    NSCalendar * cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents * components = [[NSDateComponents alloc] init];
    
    components.month = -1;
    
    activeDate = [cal dateByAddingComponents:components toDate:activeDate options:0];
    
    [self drawCalendarView];
    
}

-(void) drawDateGrid {
    CGRect grid_boundary = CGRectMake(0, MONTH_LABEL_HEIGHT, self.view.frame.size.width, (self.view.frame.size.height - MONTH_LABEL_HEIGHT));
    
    
    UIView * gridView = [[UIView alloc] initWithFrame:grid_boundary];
    
    [gridView setBackgroundColor:[UIColor greenColor]];
    
    [self.view addSubview:gridView];
    
    gridView = nil;
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end
