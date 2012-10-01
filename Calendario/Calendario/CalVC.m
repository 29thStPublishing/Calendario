//
//  CalVC.m
//  Calendario
//
//  Created by Natalie Podrazik on 8/2/12.
//  Copyright (c) 2012 29th Street Publishing. All rights reserved.
//

#import "CalVC.h"
#import <QuartzCore/QuartzCore.h>

#define MONTH_LABEL_HEIGHT 50


@implementation CalVC

-(id)init:(NSDate*)startingDate {
    self = [super init];
    
    if (self) {
        dateMap = nil;
        activeDate = [startingDate copy];
        chosenDate = [startingDate copy];
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

    int button_width = 25;
    int button_height = 25;
    UIButton * prevMonthButton = [[UIButton alloc] initWithFrame:CGRectMake(monthFrame.origin.x + 5, monthFrame.origin.y + 10,
                                                                            button_width, button_height)];
    
    
    [prevMonthButton addTarget:self action:@selector(prevMonth:) forControlEvents:UIControlEventTouchUpInside];                    

        
    [prevMonthButton setImage:[UIImage imageNamed:@"prev.png"] forState:UIControlStateNormal];
    
    UIButton * nextMonthButton = [[UIButton alloc] initWithFrame:CGRectMake(monthFrame.origin.x + (monthFrame.size.width - button_width) - 5,
                                                                            monthFrame.origin.y + 10, 
                                                                            button_width,
                                                                            button_height)];
    
    [nextMonthButton setImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    [nextMonthButton addTarget:self action:@selector(nextMonth:) forControlEvents:UIControlEventTouchUpInside];                    

    
    
    [self.view addSubview:prevMonthButton];
    [self.view addSubview:nextMonthButton];
    
    prevMonthButton = nil;
    nextMonthButton = nil;
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(monthFrame.origin.x + button_width,
                                                                monthFrame.origin.y,
                                                                (monthFrame.size.width - (2 * button_width)),
                                                                 monthFrame.size.height)];
    
    
    [label setBackgroundColor:[UIColor clearColor]];
    
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

-(void)clickDay:(id)sender {
    NSLog(@"Day = %d (%@)\n", [sender tag], [CalVC readableWeekdayForDate:[dateMap objectAtIndex:([sender tag] - 1)]]);
    
    chosenDate = [dateMap objectAtIndex:([sender tag] - 1)];
    
    [self drawCalendarView];
    
}


-(float)row_height {
    return [self grid_height] / NUM_ROWS;
}
-(float)col_width {
    return [self grid_width] / DAYS_IN_WEEK;
}
-(float)grid_height {
    return (self.view.frame.size.height - MONTH_LABEL_HEIGHT);
}
-(float)grid_width {
    return self.view.frame.size.width;
}
-(void) drawDateGrid {
    float grid_height = [self grid_height];
    float grid_width = [self grid_width];
    CGRect grid_boundary = CGRectMake(0, MONTH_LABEL_HEIGHT, grid_width, grid_height);
    
    float row_height = [self row_height];
    float col_width = [self col_width];
    

    UIView * gridView = [[UIView alloc] initWithFrame:grid_boundary];
    
    [gridView setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:gridView];
    
    gridView = nil;
    
    
    NSDate * firstDayOfMonth = [CalVC getFirstDayOfMonth:activeDate];
    
    [self updateDateMap:firstDayOfMonth];
      
    // Draw the header row.
    int starting_x = grid_boundary.origin.x;
    int starting_y = grid_boundary.origin.y;
    
    // drawing a border around the weekdays.
    UIView * borderview = [[UIView alloc] initWithFrame:CGRectMake(0, row_height, grid_boundary.size.width, row_height)];
    
    borderview.layer.borderColor = [UIColor grayColor].CGColor;
    borderview.layer.borderWidth = 1.0f;
    [self.view addSubview:borderview];
    borderview = nil;
    
    
    
    
    for (int i = 0; i < DAYS_IN_WEEK; i++) {        
        UILabel * dayHeader = [[UILabel alloc] initWithFrame:CGRectMake(starting_x,
                                                                      starting_y,
                                                                      col_width,
                                                                      row_height)];
        
        
        dayHeader.text = [CalVC stringForDayOfWeek:i];
        dayHeader.textAlignment = UITextAlignmentCenter;
        
        [dayHeader setBackgroundColor:[UIColor clearColor]];
        starting_x += col_width;
        
        [self.view addSubview:dayHeader];
    }
    
    
    
    
    // draw to the next row.
    starting_y = (row_height * 2);
    starting_x = 0;
    
    // adjust for zero-indexing now.
    int first_weekday = ([CalVC weekdayForDate:firstDayOfMonth] - 1);
    int num_days_in_month = [CalVC numDaysInMonth:firstDayOfMonth];
    
    
    int active_date = 1;
    
    
    activeDateView = [[UIView alloc] initWithFrame:CGRectMake(starting_x,
                                                              starting_y,
                                                              col_width,
                                                              row_height)];
    activeDateView.layer.borderColor = [UIColor purpleColor].CGColor;
    activeDateView.layer.cornerRadius = 2.0;
    activeDateView.layer.borderWidth = 1.0f;
    [activeDateView setBackgroundColor:[UIColor clearColor]];
    
    
    int active_coordinate[2];
    for (int i = 0; i < NUM_ROWS; i++) {
        
        
        // draw to the next row. -- adjust +2 for the header rows
        starting_y = row_height * (i + 2);
        starting_x = 0;
        
        int j = 0;
        
        while (j < DAYS_IN_WEEK) {
            
            
             if (((i == 0) && (j < first_weekday)) || (active_date > num_days_in_month)) {
                // do nothing
                 day_mapping[i][j] = 0;
            }
            
            else {
                
                day_mapping[i][j] = active_date;
                
                
                /*
                 UIButton * dayButton = [[UIButton alloc] initWithFrame:CGRectMake(starting_x,
                                                                                  starting_y, 
                                                                                  col_width,
                                                                                  row_height)];
                
                 */
                UITextView * dateString = [[UITextView alloc] initWithFrame:CGRectMake( //0, 5,
                                                                                       starting_x,
                                                                                       starting_y,
                                                                                       col_width,
                                                                                       row_height)];
                
                dateString.textAlignment = UITextAlignmentCenter;
                [dateString setFont:[UIFont fontWithName:@"Futura" size:12.0]];
                
                // this is the "TODAY" case.
                if ([CalVC dateIsNotEqual:firstDayOfMonth active_date:active_date date_of_comparison:[[NSDate alloc] init]]) {
                    // [dateString setBackgroundColor:[UIColor grayColor]];
                    
                    active_coordinate[0] = i;
                    active_coordinate[1] = j;
                }
                else {
                    [dateString setBackgroundColor:[UIColor clearColor]];
                }
                if ([CalVC dateIsNotEqual:firstDayOfMonth active_date:active_date date_of_comparison:chosenDate]) {

                }
                
                dateString.text = [NSString stringWithFormat:@"%d", active_date];
                
                dateString.userInteractionEnabled = NO;
                //[dayButton addSubview:dateString];
                
                //[dayButton addTarget:self action:@selector(clickDay:) forControlEvents:UIControlEventTouchUpInside];

                
                //dayButton.tag = active_date;

                
                //[self.view addSubview:dayButton];
                [self.view addSubview:dateString];
                
                dateString = nil;
                
                active_date += 1;


            }
             
            starting_x += col_width;
            j++;
        }
        

    }

    
    [self.view addSubview:activeDateView];
    
    // now that the view is drawn, add in a touch responder.
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
    [self moveSelectedDay:active_coordinate[0] col:active_coordinate[1]];
    
}


-(void)updateDateMap:(NSDate*)firstDay {
    
    
    int num_days_in_month = [CalVC numDaysInMonth:firstDay];
    
    dateMap = nil;
    
    dateMap = [[NSMutableArray alloc] initWithCapacity:num_days_in_month];
    
    NSCalendar * cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    
    for (int i = 0; i < num_days_in_month; i++) {
        
        NSDateComponents * dateComponents = [[NSDateComponents alloc] init];

        [dateComponents setDay:i];
        
        //return [cal dateFromComponents:dateComponents];
        
        /*
        [dateMap setValue:[cal dateByAddingComponents:dateComponents
                                               toDate:firstDay 
                                              options:0] for;
         */
        [dateMap insertObject:[cal dateByAddingComponents:dateComponents
                                           toDate:firstDay 
                                          options:0] atIndex:i];
    }
}

-(void)moveSelectedDay:(int)row col:(int)col {
    
    NSLog(@"(moveSelectedDay) row = %d, col = %d\n", row, col);
    float calculated_x = col * [self col_width];// row * [self col_width];
    float calculated_y = (row + 2) * [self row_height]; //(col + 2) * [self row_height];
    
    
    [activeDateView setFrame:CGRectMake(calculated_x,
                                        calculated_y,
                                        activeDateView.frame.size.width,
                                        activeDateView.frame.size.height)];
    
    NSLog(@"Moved active day to (%.2f, %.2f)\n", calculated_x, calculated_y);
}

+(NSString*)stringForDayOfWeek:(int)dayOfWeek {
    switch(dayOfWeek){
        case 0:
            return @"S";
            break;
        case 1:
            return @"M";
            break;        
        case 2:
            return @"T";
            break;        
        case 3:
            return @"W";
            break;        
        case 4:
            return @"T";
            break;        
        case 5:
            return @"F";
            break;        
        case 6:
            return @"S";
            break;        
        default:
            return @"?";
    }
}

+(int)yearForDate:(NSDate*)date {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@ "YYYY"];    
    
    //[formatter setTimeZone:<#(NSTimeZone *)#>
    
    
    NSString * dateString = [formatter stringFromDate:date];
    
    
    formatter = nil;
        
    return [dateString intValue];
}

+(int)monthForDate:(NSDate*)date {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@ "MM"];        
    
    NSString * dateString = [formatter stringFromDate:date];
    
    
    formatter = nil;
    
    
    return [dateString intValue];
}

