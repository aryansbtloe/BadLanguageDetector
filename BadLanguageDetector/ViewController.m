//
//  ViewController.m
//  BadLanguageDetector
//
//  Created by Alok on 06/09/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import "ViewController.h"
#import "BadWordList.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[textView setText:@"i am gonna kick you ass"];
}

- (IBAction)sendFeedBack:(id)sender {
	
	static BadWordList *badWordDetector = nil;
	if (badWordDetector == nil) {
		badWordDetector = [[BadWordList alloc]init];
	}
	NSString *wordFound = [badWordDetector isAnyOfTheWordFoundIn:[textView text]];
	NSString *message = wordFound ? [NSString stringWithFormat:@"please don't use '%@' kind of words", wordFound] : @"Thanks for your valuable feedback";
	[[[UIAlertView alloc]initWithTitle:nil message:message delegate:nil cancelButtonTitle:@"okay" otherButtonTitles:nil]show];
}

@end
