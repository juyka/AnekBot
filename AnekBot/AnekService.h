//
//  AnekService.h
//  AnekBot
//
//  Created by Настя on 02/07/15.
//  Copyright (c) 2015 Nastya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnekService : NSString

+ (void)randomAnek:(void(^)(NSString *anekString))block;

@end
