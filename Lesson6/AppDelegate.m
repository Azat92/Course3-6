//
//  AppDelegate.m
//  Lesson6
//
//  Created by Azat Almeev on 25.10.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "AppDelegate.h"
#import <MagicalRecord/MagicalRecord+Setup.h>
#import <MagicalRecord/MagicalRecord.h>
#import "Note+CoreDataProperties.h"
#import "Comment+CoreDataProperties.h"
#import "KeyChainHelper.h"
#import "NotesViewController.h"

#if DEBUG
#import "UIApplication+SimulatorRemoteNotifications.h"
#endif

#define ROOTVIEW [[[UIApplication sharedApplication] keyWindow] rootViewController]

#define kNewComment @"Новый комментарий"
#define kInvite @"Приглашение"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"Cache.sqlite"];
    
    //   [self deleteAllCache];
    [self addTestObjects];
    
    [self setupNotifications];
//    
//#if DEBUG
//    [application listenForRemoteNotifications];
//#endif
    
    if (launchOptions!=nil) {
        NSDictionary *lNotification = launchOptions[UIApplicationLaunchOptionsLocalNotificationKey];
        NSDictionary *rNotification = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
        
        
        if (lNotification != nil) {
            NSLog(@"LNOTIFY:%@",lNotification);
        }
        if (rNotification != nil) {
            NSLog(@"RNOTIFY:%@",rNotification);
        }
        
    }
    return YES;
}


-(void)addTestObjects{
    if ([Note MR_numberOfEntities]>0) return;
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        Note *n1 = [Note MR_createEntityInContext:localContext];
        Note *n2 = [Note MR_createEntityInContext:localContext];
        n1.noteID = @"1";
        n2.noteID = @"2";
        n1.name = @"firstNote";
        n2.name = @"secondNote";
        n1.text = @"gsdhjgdskj";
        n2.text = @"bkjdfgskllksd";
        n1.date = [NSDate date];
        n2.date = [NSDate date];
        
        Comment *c1 = [Comment MR_createEntityInContext:localContext];
        Comment *c2 = [Comment MR_createEntityInContext:localContext];
        c1.userID = @"1";
        c2.userID = @"2";
        c1.text = @"kdsfkdjsffjklhfs";
        c2.text = @"bkd;fgosnjfklsnfhkajfilhkjceflkshjfjbksjhdkbcjsfbkesj,hbfhjsdhfbdshjbfsdfjdsfbsdnjlfks";
        c1.date = [NSDate date];
        c2.date = [NSDate date];
        c1.theNote = n1;
        c2.theNote = n2;
        
        NSMutableSet *n1Comments = [n1 mutableSetValueForKey:@"comments"];
        NSMutableSet *n2Comments = [n2 mutableSetValueForKey:@"comments"];
        [n1Comments addObject:c1];
        [n2Comments addObject:c2];
    } completion:^(BOOL success, NSError *error) {
        NSLog(@"added");
    }];
    
}

-(void)deleteAllCache{
    [Note MR_deleteAllMatchingPredicate:[NSPredicate predicateWithFormat:@"name != 'vcfvdg'"]];
    [Comment MR_deleteAllMatchingPredicate:
     [NSPredicate predicateWithFormat:@"userID != 'bexlc'"]];
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        NSLog(@"SAVED? %i",contextDidSave);
    }];
    
}

