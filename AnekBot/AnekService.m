//
//  AnekService.m
//  AnekBot
//
//  Created by Настя on 02/07/15.
//  Copyright (c) 2015 Nastya. All rights reserved.
//

#import "AnekService.h"
#import <AFNetworking.h>

@implementation AnekService

+ (void)randomAnek:(void (^)(NSString *anekString))block {
	NSString *urlString = @"http://www.umori.li/api/random";
	
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
	NSDictionary *parameters = @{@"num": @5};
	
	[manager GET:urlString parameters:parameters success:^(NSURLSessionDataTask *task, NSArray *responseObject) {
		NSDictionary *entry = responseObject.lastObject;
		block(entry[@"elementPureHtml"]);
	} failure:^(NSURLSessionDataTask *task, NSError *error) {
		NSLog(@"%@", error);
	}];
}

@end
