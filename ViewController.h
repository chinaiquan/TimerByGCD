//
//  ViewController.h
//  TimerByDispatch
//
//  Created by chi on 2020/6/18.
//  Copyright © 2020 chi-ios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property UILabel *timeLabel;

@property UIButton *button;
@property UIButton *continueButton;
@property UILabel *toast;

@property dispatch_source_t gcdTimer;
@property BOOL timerState;

@end