-(void)setupNotifications{
    
    UIMutableUserNotificationAction *openAction = [UIMutableUserNotificationAction new];
    openAction.identifier = @"fullResponse";
    openAction.title = @"Open";
    openAction.activationMode = UIUserNotificationActivationModeForeground;
    openAction.destructive = NO;
    openAction.authenticationRequired = NO;
    
    UIMutableUserNotificationAction *noAction = [UIMutableUserNotificationAction new];
    noAction.identifier = @"removeAction";
    noAction.title = @"Close";
    noAction.activationMode = UIUserNotificationActivationModeBackground;
    noAction.destructive = YES;
    noAction.authenticationRequired = YES;
    
    UIMutableUserNotificationAction *replyAction = [UIMutableUserNotificationAction new];
    replyAction.identifier = @"shortResponse";
    replyAction.title = @"Reply";
    replyAction.activationMode = UIUserNotificationActivationModeBackground;
    replyAction.authenticationRequired = NO;
    replyAction.behavior = UIUserNotificationActionBehaviorTextInput;
    replyAction.destructive = NO;
    
    UIMutableUserNotificationCategory *demoCategory = [UIMutableUserNotificationCategory new];
    UIMutableUserNotificationCategory *banCategory = [UIMutableUserNotificationCategory new];
    demoCategory.identifier = @"demo_category";
    banCategory.identifier = @"ban_category";
    [demoCategory setActions:@[replyAction] forContext:UIUserNotificationActionContextDefault];
    [demoCategory setActions:@[openAction, replyAction] forContext:UIUserNotificationActionContextMinimal];
    [banCategory setActions:@[noAction] forContext:UIUserNotificationActionContextMinimal];
    
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        
        UIUserNotificationType userTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:userTypes categories:[NSSet setWithObjects:demoCategory,banCategory, nil]];
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
        
    } else {
        UIRemoteNotificationType remoteTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:remoteTypes];
    }
}

-(void)showRegistrationDialog{
    UIAlertController * alert= [UIAlertController
                                alertControllerWithTitle:kInvite
                                message:@"Введите своё имя"
                                preferredStyle:UIAlertControllerStyleAlert];
    __weak UIAlertController *alertRef = alert;
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action) {
                             NSString *text = ((UITextField *)[alertRef.textFields objectAtIndex:0]).text;
                             NSLog(@"Added?:%i",[self registerUserName:text]);
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:@"Cancel"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [alert dismissViewControllerAnimated:YES completion:nil];
                             }];
    
    [alert addAction:ok];
    [alert addAction:cancel];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Пример: Иван";
    }];
    [ROOTVIEW presentViewController:alert animated:YES completion:nil];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    NSLog(@"Did register:%@", notificationSettings);
    [application registerForRemoteNotifications];
    //    [application currentUserNotificationSettings]
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler{
    
    NSLog(@"handleLocalAction id:%@", identifier);
}

-(void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler{
    
    NSLog(@"handleLocalActionWithResp id:%@, RESPi:%@", identifier,responseInfo);
    if ([notification.alertTitle isEqualToString:kInvite]) {
        if ([identifier isEqualToString:@"shortResponse"]) {
            NSString *respName = [responseInfo objectForKey:UIUserNotificationActionResponseTypedTextKey];
            NSLog(@"Added?:%i",[self registerUserName:respName]);
        } else if ([identifier isEqualToString:@"fullResponse"]) {
            [self showRegistrationDialog];
        } else {
            NSLog(@"ELSE ID:%@", identifier);
        }
        
    } else if ([notification.alertTitle isEqualToString:kNewComment]){
        if ([identifier isEqualToString:@"shortResponse"]) {
            NSString *replyText = [responseInfo objectForKey:UIUserNotificationActionResponseTypedTextKey];
            Note *note = [Note MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"noteID == %@", [notification.userInfo objectForKey:@"noteID"]]];
            
            [self saveReplyText:replyText forNote:note];
            
        } else if ([identifier isEqualToString:@"fullResponse"]) {
            [self showNewComment:[self getSavedCommentFromNotification:notification]];
        } else {
            NSLog(@"ELSE ID:%@", identifier);
        }
        
    } else if ([notification.alertTitle isEqualToString:@"Ban"]){
        NSLog(@"BAN ACT:%@",identifier);
    }
    
    completionHandler();
}

