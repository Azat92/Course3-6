//
//  AppDelegate.m
//  Lesson6
//
//  Created by Azat Almeev on 25.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    UIMutableUserNotificationAction *yesAction = [UIMutableUserNotificationAction new];
    yesAction.identifier = @"yes_action_id";
    yesAction.title = @"Yes";
    yesAction.activationMode = UIUserNotificationActivationModeForeground;
    yesAction.destructive = NO;
    yesAction.authenticationRequired = NO;

    UIMutableUserNotificationAction *noAction = [UIMutableUserNotificationAction new];
    noAction.identifier = @"no_action_id";
    noAction.title = @"No";
    noAction.activationMode = UIUserNotificationActivationModeBackground;
    noAction.destructive = YES;
    noAction.authenticationRequired = YES;

    UIMutableUserNotificationAction *maybeAction = [UIMutableUserNotificationAction new];
    maybeAction.identifier = @"maybe_action_id";
    maybeAction.title = @"Maybe";
    maybeAction.activationMode = UIUserNotificationActivationModeBackground;
    maybeAction.authenticationRequired = NO;
    maybeAction.behavior = UIUserNotificationActionBehaviorTextInput;
    maybeAction.destructive = NO;
    
    // First create the category
    UIMutableUserNotificationCategory *demoCategory = [UIMutableUserNotificationCategory new];
    demoCategory.identifier = @"demo_category";
    [demoCategory setActions:@[yesAction, noAction, maybeAction] forContext:UIUserNotificationActionContextDefault];
    [demoCategory setActions:@[yesAction, maybeAction] forContext:UIUserNotificationActionContextMinimal];
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:[NSSet setWithObject:demoCategory]];
    [application registerUserNotificationSettings:mySettings];
    [application registerForRemoteNotifications];
    
    NSDictionary *notif = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    if (notif != nil) {
        //...
    }
    return YES;
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    NSLog(@"%@", notificationSettings);
//    [application currentUserNotificationSettings]
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler {
    completionHandler();
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    NSLog(@"%@, %@", identifier, userInfo);
    completionHandler();
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"%@", notification);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"%@", userInfo);
}

//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//    UILocalNotification *localNotif = [UILocalNotification new];
//    localNotif.alertBody = @"Local notification";
//    localNotif.soundName = UILocalNotificationDefaultSoundName;
//    [application cancelAllLocalNotifications];
//    [application presentLocalNotificationNow:localNotif];
//    completionHandler(UIBackgroundFetchResultNewData);
//}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Registration successful, device token: %@", deviceToken);
    const char *data = [deviceToken bytes];
    NSMutableString *token = [NSMutableString string];
    for (int i = 0; i < [deviceToken length]; i++)
        [token appendFormat:@"%02.2hhX", data[i]];
    NSLog(@"Token = %@", token);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"%@", error.localizedDescription);
}

@end
