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
	[textView setText:@"hey your bastard......"];
}

- (IBAction)sendFeedBack:(id)sender {
	static BadWordList *badWordDetector = nil;
	if (badWordDetector == nil) {
		badWordDetector = [[BadWordList alloc]init];
	}
	NSString *wordFound = [badWordDetector detectBadWordsOn:[textView text]];
	NSString *message = wordFound ? [NSString stringWithFormat:@"Don't use \n'%@'\n kind of words", wordFound] : @"successfully posted your comment.";
	[[[UIAlertView alloc]initWithTitle:(wordFound?@"Hey!":@"Information") message:message delegate:nil cancelButtonTitle:@"okay" otherButtonTitles:nil]show];
}

@end
