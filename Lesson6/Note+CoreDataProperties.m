//
//  Note+CoreDataProperties.m
//  Lesson6
//
//  Created by Артур Сагидулин on 12.11.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Note+CoreDataProperties.h"

@implementation Note (CoreDataProperties)

@dynamic name;
@dynamic date;
@dynamic text;
@dynamic noteID;
@dynamic comments;

@end
