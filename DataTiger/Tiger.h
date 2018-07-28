//
//  Tiger.h
//  DataTiger
//
//  Created by BruceZCQ on 5/22/15.
//  Copyright (c) 2015 BruceZCQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tiger : NSObject

/**
 *  @author BruceZCQ(zhucongqi@91paiyipai.com), 15-05-22 14:05:07
 *
 *  @brief  授权
 *
 *  @param appkey  app 的 key
 */
+ (void)authWithAppkey:(NSString *)appkey;

/**
 *  @author BruceZCQ(zhucongqi@91paiyipai.com), 15-05-23 17:05:00
 *
 *  @brief  记录数据
 *
 *  @param code 数据对应的 code
 *  @param json  数据内容
 */
+ (void)logDataWithCore:(NSString *)code data:(NSString *)json;

@end
