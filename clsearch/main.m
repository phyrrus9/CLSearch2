//
//  main.m
//  clsearch
//
//  Created by Ethan on 11/8/20.
//  Copyright © 2020 Ipseity Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Endpoints.h"
#import "SearchClient.h"

NSArray *keywords = nil;
NSArray *bannedwords = nil;

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
	int opt;
	while((opt = getopt(argc, argv, "k:b:h")) != -1)
	{
		switch(opt)
		{
			case 'k':
				keywords = ReadWordList(optarg);
				break;
			case 'b':
				bannedwords = ReadWordList(optarg);
				break;
			case 'h':
				fprintf(stderr, "-k <keywords.txt> -b <bannedwords.txt>\n\n");
				return 0;
				break;
			case '?':
				fprintf(stderr, "unknown option: %c\n", optopt);
				return -1;
				break;
		}
	}
	
	if (keywords == nil)
	{
		fprintf(stderr, "==WARNING: proceeding without a keyword file==\n");
		keywords = [[NSArray alloc] init];
	}
	if (bannedwords == nil)
		bannedwords = [[NSArray alloc] init];
	
	NSMutableArray *firstPassResults = [[NSMutableArray alloc] init];
	SearchClient *client = [[SearchClient alloc] init];
	for (int ep = 0; ep < CL_Endpoint_Count; ++ep)
	{
		NSString *endpoint = [NSString stringWithUTF8String:CL_Endpoints[ep]];
		fprintf(stderr, "\r                                                    \r");
		fprintf(stderr, "Pass 1: %d/%u (%s)", ep+1, CL_Endpoint_Count, [endpoint UTF8String]);
		fflush(stderr);
		NSDictionary *posts = [client ListPosts: endpoint];
		for (id key in posts)
		{
			PostInfo *info = [posts objectForKey:key];
			if ([keywords count] > 0)
			{
				NSString *lcTitle = [info.Title lowercaseString];
				for (NSString *keyword in keywords)
					if ([lcTitle containsString:keyword] && !IdExistsInArray(firstPassResults, [info Id]))
					{
						[firstPassResults addObject:info];
						break;
					}
			}
			else
			{
				if (!IdExistsInArray(firstPassResults, [info Id]))
					[firstPassResults addObject:info];
			}
		}
	}
	fprintf(stderr, "\nGot %lu first pass results\n\n", [firstPassResults count]);
	
	NSMutableArray *secondPassResults = [[NSMutableArray alloc] init];
	if ([bannedwords count] > 0)
	{
		int processed = 0;
		for (PostInfo *info in firstPassResults)
		{
			fprintf(stderr, "\r                                                    \r");
			fprintf(stderr, "Pass 2: %d/%lu", processed+1, [firstPassResults count]);
			fflush(stderr);
			for (NSString *bannedWord in bannedwords)
				if ([[info.Title lowercaseString] containsString:bannedWord] || [[client GetPost:info] containsString:bannedWord])
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
			  "URL:   %s\n\n\n",
			  [info.Id UTF8String],
			  [info.Title UTF8String],
			  [[info.URL absoluteString] UTF8String]);
	return 0;
}
