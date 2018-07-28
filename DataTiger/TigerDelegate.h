//
//  TigerDelegate.h
//  DataTiger
//
//  Created by BruceZCQ on 5/23/15.
//  Copyright (c) 2015 BruceZCQ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TaigerCompletionHandler)(NSError *error);

@interface TigerDelegate : NSObject

@property (nonatomic, copy) TaigerCompletionHandler completionHandler;

@end
