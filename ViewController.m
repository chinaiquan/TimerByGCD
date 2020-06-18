//
//  ViewController.m
//  TimerByDispatch
//
//  Created by chi on 2020/6/18.
//  Copyright © 2020 chi-ios. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //timeLabel
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 200, 250, 120)];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    //self.timeLabel.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.timeLabel];
    
    //toast
    self.toast = [[UILabel alloc] initWithFrame:CGRectMake(90, 500, 250, 80)];
    self.toast.backgroundColor = [UIColor grayColor];
    self.toast.textAlignment = NSTextAlignmentCenter;
    self.toast.text = @"Clock will stop in 2 seconds!";
    
    //button
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(90, 321, 250, 80)];
    [self.button setTitle:@"STOP" forState:UIControlStateNormal];
    self.button.backgroundColor = [UIColor redColor];
    [self.button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(stopClockInTwoSecond:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    
    //continueButton
    self.continueButton = [[UIButton alloc] initWithFrame:CGRectMake(90, 400, 250, 80)];
    [self.continueButton setTitle:@"Continue" forState:UIControlStateNormal];
    self.continueButton.backgroundColor = [UIColor yellowColor];
    [self.continueButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.continueButton addTarget:self action:@selector(continueClock:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.continueButton];
    //gcdTimer
    self.gcdTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(self.gcdTimer, DISPATCH_TIME_NOW, 1.0*NSEC_PER_SEC, 0.0*NSEC_PER_SEC);
    dispatch_source_set_event_handler(self.gcdTimer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDate *date = [NSDate date];
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *components;
            components = [calendar components:NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date];
                        
            self.timeLabel.text = [NSString stringWithFormat:@"%ld时%ld分%ld秒",components.hour,components.minute,components.second];
            [self.view addSubview:self.timeLabel];
        });
    
    });
    
   dispatch_resume(self.gcdTimer);
    self.timerState = YES;
}

-(void)stopClockInTwoSecond:(id)selector {
    if(self.timerState) {
        [self.view addSubview:self.toast];
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 2.0*NSEC_PER_SEC);
        //NSLog(@"touch button");
        dispatch_after(time, dispatch_get_main_queue(), ^{
            //NSLog(@"2 seconds later");
            dispatch_suspend(self.gcdTimer);
            self.timerState = NO;
            [self.toast removeFromSuperview];
    });
    
    }
}

-(void)continueClock:(id)selector {
    if(!self.timerState) {
        dispatch_resume(self.gcdTimer);
        self.timerState = YES;
    }
}

@end
