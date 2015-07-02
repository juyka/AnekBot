//
//  TelegramService.m
//  AnekBot
//
//  Created by Настя on 01/07/15.
//  Copyright (c) 2015 Nastya. All rights reserved.
//

#import "TelegramService.h"
#import <AFNetworking.h>
#import "AnekService.h"


@interface TelegramService ()

@property (nonatomic) NSURLSessionDataTask *task;
@property (copy, nonatomic) void (^callback)(NSString *);

@end


@implementation TelegramService

- (void)getUpdates:(void (^)(NSString *))callback {
	self.callback = callback;
	[self getUpdatesWithOffset:nil];
}

- (void)getUpdatesWithOffset:(NSNumber *)updateID {
	NSString *urlString = [NSString stringWithFormat:@"https://api.telegram.org/bot%@/getUpdates", self.accessToken];
	AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
	NSMutableDictionary *dictionary = @{}.mutableCopy;
	[dictionary setValue:@20 forKey:@"timeout"];
	[dictionary setValue:updateID forKey:@"offset"];
	
	manger.requestSerializer.timeoutInterval = 30;
	NSURLSessionDataTask *task = [manger POST:urlString parameters:dictionary success:^(NSURLSessionDataTask *operation, id responseObject) {
		
		NSArray *updates = responseObject[@"result"];
		NSDictionary *lastUpdate = updates.lastObject;
		if (lastUpdate) {
			self.callback([NSString stringWithFormat:@"@%@: %@", lastUpdate[@"message"][@"from"][@"username"], lastUpdate[@"message"][@"text"]]);
			[AnekService randomAnek:^(NSString *anekString) {
				NSLog(@"%@", anekString);
			}];
		}
		
		[self getUpdatesWithOffset:[updates valueForKeyPath:@"@max.update_id"]];
		
	} failure:^(NSURLSessionDataTask *operation, NSError *error) {
		
		NSLog(@"%@", error.localizedDescription);
		if (operation.state != NSURLSessionTaskStateCompleted) {
			[self getUpdatesWithOffset:nil];
		}
	}];
	
	self.task = task;
}

- (void)stopTask {
	[self.task cancel];
}

- (NSString *)accessToken {
	return @"119956909:AAFjUk7ntsF45eCjKzgkQSSyq1J5U3UEcz0";
}

@end
