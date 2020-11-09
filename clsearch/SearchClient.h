//
//  SearchClient.h
//  clsearch
//
//  Created by Ethan on 11/8/20.
//  Copyright © 2020 Ipseity Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostInfo.h"

@interface SearchClient : NSObject

- (id)initWithSection:(NSString *)section options:(NSArray *)options query:(NSString *)query maxPages:(NSInteger) max;
- (NSDictionary *)ListPosts: (NSString *)endpoint;
- (NSString *)GetPost:(PostInfo *)post;

@end
