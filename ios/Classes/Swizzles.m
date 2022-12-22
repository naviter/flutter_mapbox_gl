//
//  NSURLSessionConfiguration+Authorization.m
//  CartoDemo
//
//  Created by Jan Driesen on 03.08.20.
//  Copyright © 2020 Driesengard. All rights reserved.
//

#import "Swizzles.h"
#import "NSObject+DTRuntime.h"

#import <Foundation/Foundation.h>
#import <objc/runtime.h>


@implementation NSURLSessionConfiguration (Authorization)

+ (void) load
{
    NSLog(@"Swizzle: registering NSURLSessionConfiguration.defaultSessionConfiguration override for authorization");

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] swizzleClassMethod:@selector(defaultSessionConfiguration) withMethod:@selector(__swizzle_defaultSessionConfiguration)];
    });
}

+ (NSURLSessionConfiguration*) __swizzle_defaultSessionConfiguration
{
    NSLog(@"Swizzle: calling override for NSURLSessionConfiguration.defaultSessionConfiguration");

    NSURLSessionConfiguration * sessionConfig = [NSURLSessionConfiguration __swizzle_defaultSessionConfiguration];
    return sessionConfig;
}

+ (void) setCustomHeaders:(NSDictionary<NSString*,NSString*> *)headers {    
    _customHeaders = headers;
}

+ (NSDictionary<NSString*,NSString*> *) getCustomHeaders {
    return _customHeaders;
}

+ (void) setFilterForCustomHeaders:(NSArray<NSString*> *)filter {
    _filter = filter;
}

+ (NSArray<NSString*> *) getFilterForCustomHeaders {
    return _filter;
}

+ (void) setLastUsedCustomHeaders:(NSDictionary<NSString*,NSString*> *)headers {
    _lastUsedCustomHeaders = headers;
}

+ (NSDictionary<NSString*,NSString*> *) getLastUsedCustomHeaders {
    return _lastUsedCustomHeaders;
}

static NSDictionary *_customHeaders;
static NSArray *_filter;
static NSDictionary *_lastUsedCustomHeaders;

@end

@implementation NSURLRequest (CustomHeaders)

+ (void) load
{
    NSLog(@"Swizzle: registering NSURLRequest.requestWithURL override for custom headers");

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class targetClass = [NSURLRequest class];
        Method oldMethod = class_getClassMethod(targetClass, @selector(requestWithURL:));
        Method newMethod = class_getClassMethod(targetClass, @selector(__swizzle_requestWithURL:));
        method_exchangeImplementations(oldMethod, newMethod);
    });
}


+(NSURLRequest*) __swizzle_requestWithURL:(NSURL*)url {
    NSLog(@"Swizzle: calling override for NSURLRequest.requestWithURL");

    NSMutableURLRequest *req = (NSMutableURLRequest *)[NSURLRequest __swizzle_requestWithURL:url];
    NSArray<NSString*>* stack = [NSThread callStackSymbols];
    if(![url.scheme isEqualToString:@"ws"] && [stack count] >= 2 && [stack[1] containsString:@"Mapbox"] == YES) {
        NSDictionary<NSString*,NSString*>* headers = [NSURLSessionConfiguration getCustomHeaders];
        NSArray<NSString*>* filter = [NSURLSessionConfiguration getFilterForCustomHeaders];
        for (NSString* pattern in filter) {
            if ([url.absoluteString containsString:pattern] == YES) {
                for (NSString* key in headers) {
                    [req setValue: headers[key] forHTTPHeaderField:key];
                }
                [NSURLSessionConfiguration setLastUsedCustomHeaders:headers];
                return req;
            }
        }
    }

    return req;    
}

@end

@implementation MGLMapView (DisableScreenshot)

+ (void) load
{
    NSLog(@"Swizzle: registering MGLMapView.willResignActive override to prevent crash while going to background");

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class targetClass = [MGLMapView class];
        Method oldMethod = class_getInstanceMethod(targetClass, @selector(willResignActive:));
        Method newMethod = class_getInstanceMethod(targetClass, @selector(__swizzle_willResignActive:));
        method_exchangeImplementations(oldMethod, newMethod);
    });
}

- (void) __swizzle_willResignActive:(NSNotification *)notification {
    NSLog(@"Swizzle: calling override for MGLMapView.willResignActive");
}

@end
