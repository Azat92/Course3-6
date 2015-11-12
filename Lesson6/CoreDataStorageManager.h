//
//  CoreDataStorageManager.h
//  Lesson6
//
//  Created by Артур Сагидулин on 12.11.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import <DTModelStorage/DTModelStorage.h>

@interface CoreDataStorageManager : DTCoreDataStorage

+(NSFetchedResultsController *)notesFetchControllerWithPredicate:(NSPredicate *)predicate;
+(NSFetchedResultsController*)commentsFetchControllerWithPredicate:(NSPredicate *)predicate;

@end
