//
//  main.m
//  clsearch
//
//  Created by Ethan on 11/8/20.
//  Copyright © 2020 Ipseity Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchClient.h"

BOOL IdExistsInArray(NSArray *arr, NSString *key)
{
	for (PostInfo *info in arr)
		if ([info.Id isEqualToString:key])
			return true;
	return false;
}
NSArray *ReadWordList(const char *path)
{
	NSMutableArray *arr = [[NSMutableArray alloc] init];
	FILE *fp = fopen(path, "r");
	char buf[100];
	while (fscanf(fp, "%[^\n]\n", buf) > 0)
		[arr addObject:[NSString stringWithUTF8String:buf]];
	fclose(fp);
	return arr;
}

int main(int argc, char * const * argv)
{
	NSArray *GetDefaultEndpoints(); // in case user didn't specify
	NSArray *keywords = nil;
	NSArray *bannedwords = nil;
	NSString *section = @"cpg";
	NSMutableArray *options = nil;
	NSMutableArray *customKeywords = nil, *customBadwords = nil;
	NSMutableArray *endpoints = nil;
	BOOL customEndpoints = NO, hasBadWords = NO;
	BOOL matchBody = NO, titleOnly = NO;
	int opt;
	while((opt = getopt(argc, argv, "htTk:b:s:o:K:B:e:E:")) != -1)
	{
		switch(opt)
		{
			case 'k':
				keywords = ReadWordList(optarg);
				break;
			case 'b':
				bannedwords = ReadWordList(optarg);
				break;
			case 'K':
				if (customKeywords == nil)
					customKeywords = [[NSMutableArray alloc] init];
				[customKeywords addObject:[NSString stringWithUTF8String:optarg]];
				break;
			case 'B':
				if (customBadwords == nil)
					customBadwords = [[NSMutableArray alloc] init];
				[customBadwords addObject:[NSString stringWithUTF8String:optarg]];
				break;
			case 'e':
				if (customEndpoints)
				{
					fprintf(stderr, "-e and -E must not be specified together\n");
					return -1;
				}
				endpoints = [ReadWordList(optarg) mutableCopy];
				break;
			case 'E':
				customEndpoints = YES;
				if (endpoints == nil)
					endpoints = [[NSMutableArray alloc] init];
				[endpoints addObject:[NSString stringWithUTF8String:optarg]];
				break;
			case 's':
				if (strlen(optarg) != 3)
				{
					fprintf(stderr, "unknown section: %s\n", optarg);
					return -1;
				}
				section = [NSString stringWithUTF8String:optarg];
				break;
			case 'o':
				if (options == nil)
					options = [[NSMutableArray alloc] init];
				[options addObject:[NSString stringWithUTF8String:optarg]];
				break;
			case 't':
				fprintf(stderr, "Bad words are only being matched in titles\n");
				titleOnly = YES;
				break;
			case 'T':
				fprintf(stderr, "Keywords will be matched in body\n");
				matchBody = YES;
				break;
			case 'h':
				fprintf(stderr,
					   "-k <keywords.txt>    (supply a keyword file)\n"
					   "-K keyword           (specify a keyword)\n"
					   "-b <bannedwords.txt> (supply a bad word file)\n"
					   "-B badword           (specify a bad word)\n"
					   "-e <endpoints.txt>   (supply a file containing search locations)\n"
					   "-E endpoint          (specify a search location)\n"
					   "-s <section>         (override search category)\n"
					   "-o option=value      (specify a search parameter)\n"
					   "-t                   (bad words only in title)\n"
					   "-T                   (keywords matched in body)\n"
					   "-h                   (display this message)\n"
					   "\n");
				return 0;
				break;
			case '?':
				fprintf(stderr, "unknown option: %c\n", optopt);
				return -1;
				break;
		}
	}
	if (customEndpoints)
	{
		fprintf(stderr, "Using endpoints:\n");
		for (NSString *endpoint in endpoints)
			fprintf(stderr, "\t%s\n", [endpoint UTF8String]);
	}
	else if (endpoints == nil)
		endpoints = [GetDefaultEndpoints() mutableCopy];
	if (customKeywords != nil)
	{
		fprintf(stderr, "Using custom keywords:\n");
		for (NSString *word in customKeywords)
			fprintf(stderr, "\t%s\n", [word UTF8String]);
		keywords = keywords == nil ? customKeywords : [keywords arrayByAddingObjectsFromArray:customKeywords];
	}
	if (customBadwords != nil)
	{
		fprintf(stderr, "Using custom badwords:\n");
		for (NSString *word in customBadwords)
			fprintf(stderr, "\t%s\n", [word UTF8String]);
		bannedwords = bannedwords == nil ? customBadwords : [bannedwords arrayByAddingObjectsFromArray:customBadwords];
	}
	
	if (keywords == nil)
	{
		fprintf(stderr, "==WARNING: proceeding without a keyword file==\n");
		keywords = [[NSArray alloc] init];
	}
	hasBadWords = bannedwords != nil && [bannedwords count] > 0;
	
	NSMutableArray *firstPassResults = [[NSMutableArray alloc] init];
	SearchClient *client = [[SearchClient alloc] initWithSection:section options:options];
	fprintf(stderr, "Searching section: %s\n", [section UTF8String]);
	if ([options count] > 0)
	{
		fprintf(stderr, "Using options:\n");
		for (NSString *opt in options)
			fprintf(stderr, "\t%s\n", [opt UTF8String]);
	}
	int processed_endpoints = 0;
	for (NSString *endpoint in endpoints)
	{
		fprintf(stderr, "\r                                                    \r");
		fprintf(stderr, "Pass 1: %d/%lu (%s)", processed_endpoints+1, [endpoints count], [endpoint UTF8String]);
		fflush(stderr);
		NSDictionary *posts = [client ListPosts: endpoint];
		for (id key in posts)
		{
			PostInfo *info = [posts objectForKey:key];
			if ([keywords count] > 0)
			{
				NSString *lcTitle = [info.Title lowercaseString];
				NSString *text = !hasBadWords || matchBody ? [client GetPost:info] : nil;
				for (NSString *keyword in keywords)
					if (([lcTitle containsString:keyword] || (matchBody && [text containsString:keyword])) &&
					    !IdExistsInArray(firstPassResults, [info Id]))
					{
						[firstPassResults addObject:info];
						break;
					}
			}
			else
			{
				if (!IdExistsInArray(firstPassResults, [info Id]))
				{
					if (!hasBadWords)
						[client GetPost:info];
					[firstPassResults addObject:info];
				}
			}
		}
		++processed_endpoints;
	}
	fprintf(stderr, "\nGot %lu first pass results\n\n", [firstPassResults count]);
	
	NSMutableArray *secondPassResults = [[NSMutableArray alloc] init];
	if (hasBadWords)
	{
		int processed = 0;
		for (PostInfo *info in firstPassResults)
		{
			fprintf(stderr, "\r                                                    \r");
			fprintf(stderr, "Pass 2: %d/%lu (%s)", processed+1, [firstPassResults count], [info.Id UTF8String]);
			fflush(stderr);
			for (NSString *bannedWord in bannedwords)
				if ([[info.Title lowercaseString] containsString:bannedWord] ||
				    (!titleOnly && [[client GetPost:info] containsString:bannedWord]))
					goto bannedp2;
			[secondPassResults addObject:info];
		bannedp2:;
			++processed;
		}
		fprintf(stderr, "\nGot %lu second pass results\n\n", [secondPassResults count]);
	}
	else
	{
		fprintf(stderr, "No banned words, skipping pass 2\n\n");
		[secondPassResults addObjectsFromArray:firstPassResults];
	}
	
	for (PostInfo *info in secondPassResults)
		printf("Id:    %s\n"
			  "Title: %s\n"
			  "URL:   %s\n"
			  "Age:   %s\n\n",
			  [info.Id UTF8String],
			  [info.Title UTF8String],
			  [[info.URL absoluteString] UTF8String],
			  [info.PostedAgo UTF8String]);
	return [secondPassResults count] > 0;
}
