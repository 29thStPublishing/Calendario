//
//  OuterViewController.m
//  Calendario
//
//  Created by Natalie Podrazik on 8/2/12.
//  Copyright (c) 2012 29th Street Publishing. All rights reserved.
//

#import "OuterViewController.h"

#import "CalVC.h"


@implementation OuterViewController

@synthesize calendarView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        calendar = nil;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    calendar = [[CalVC alloc] init];
    
    [calendar setFrame:calendarView.frame];
    
    [calendarView addSubview:calendar.view];
    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

@end