-(Comment*)getSavedCommentFromNotification:(UILocalNotification*)notify{
    NSString *commentText = [[[notify.userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"];
    Comment *savedComment = [Comment MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"text==%@",commentText]];
    return savedComment;
}

-(BOOL)registerUserName:(NSString*)name{
    
    NSString *key =@"USER_NAME";
    NSData * value = [name dataUsingEncoding:NSUTF8StringEncoding];
    if([[KeyChainHelper sharedKeyChain] insert:key :value]) {
        NSLog(@"Successfully added data");
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        return YES;
    }
    NSLog(@"Failed to add data");
    return NO;
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo withResponseInfo:(NSDictionary *)responseInfo completionHandler:(void (^)())completionHandler {
    NSLog(@"handleRemoteActionWithResp id:%@, userInfo:%@  RESPi:%@", identifier, userInfo,responseInfo);
    completionHandler();
}

- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    NSLog(@"handleRemoteAction id:%@, userInfo:%@", identifier, userInfo);
    completionHandler();
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
//    NSLog(@"didReceiveLocalN:%@", notification.alertTitle);
    if ([notification.alertTitle isEqualToString:kInvite]) {
        [self showRegistrationDialog];
    } else if ([notification.alertTitle isEqualToString:kNewComment]){
        [self showNewComment:[self getSavedCommentFromNotification:notification]];
    } else NSLog(@"Local Title:%@",notification.alertTitle);
}

//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//    NSLog(@"didReceiveRemoteN:%@", userInfo);
//}

-(Comment*)saveCommentFromUserInfo:(NSDictionary*)uInfo{
    NSString *commentText = [[[uInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"];
    
    Note *relNote = [Note MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"noteID == %@", [uInfo objectForKey:@"noteID"]]];
    Comment *newComment = [Comment MR_createEntity];
    newComment.userID = [uInfo objectForKey:@"usrID"];
    newComment.text = commentText;
    newComment.date = [NSDate date];
    newComment.theNote = relNote;
    
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {
        NSLog(@"SAVED? %i",contextDidSave);
    }];
    return newComment;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSString *nTitle = [[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"title"];
    if ([nTitle isEqualToString:@"Ban"]) {
        
        NSString *isBan = [userInfo objectForKey:@"ban"];
        if ([isBan isEqualToString:[self findBanInfo]])
            return;
        
        
        NSString *banReason = [[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"];
        
        [self handleBanRequest:isBan];
        
        if ( application.applicationState != UIApplicationStateActive ) {
            
            UILocalNotification *localNotif = [UILocalNotification new];
            localNotif.alertBody = banReason;
            localNotif.alertTitle = @"Ban";
            localNotif.applicationIconBadgeNumber = 1;
            localNotif.category = @"ban_category";
            localNotif.userInfo = userInfo;
            localNotif.soundName = UILocalNotificationDefaultSoundName;
            [application cancelAllLocalNotifications];
            [application presentLocalNotificationNow:localNotif];
        } else {
            
            UIAlertController * alert= [UIAlertController
                                        alertControllerWithTitle:@"Ban"
                                        message:banReason
                                        preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* okAction = [UIAlertAction
                                       actionWithTitle:@"Ok"
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                           
                                           [alert dismissViewControllerAnimated:YES completion:nil];
                                       }];
            [alert addAction:okAction];
            [ROOTVIEW presentViewController:alert animated:YES completion:nil];
        }
    } else {
        Comment  *savedComment = [self saveCommentFromUserInfo:userInfo];
        
        NSString *cText = [[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"];
        NSString *uID = [userInfo objectForKey:@"usrID"];
        Note *note = [Note MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"noteID == %@", [userInfo objectForKey:@"noteID"]]];
        NSString *forMsg = [NSString stringWithFormat:@"%@ пользователь прокомментировал запись '%@' следующим:'%@'",uID,note.name,cText];
        
        if ( application.applicationState != UIApplicationStateActive ) {
            
            NSLog(@"DIDRECeiveRemoteN:%@", userInfo);
            UILocalNotification *localNotif = [UILocalNotification new];
            localNotif.alertBody = forMsg;
            localNotif.alertTitle = kNewComment;
            localNotif.applicationIconBadgeNumber = 1;
            localNotif.category = @"demo_category";
            localNotif.userInfo = userInfo;
            localNotif.soundName = UILocalNotificationDefaultSoundName;
            [application cancelAllLocalNotifications];
            [application presentLocalNotificationNow:localNotif];
            
        } else {
            
            UIAlertController * alert= [UIAlertController
                                        alertControllerWithTitle:kNewComment
                                        message:forMsg
                                        preferredStyle:UIAlertControllerStyleAlert];
            __weak UIAlertController *alertRef = alert;
            UIAlertAction* reply = [UIAlertAction
                                    actionWithTitle:@"Reply"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        NSString *text = ((UITextField *)[alertRef.textFields objectAtIndex:0]).text;
                                        [self saveReplyText:text forNote:note];
                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                    }];
            UIAlertAction* show = [UIAlertAction
                                   actionWithTitle:@"Show"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       
                                       [alert dismissViewControllerAnimated:YES completion:nil];
                                       [self showNewComment:savedComment];
                                       
                                   }];
            UIAlertAction* cancel = [UIAlertAction
                                     actionWithTitle:@"Cancel"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                     }];
            
            [alert addAction:reply];
            [alert addAction:show];
            [alert addAction:cancel];
            [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            }];
            [ROOTVIEW presentViewController:alert animated:YES completion:nil];
            
        }
    }
    completionHandler(UIBackgroundFetchResultNewData);
    
}

-(void)handleBanRequest:(NSString*)ban{
    NSLog(@"isBAN:%@",ban);
    KeyChainHelper *keychain = [KeyChainHelper sharedKeyChain];
    NSString *key =@"BAN";
    NSData * value = [ban dataUsingEncoding:NSUTF8StringEncoding];
    if ([keychain find:@"BAN"] == nil) {
        if([keychain insert:key :value]) NSLog(@"ban added!");
    } else {
        if([keychain update:key :value]) NSLog(@"ban changed!");
    }
    if ([ban isEqualToString:@"1"]) {
        UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
        NSArray <UIViewController*> *viewControllers = [navigationController viewControllers];

        if (viewControllers.count>1) {
            navigationController.viewControllers = @[[viewControllers objectAtIndex:0]];
        }
    }
    
}

-(NSString*)findBanInfo{
    NSData * raw = [[KeyChainHelper sharedKeyChain] find:@"BAN"];
    return [[NSString alloc] initWithData:raw encoding:NSUTF8StringEncoding];
}

-(void)showNewComment:(Comment*)comm{
    NotesViewController *destination = (NotesViewController *)[ROOTVIEW.storyboard instantiateViewControllerWithIdentifier:@"NotesViewID"];
    NSLog(@"SHOW NEW:%@",destination);
    destination.isComments = YES;
    destination.selectedNote = comm.theNote;
    destination.arrivedComment = comm;
    
    UINavigationController *navigationController = (UINavigationController *)self.window.rootViewController;
    [navigationController pushViewController:destination animated:YES];
}

-(void)saveReplyText:(NSString*)text forNote:(Note*)note{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        
        Comment *newC = [Comment MR_createEntityInContext:localContext];
        newC.userID = @"1";
        newC.text = text;
        newC.date = [NSDate date];
        newC.theNote = [note MR_inContext:localContext];
    } completion:^(BOOL success, NSError *error) {
        NSLog(@"added reply text");
    }];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"Registration successful, device token: %@", deviceToken);
    const char *data = [deviceToken bytes];
    NSMutableString *token = [NSMutableString string];
    for (int i = 0; i < [deviceToken length]; i++)
        [token appendFormat:@"%02.2hhX", data[i]];
    _dToken = [NSString stringWithString:token];
    NSLog(@"Token = %@", _dToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"FailRegister:%@", error.localizedDescription);
}

@end
