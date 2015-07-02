//
//  ViewController.m
//  AnekBot
//
//  Created by Настя on 01/07/15.
//  Copyright (c) 2015 Nastya. All rights reserved.
//

#import "ViewController.h"
#import "TelegramService.h"

@interface ViewController ()
@property (weak) IBOutlet NSButton *startButton;
@property (weak) IBOutlet NSButton *stopButton;
@property (weak) IBOutlet NSTextField *lastMessageLabel;
@property (nonatomic) TelegramService *telegramService;
@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.telegramService = TelegramService.new;
}

- (void)setRepresentedObject:(id)representedObject {
	[super setRepresentedObject:representedObject];
}

- (IBAction)startService:(NSButton *)sender {
	typeof(self) __weak welf = self;
	[self.telegramService getUpdates:^(NSString *message) {
		welf.lastMessageLabel.stringValue = message;
	}];
}

- (IBAction)stopService:(NSButton *)sender {
	[self.telegramService stopTask];
}

@end
