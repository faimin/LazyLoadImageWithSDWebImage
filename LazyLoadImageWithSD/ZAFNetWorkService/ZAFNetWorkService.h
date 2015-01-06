//
//  ZAFNetWorkService.h
//  RequestNetWork
//
//  Created by apple on 14/11/21.
//  Copyright (c) 2014年 Fate.D.Saber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

//用于回调请求成功或者失败的信息
typedef void (^SucessHandle)(id responseObject);
typedef void (^FailureHandle)(NSError *error);

@interface ZAFNetWorkService : NSObject

///GET & POST请求
/**
 *  @param urlString : 请求地址
 *  @param params : 请求参数
 *  @param httpMethod : GET/POST 请求
 *  @param hasCer : 是否有证书（对于Https请求）
 *  @param sucessBlock/failureBlock : 回调block
 */
+ (AFHTTPRequestOperation *)requestWithURL:(NSString *)urlString params:(NSMutableDictionary *)params httpMethod:(NSString *)httpMethod hasCertificate:(BOOL)hasCer sucess:(SucessHandle)sucessBlock failure:(FailureHandle)failureBlock;


@end
