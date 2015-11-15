//
//  ViewController.m
//  Lesson6
//
//  Created by Azat Almeev on 25.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "ViewController.h"
#import "NotesViewController.h"
#import "KeyChainHelper.h"

@interface ViewController () {
    BOOL *isAuthiorized;
}
@end

@implementation ViewController

-(void)viewDidLoad{
    [super viewDidLoad];
}

- (IBAction)sendLocalNotificationDidClick:(id)sender {
    if (![self searchNameInKeychain]) {
        UILocalNotification *localNotif = [UILocalNotification new];
        localNotif.fireDate = [NSDate.new dateByAddingTimeInterval:5];
        localNotif.timeZone = [NSTimeZone defaultTimeZone];
        localNotif.alertBody = @"Введите своё имя";
        localNotif.alertTitle = @"Приглашение";
        localNotif.soundName = UILocalNotificationDefaultSoundName;
        localNotif.applicationIconBadgeNumber = 1;
        localNotif.userInfo = @{ @"key" : @"value" };
        localNotif.category = @"demo_category";
        [UIApplication.sharedApplication scheduleLocalNotification:localNotif];
        return;
    }
    [self showAccessErrorAlert];
    
}

-(NSData*)searchNameInKeychain{
    return [[KeyChainHelper sharedKeyChain] find:@"USER_NAME"];
}

-(void)showAccessErrorAlert{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка"
                                                    message:@"Нет доступа"
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)NotesDidClick:(id)sender {
    NSData * data = [self searchNameInKeychain];
    NSData * rawBan = [[KeyChainHelper sharedKeyChain] find:@"BAN"];
    NSString *ban = [[NSString alloc] initWithData:rawBan encoding:NSUTF8StringEncoding];
    
    if ((data==nil) || ([ban isEqualToString:@"1"])) [self showAccessErrorAlert];
    else [self performSegueWithIdentifier:@"toNotesID" sender:self];
    
}

@end
