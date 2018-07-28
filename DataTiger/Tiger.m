//
//  Tiger.m
//  DataTiger
//
//  Created by BruceZCQ on 5/22/15.
//  Copyright (c) 2015 BruceZCQ. All rights reserved.
//

#import <CommonCrypto/CommonCrypto.h>
#import <UIKit/UIDevice.h>
#import "Tiger.h"
#import "TigerPush.h"
#import "TigerConst.h"

static NSString * const kTigerCharactersToBeEscapedInQueryString = @":/?&=;+!@#$()',*";

static NSString * TigerPercentEscapedQueryStringKeyFromStringWithEncoding(NSString *string) {
    static NSString * const kTigerCharactersToLeaveUnescapedInQueryStringPairKey = @"[].";
    
    return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, (__bridge CFStringRef)kTigerCharactersToLeaveUnescapedInQueryStringPairKey, (__bridge CFStringRef)kTigerCharactersToBeEscapedInQueryString, CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
}

static NSString * TigerPercentEscapedQueryStringValueFromStringWithEncoding(NSString *string) {
    return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef)kTigerCharactersToBeEscapedInQueryString, CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
}

static NSObject *lockObj = nil;
static NSString *unFinishedCode = nil;
static NSString *unFinishedJson = nil;

@implementation Tiger

+ (void)initialize
{
    [super initialize];
    lockObj = [NSObject new];
}

/**
 *  @author BruceZCQ(zhucongqi@91paiyipai.com), 15-05-21 15:05:46
 *
 *  @brief  MD5加密算法
 *
 *  @param string 明文
 *
 *  @return  md5加密之后得密文
 */
+ (NSString *)md5:(NSString *)string
{
    const char *cdata = [string UTF8String];
    
    CC_LONG len = (CC_LONG)string.length;
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cdata, len, result);
    
    NSMutableString *md5Password = @"".mutableCopy;
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [md5Password appendFormat:@"%02x",result[i]];
    }
    return md5Password;
}

+ (NSString *)encodingParam:(NSString *)field value:(NSString *)value
{
    return [NSString stringWithFormat:@"%@=%@", TigerPercentEscapedQueryStringKeyFromStringWithEncoding([field description]), TigerPercentEscapedQueryStringValueFromStringWithEncoding([value description])];
}

#pragma mark - Requests

+ (void)authWithAppkey:(NSString *)appkey
{
    if (nil == appkey) {
        return;
    }
    
    // 还没有过期， 不需要授权
    if ([self checkTokenIsTimeout] == NO) {
        return;
    }
    
    //暂存 appkey
    [[NSUserDefaults standardUserDefaults] setObject:appkey forKey:@"appkey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // bundleID
    NSString *bundleId = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    bundleId = [self md5:bundleId];
    // uuid
    NSString *uuid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    uuid = [self md5:uuid];
    [self request:uuid appkey:appkey bundle:bundleId];
}

+ (void)reAuth
{
    NSString *appKey = [[NSUserDefaults standardUserDefaults] objectForKey:@"appkey"];
    [self authWithAppkey:appKey];
}

+ (BOOL)checkTokenIsTimeout
{
    @synchronized(lockObj){
        NSString *timeout = [[NSUserDefaults standardUserDefaults] objectForKey:kTigerDataTokenTimeout];
        if (nil == timeout) {
            return YES;
        }
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeout.longLongValue];
        NSTimeInterval timeInterval = [date timeIntervalSinceDate:[NSDate date]];
        //3 hours inner
        if (timeInterval <= 3*60*60) {
            return YES;
        }
        return NO;
    }
}

+ (void)request:(NSString *)uuid appkey:(NSString *)appkey bundle:(NSString *)bundle
{
    NSString *_uuid = [self encodingParam:@"uuid" value:uuid];
    NSString *_appkey = [self encodingParam:@"appkey" value:appkey];
    NSString *_bundle = [self encodingParam:@"bundle" value:bundle];
    NSString *data = [NSString stringWithFormat:@"%@&%@&%@",_uuid,_appkey,_bundle];
    
    [TigerPushHandler pushData:[data dataUsingEncoding:NSUTF8StringEncoding]
                           url:kDataTigerAuthApi completionHandler:^(NSError *error) {
                               if (error == nil && unFinishedCode != nil && unFinishedJson != nil) {
                                   [self logDataWithCore:unFinishedCode data:unFinishedJson];
                                }
    }];
}

+ (void)logDataWithCore:(NSString *)code data:(NSString *)json
{
    @synchronized(lockObj){
        NSParameterAssert(code);
        NSParameterAssert(json);
        
        if ([self checkTokenIsTimeout]) {
            unFinishedCode = code;
            unFinishedJson = json;
            // 重新授权
            [self reAuth];
            return;
        }

        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:kTigerDataToken];
        NSString *_token = [self encodingParam:kTigerDataTokenKey value:token];
        NSString *_code = [self encodingParam:@"code" value:code];
        NSString *_data = [self encodingParam:@"data" value:json];
        
        NSString *data = [NSString stringWithFormat:@"%@&%@&%@",_token,_code,_data];
        
        [TigerPushHandler pushData:[data dataUsingEncoding:NSUTF8StringEncoding] url:kDataTigerLogDataApi completionHandler:^(NSError *error) {
            if (error == nil) {
                unFinishedCode = nil;
                unFinishedJson = nil;
            }
        }];
    }
}

@end
