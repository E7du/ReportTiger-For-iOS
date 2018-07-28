//
//  TigerConst.h
//  DataTiger
//
//  Created by BruceZCQ on 5/23/15.
//  Copyright (c) 2015 BruceZCQ. All rights reserved.
//

#ifndef DataTiger_TigerConst_h
#define DataTiger_TigerConst_h

#define kTigerDataToken             @"kTigerDataToken"
#define kTigerDataTokenTimeout      @"kTigerDataTokenTimeout"
#define kTigerDataTokenKey          @"token"
#define kTigerDataTokenTimeoutKey   @"timeout"

#define kDataTigerServer        @"http://localhost:8080/ReportTiger/tiger/tigermobile/"
#define kDataTigerAuthApi       [NSString stringWithFormat:@"%@authdevice",kDataTigerServer]
#define kDataTigerLogDataApi    [NSString stringWithFormat:@"%@logdata",kDataTigerServer]

#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

#endif
