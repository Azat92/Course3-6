//
//  KeyChainHelper.h
//  Lesson6
//
//  Created by Артур Сагидулин on 12.11.15.
//  Copyright © 2015 Azat Almeev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainHelper : NSObject {
    NSString * service;
    NSString * group;
}
+(KeyChainHelper*)sharedKeyChain;

-(id)initWithService:(NSString *) service_ withGroup:(NSString*)group_;

-(BOOL)insert:(NSString *)key : (NSData *)data;

-(NSData*)find:(NSString*)key;

-(BOOL) update:(NSString*)key :(NSData*) data;

-(BOOL) remove: (NSString*)key;

@end
