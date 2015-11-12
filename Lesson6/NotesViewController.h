//
//  NotesViewController.h
//  Lesson6
//
//  Created by Артур Сагидулин on 12.11.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DTTableViewManager/DTTableViewController.h>
#import "Note+CoreDataProperties.h"
#import "Comment+CoreDataProperties.h"

@interface NotesViewController : DTTableViewController
@property BOOL isComments;
@property (weak, nonatomic) Note *selectedNote;
@property (strong, nonatomic) Comment *arrivedComment;
@end
