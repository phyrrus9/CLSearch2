//
//  PostInfo.h
//  clsearch
//
//  Created by Ethan on 11/8/20.
//  Copyright © 2020 Ipseity Software. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostInfo : NSObject

@property NSString *Id;
@property NSString *Title;
@property NSURL *URL;

- (id)initWithId:(NSString *)identifier Title:(NSString *)title URI:(NSString *)uri;

@end
