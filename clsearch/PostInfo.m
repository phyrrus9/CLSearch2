//
//  PostInfo.m
//  clsearch
//
//  Created by Ethan on 11/8/20.
//  Copyright © 2020 Ipseity Software. All rights reserved.
//

#import "PostInfo.h"

@implementation PostInfo

- (id)initWithId:(NSString *)identifier Title:(NSString *)title URI:(NSString *)uri
{
	self.Id = identifier;
	self.Title = title;
	self.URL = [NSURL URLWithString:uri];
	return self;
}

@end
