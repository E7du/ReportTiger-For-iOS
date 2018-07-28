//
//  TigerPush.h
//  DataTiger
//
//  Created by BruceZCQ on 5/23/15.
//  Copyright (c) 2015 BruceZCQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TigerDelegate.h"

@interface TigerPush : NSObject

+ (TigerPush *)pusher;

#define TigerPushHandler [TigerPush pusher]

- (void)pushData:(NSData *)data url:(NSString *)url completionHandler:(TaigerCompletionHandler)completionHandler;

@end
