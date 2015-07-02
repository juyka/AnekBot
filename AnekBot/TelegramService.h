//
//  TelegramService.h
//  AnekBot
//
//  Created by Настя on 01/07/15.
//  Copyright (c) 2015 Nastya. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TelegramService : NSObject

- (void)getUpdates:(void (^)(NSString *))callback;
- (void)stopTask;

@end
