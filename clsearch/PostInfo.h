//
//  PostInfo.h
//  clsearch
//
//  Created by Ethan on 11/8/20.
//  Copyright © 2020 Ipseity Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostInfo : NSObject

@property (copy) NSString *Id;
@property (copy) NSString *Title;
@property (copy) NSURL *URL;
@property (assign) NSString *PostedAgo;
@property (assign) NSString *PostText;

- (id)initWithId:(NSString *)identifier Title:(NSString *)title URI:(NSString *)uri;

@end