+(int)dayForDate:(NSDate*)date {
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@ "dd"];        
    
    NSString * dateString = [formatter stringFromDate:date];
    
    
    formatter = nil;
    
    
    return [dateString intValue];
}

+(NSString*)readableWeekdayForDate:(NSDate*)date {
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@ "EEEE, MMMM dd, YYYY"];    
    
    NSString * dateString = [formatter stringFromDate:date];
    
    
    formatter = nil;
    
    return dateString;

    
}
+(int)weekdayForDate:(NSDate*)date {
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@ "e"];    
    
    NSString * dateString = [formatter stringFromDate:date];
    
    
    formatter = nil;
    
    return [dateString intValue];    
}

+(int)numDaysInMonth:(NSDate*)date {
    
    NSCalendar * cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSRange days = [cal rangeOfUnit:NSDayCalendarUnit 
                           inUnit:NSMonthCalendarUnit 
                          forDate:date];
    
    
    cal = nil;
    
    return days.length;
    
    
}

+(NSDate*)getFirstDayOfMonth:(NSDate*)date {
    NSCalendar * cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    // NSDateComponents * components = [[NSDateComponents alloc] init];

    NSDateComponents * dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:[CalVC monthForDate:date]];
    [dateComponents setYear:[CalVC yearForDate:date]];

    return [cal dateFromComponents:dateComponents];

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

