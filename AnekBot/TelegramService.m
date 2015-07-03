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

@import AppKit;


NSString *const baseURL = @"https://api.telegram.org/bot119956909:AAFjUk7ntsF45eCjKzgkQSSyq1J5U3UEcz0/";


static inline NSString *makePlainText(NSString *htmlText) {
	NSDictionary *options = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
								 NSCharacterEncodingDocumentAttribute: @(NSUTF8StringEncoding)};
	NSAttributedString *string = [NSAttributedString.alloc initWithData:[htmlText dataUsingEncoding:NSUTF8StringEncoding]
																options:options
													 documentAttributes:nil
																  error:nil];
	return string.string;
}

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
	AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];

	NSString *urlString = [baseURL stringByAppendingString:@"getUpdates"];

	NSMutableDictionary *dictionary = @{}.mutableCopy;
	[dictionary setValue:@20 forKey:@"timeout"];
	[dictionary setValue:updateID forKey:@"offset"];
	
	manger.requestSerializer.timeoutInterval = 30;
	NSURLSessionDataTask *task = [manger POST:urlString parameters:dictionary success:^(NSURLSessionDataTask *operation, id responseObject) {
		
		NSArray *updates = responseObject[@"result"];
		
		[updates enumerateObjectsUsingBlock:^(id message, NSUInteger idx, BOOL *stop) {
			NSNumber *chatID = @([message[@"message"][@"chat"][@"id"] integerValue]);
			NSNumber *messageID = @([message[@"message"][@"message_id"] integerValue]);
			NSString *text = message[@"message"][@"text"];
			if ([text.lowercaseString containsString:@"анек"]) {
				[AnekService randomAnek:^(NSString *anekString) {
					[self sendMessage:chatID replyToMessage:messageID text:makePlainText(anekString)];
				}];
			}
		}];
		NSNumber *offset = @([[updates valueForKeyPath:@"@max.update_id"] integerValue] + 1);
		[self getUpdatesWithOffset:offset];
		
	} failure:^(NSURLSessionDataTask *operation, NSError *error) {
		
		NSLog(@"%@", error.localizedDescription);
		if (operation.state != NSURLSessionTaskStateCompleted) {
			[self getUpdatesWithOffset:nil];
		}
	}];
	
	self.task = task;
}

- (void)sendMessage:(NSNumber *)chatID replyToMessage:(NSNumber *)messageID text:(NSString *)text {

	NSString *urlString = [baseURL stringByAppendingString:@"sendMessage"];
	NSDictionary *params = @{@"chat_id": chatID, @"text": text, @"reply_to_message_id": messageID};

	void (^s)(NSURLSessionDataTask *, id) = ^(NSURLSessionDataTask *_, id response) {
		self.callback(response[@"text"]);
	};

	void (^f)(NSURLSessionDataTask *, NSError *) = ^(NSURLSessionDataTask *_, NSError *error) {
		self.callback(error.localizedDescription);
	};

	[AFHTTPSessionManager.manager POST:urlString parameters:params success:s failure:f];
}

- (void)stopTask {
	[self.task cancel];
}

@end
