//
//  NSURLSessionConfiguration+Authorization.h
//  Runner
//
//  Created by Marvin The Robot on 21/08/2020.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLSessionConfiguration (Authorization)
+ (void) load;
+ (NSURLSessionConfiguration*) __swizzle_defaultSessionConfiguration;
+ (void) setCloudAccessToken:(NSString *)token;
+ (NSString *) getCloudAccessToken;
@end

@interface NSMutableURLRequest (CustomHeaders)
+ (void) load;
@end

NS_ASSUME_NONNULL_END