+(BOOL)dateIsNotEqual:(NSDate*)firstDayOfMonth active_date:(int)active_date date_of_comparison:(NSDate*)date_of_comparison {
    //NSDate * today = [[NSDate alloc] init];
    

    
    
    if (([CalVC monthForDate:date_of_comparison] != [CalVC monthForDate:firstDayOfMonth]) ||
        ([CalVC yearForDate:date_of_comparison] != [CalVC yearForDate:firstDayOfMonth])) {
        return NO;
    }
    
    NSCalendar * cal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents * dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:(active_date - 1)];
    

    NSDate * actualDate = [cal dateByAddingComponents:dateComponents toDate:firstDayOfMonth options:0];
    
    dateComponents = nil;
    
    if ([CalVC dayForDate:actualDate] == [CalVC dayForDate:date_of_comparison]) {
        return YES;
    }
    
    return NO;
}


-(void)tapped:(UITapGestureRecognizer*)sender {
    
    CGPoint tapPoint = [sender locationInView:self.view];
    
    CGPoint tapPointInView = [self.view convertPoint:tapPoint toView:self.view];
    
    
    NSLog(@"Tapped! tapPoint = (%.2f, %.2f), tapPointInView = (%.2f, %.2f)\n",
            tapPoint.x, tapPoint.y,
            tapPointInView.x, tapPointInView.y);
    
    
    // calculate which row and column they wanted to tap in.
    int col_width = (self.view.frame.size.width / (int) DAYS_IN_WEEK);
    int row_height = [self row_height];
    
    NSLog(@"Row cutoff is %d, col cutoff is %d\n", col_width, row_height);
    
    int col = tapPoint.x / col_width;
    int row = (tapPoint.y / row_height - 2); // subtract 2 to ignore the two header rows.
    
    NSLog(@"I think that's (%d, %d).\n", row, col);
    NSLog(@"..and that day = %d\n", day_mapping[row][col]);

    [self moveSelectedDay:row col:col];
}
@end
