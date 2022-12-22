//
//  NSURLSessionConfiguration+Authorization.m
//  CartoDemo
//
//  Created by Jan Driesen on 03.08.20.
//  Copyright © 2020 Driesengard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSURLSessionConfiguration+Authorization.h"
#import <objc/runtime.h>
#import "NSObject+DTRuntime.h"


@implementation NSURLSessionConfiguration (Authorization)

// "register the swizzle" at load
+ (void) load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] swizzleClassMethod:@selector(defaultSessionConfiguration) withMethod:@selector(__swizzle_defaultSessionConfiguration)];
    });
}

+ (NSURLSessionConfiguration*) __swizzle_defaultSessionConfiguration
{
    NSURLSessionConfiguration * sessionConfig = [NSURLSessionConfiguration __swizzle_defaultSessionConfiguration];
    return sessionConfig;
}

+ (void) setCloudAccessToken:(NSString *)token
{
    _token = token;
}

+ (NSString *) getCloudAccessToken {
    return _token;
}

static NSString *_token;

@end

@implementation NSMutableURLRequest (CustomHeaders)

// "register the swizzle" at load
+ (void) load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class targetClass = [NSMutableURLRequest class];
        Method oldMethod = class_getClassMethod(targetClass, @selector(requestWithURL:));
        Method newMethod = class_getClassMethod(targetClass, @selector(__swizzle_requestWithURL:));
        method_exchangeImplementations(oldMethod, newMethod);
    });
}


+(NSMutableURLRequest*) __swizzle_requestWithURL:(NSURL*)url {
    if([url.scheme isEqualToString:@"ws"]) {
        return [NSMutableURLRequest __swizzle_requestWithURL:url];
    }

    NSArray<NSString*>* stack = [NSThread callStackSymbols];
    if ([stack count] < 2) {
        return [NSMutableURLRequest __swizzle_requestWithURL:url];
    }

    if ([stack[1] containsString:@"Mapbox"] == NO) {
        return [NSMutableURLRequest __swizzle_requestWithURL:url];
    }

    if ([url.absoluteString containsString:@"weather.seeyou.cloud"] == NO) {
        return [NSMutableURLRequest __swizzle_requestWithURL:url];
    }

    NSString *token = NSURLSessionConfiguration.getCloudAccessToken;
    NSMutableURLRequest *req = [NSMutableURLRequest __swizzle_requestWithURL:url];
    [req setValue: token forHTTPHeaderField:@"Authorization"];
    return req;
}

@end
