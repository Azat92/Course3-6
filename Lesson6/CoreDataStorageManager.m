//
//  CoreDataStorageManager.m
//  Lesson6
//
//  Created by Артур Сагидулин on 12.11.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import "CoreDataStorageManager.h"
#import <MagicalRecord/MagicalRecord.h>
#import "Note+CoreDataProperties.h"
#import "Comment+CoreDataProperties.h"

@implementation CoreDataStorageManager


+(NSFetchedResultsController *)notesFetchControllerWithPredicate:(NSPredicate *)predicate{
    
    return [Note MR_fetchAllSortedBy:@"name" ascending:YES withPredicate:predicate groupBy:nil delegate:nil];
}

+(NSFetchedResultsController*)commentsFetchControllerWithPredicate:(NSPredicate *)predicate{
    return [Comment MR_fetchAllSortedBy:@"text" ascending:YES withPredicate:predicate groupBy:nil delegate:nil];
}

@end
