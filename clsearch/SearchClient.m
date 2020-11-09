//
//  SearchClient.m
//  clsearch
//
//  Created by Ethan on 11/8/20.
//  Copyright © 2020 Ipseity Software. All rights reserved.
//

#import "SearchClient.h"
#import "PostInfo.h"

@implementation SearchClient

static NSString *Parameters = @"is_paid=all&postedToday=1";
static NSString *BaseURL = @"craigslist.org";
static NSString *pattern = @"<a href=\"([^\"]*)\" data-id=\"([0-9]*)\"[^>]*>([^<]*)</a>";
static NSString *PostBegin = @"<section id=\"postingbody\">";
static NSString *PostEnd = @"</section>";

- (NSDictionary *)ListPosts: (NSString *)endpoint
{
	NSError *error = nil;
	
	NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"https://%@.%@/search/cpg?%@", endpoint, BaseURL, Parameters]];
	NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
	if (error != nil)
	{
		// TODO: die here and report error
	}
	NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	error = nil;
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern: pattern options:0 error:&error];
	NSRange   searchedRange = NSMakeRange(0, [ret length]);
	NSArray* matches = [regex matchesInString:ret options:0 range: searchedRange];
	for (NSTextCheckingResult* match in matches)
	{
		NSRange groupUrl = [match rangeAtIndex:1];
		NSRange groupId = [match rangeAtIndex:2];
		NSRange groupTitle = [match rangeAtIndex:3];
		PostInfo *info = [[PostInfo alloc]
					   initWithId:[ret substringWithRange:groupId]
					   Title:[ret substringWithRange:groupTitle]
					   URI:[ret substringWithRange:groupUrl]];
		[dict setValue:info forKey:[info Id]];
	}
	return dict;
}
- (NSString *)GetPost:(PostInfo *)post
{
	NSError *error = nil;
	NSData *data = [NSData dataWithContentsOfURL:post.URL options:NSDataReadingUncached error:&error];
	if (error != nil)
		return nil;
	NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSRange postStart = [ret rangeOfString:PostBegin];
	if (postStart.location == NSNotFound)
		return nil; // no post text?
	NSString *p1 = [ret substringFromIndex:postStart.location + postStart.length];
	NSRange postEnd = [p1 rangeOfString:PostEnd];
	return [[p1 substringToIndex:postEnd.location] lowercaseString];
}

@end
