//
//  ViewController.m
//  Lesson6
//
//  Created by Azat Almeev on 25.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@end

@implementation ViewController

- (IBAction)sendLocalNotificationDidClick:(id)sender {
    UILocalNotification *localNotif = [UILocalNotification new];
    localNotif.fireDate = [NSDate.new dateByAddingTimeInterval:5];
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    localNotif.alertBody = @"This is a local notification";
    localNotif.alertTitle = @"Hello!";
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    localNotif.applicationIconBadgeNumber = 1;
    localNotif.userInfo = @{ @"key" : @"value" };
    localNotif.category = @"demo_category";
    [UIApplication.sharedApplication scheduleLocalNotification:localNotif];
}

@end
