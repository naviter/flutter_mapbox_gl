//
//  NSURLSessionConfiguration+Authorization.h
//  Runner
//
//  Created by Marvin The Robot on 21/08/2020.
//  Copyright © 2020 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Mapbox/MGLMapView.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURLSessionConfiguration (Authorization)
+ (void) load;
+ (NSURLSessionConfiguration*) __swizzle_defaultSessionConfiguration;
+ (void) setCustomHeaders:(NSDictionary<NSString*,NSString*> *)headers;
+ (NSDictionary<NSString*,NSString*> *) getCustomHeaders;
+ (void) setFilterForCustomHeaders:(NSArray<NSString*> *)filter;
+ (NSArray<NSString*> *) getFilterForCustomHeaders;
+ (void) setLastUsedCustomHeaders:(NSDictionary<NSString*,NSString*> *)headers;
+ (NSDictionary<NSString*,NSString*> *) getLastUsedCustomHeaders;
@end

@interface NSURLRequest (CustomHeaders)
+ (void) load;
@end

@interface MGLMapView (DisableScreenshot)
+ (void) load;
@end

NS_ASSUME_NONNULL_END
