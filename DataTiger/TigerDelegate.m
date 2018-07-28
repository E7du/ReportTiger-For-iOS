//
//  TigerDelegate.m
//  DataTiger
//
//  Created by BruceZCQ on 5/23/15.
//  Copyright (c) 2015 BruceZCQ. All rights reserved.
//

#import "TigerDelegate.h"
#import "TigerConst.h"

@implementation TigerDelegate

#pragma mark - 处理服务端返回数据

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"didReceiveData === %@",data);
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    
    if (error == nil) {
        NSLog(@"Tiger DidReceiveData => %@",json);
        [self parserData:json];
    }else{
        NSLog(@"Tiger DidReceiveData Error => %@",error);
    }
    
    if (self.completionHandler) {
        self.completionHandler(error);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@==%s==erro==%@",[self class],__func__,error);
    if (self.completionHandler) {
        self.completionHandler(error);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
     NSLog(@"%@==%s",[self class],__func__);
}

#pragma mark - 解析数据

- (void)parserData:(NSDictionary *)data
{
    [self parserTokenData:data];
}

- (void)parserTokenData:(NSDictionary *)data
{
    NSArray *allKeys = data.allKeys;
    if ([allKeys containsObject:kTigerDataTokenKey] && [allKeys containsObject:kTigerDataTokenTimeoutKey]) {
        NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
        [userDefault setObject:[data objectForKey:kTigerDataTokenKey] forKey:kTigerDataToken];
        [userDefault setObject:[data objectForKey:kTigerDataTokenTimeoutKey] forKey:kTigerDataTokenTimeout];
        [userDefault synchronize];
    }
}

@end
