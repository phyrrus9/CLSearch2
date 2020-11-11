//
//  SearchClient.m
//  clsearch
//
//  Created by Ethan on 11/8/20.
//  Copyright © 2020 Ipseity Software. All rights reserved.
//

#import "SearchClient.h"
#import "PostInfo.h"

#define NSDataReadingUncached (1UL << 1)

@interface SearchClient()

@property NSDateFormatter *dateFormatter;
@property NSString *Section;
@property NSString *Parameters;
@property NSInteger MaxPages;

@end

@implementation SearchClient

static NSString *BaseURL = @"craigslist.org";
static NSString *pattern = @"<a href=\"([^\"]*)\" data-id=\"([0-9]*)\"[^>]*>([^<]*)</a>";
static NSString *PostBegin = @"<section id=\"postingbody\">";
static NSString *PostEnd = @"</section>";
static NSString *PostDate = @"datetime=\"([^\"]*)\"";

- (id)initWithSection:(NSString *)section options:(NSArray *)options query:(NSString *)query maxPages:(NSInteger) max
{
	self.dateFormatter = [[NSDateFormatter alloc] init];
	[self.dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
	[self.dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
	[self.dateFormatter setCalendar:[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian]];
	self.Section = section;
	self.Parameters = @"is_paid=all";
	if (options != nil && [options count] > 0)
		for (NSString *opt in options)
			self.Parameters = [self.Parameters stringByAppendingFormat:@"&%@", opt];
	if (query != nil)
		self.Parameters = [self.Parameters stringByAppendingFormat:@"&query=%@", query];
	self.MaxPages = max;
	return self;
}

- (NSDictionary *)ListPosts: (NSString *)endpoint
{
	NSError *error = nil;
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
	NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern: pattern options:0 error:&error];
	for (NSInteger i = 0; i < self.MaxPages; ++i)
	{
		NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"https://%@.%@/search/%@/?s=%ld&%@",
									 endpoint, BaseURL, self.Section, 120*i, self.Parameters]];
#ifdef TARGET_OS_MAC
		NSData *data = [NSData dataWithContentsOfURL:url options:NSDataReadingUncached error:&error];
#else
		NSData *data = [url resourceDataUsingCache: NO];
#endif
		NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		error = nil;
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
	}
	return dict;
}
- (NSString *)GetPost:(PostInfo *)post
{
	if (post.PostText != nil)
		return [post PostText];
	NSError *error = nil;
#ifdef TARGET_OS_MAC
		NSData *data = [NSData dataWithContentsOfURL:post.URL options:NSDataReadingUncached error:&error];
#else
		NSData *data = [post.URL resourceDataUsingCache: NO];
#endif
	if (error != nil)
		return nil;
	NSString *ret = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	NSRange postStart = [ret rangeOfString:PostBegin];
	if (postStart.location == NSNotFound)
		return nil; // no post text?
	NSString *p1 = [ret substringFromIndex:postStart.location + postStart.length];
	NSRange postEnd = [p1 rangeOfString:PostEnd];
	
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:PostDate options:0 error:&error];
	NSRange searchRange = NSMakeRange(0, postStart.location);
	NSTextCheckingResult *result = [regex firstMatchInString:ret options:0 range:searchRange];
	post.PostedAgo = [self GetPostedAgoWithDate:[ret substringWithRange:[result rangeAtIndex:1]]];
	return (post.PostText = [[p1 substringToIndex:postEnd.location] lowercaseString]);
}
- (NSString *)GetPostedAgoWithDate:(NSString *)dateTime
{
	NSDate *date = [self.dateFormatter dateFromString:dateTime];
	NSDate *current = [NSDate dateWithTimeIntervalSinceNow:0];
	NSTimeInterval interval = [current timeIntervalSinceDate:date];
	
	return [NSString stringWithFormat:@"%02ld hours ago", (long)(((NSInteger)interval / 3600))];
}

@end
