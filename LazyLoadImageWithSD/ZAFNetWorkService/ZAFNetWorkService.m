//
//  ZSNetWorkService.m
//  RequestNetWork
//
//  Created by apple on 14/11/21.
//  Copyright (c) 2014年 Fate.D.Saber. All rights reserved.
//

#import "ZAFNetWorkService.h"

#define BASE_URL @""

@implementation ZAFNetWorkService

#pragma mark - GET/POST请求
+ (AFHTTPRequestOperation *)requestWithURL:(NSString *)URLString
                                    params:(id)params
                                httpMethod:(NSString *)httpMethod
                            hasCertificate:(BOOL)hasCer
                                    sucess:(SucessHandle)sucessBlock
                                   failure:(FailureHandle)failureBlock
{
    //1.拼接URL
    NSString *URL = [NSString stringWithFormat:@"%@%@",BASE_URL,URLString];
    URL = [URL stringByReplacingOccurrencesOfString:@" " withString:@""];           //去掉URL里的空格,防止空格导致的请求崩溃
    
    URL = [URL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];     //如果路径中包含中文,需要转换成用于URL的编码格式
    
    //2.初始化请求管理对象,设置规则
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    if (hasCer) {                   ///有cer证书时AF会自动从bundle中寻找并加载cer格式的证书
        
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModePublicKey];
        securityPolicy.allowInvalidCertificates = YES;
        manager.securityPolicy = securityPolicy;
        
    }else{                         ///无cer证书的情况,忽略证书,实现Https请求
        
        manager.securityPolicy.allowInvalidCertificates = YES;
    }
    
    
    /**
     *  备用信息(设置这些参数好像没什么作用):
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        //声明返回的结果是JSON类型
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain", nil];
    */
    
    //3.发送请求
    AFHTTPRequestOperation *operation = nil;

    if ([httpMethod isEqualToString:@"GET"]) {          //GET请求
        
        operation = [manager GET:URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if (sucessBlock) {
                sucessBlock([self decodeData:responseObject]);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            if (failureBlock) {
                failureBlock(error);
            }
            
        }];

    }else if ([httpMethod isEqualToString:@"POST"]){    //POST请求
        
        BOOL isFile = NO;
        for (NSString *key in [params allKeys]) {
            
            id value = params[key];
            if ([value isKindOfClass:[NSData class]]) {
                isFile = YES;
                break;
            }
        }
        
        if (!isFile) {
            
            //参数中不包含NSData
            operation = [manager POST:URL parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                if (sucessBlock) {
                    sucessBlock([self decodeData:responseObject]);
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                if (failureBlock) {
                    failureBlock(error);
                }
                
            }];
            
        }else{
            
            //参数中包含NSData
            operation = [manager POST:URL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                
                for (NSString *key in [params allKeys]) {
                    id value = params[key];
                    //判断参数是否是文件数据
                    if ([value isKindOfClass:[NSData class]]) {
                        //将文件数据添加到formData中
                        [formData appendPartWithFileData:value name:key fileName:key mimeType:@"text/html"]; //image/jpeg、text/plain
                    }
                }
                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                if (sucessBlock) {
                    sucessBlock([self decodeData:responseObject]);
                }
                NSLog(@"response所有的头文件:%@",operation.response.allHeaderFields);
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                
                if (failureBlock) {
                    failureBlock(error);
                }
                
            }];
        }
    }
    
    /**
     *  下面如果写成 operation.responseSerializer = [AFJSONResponseSerializer serializer]会出现1016的错误
     *  除非进入到AFURLResponseSerialization->AFJSONResponseSerializer->init方法下,把self.acceptableContentTypes设置成
     *  self.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/plain",@"text/html", nil];
     *  operation.responseSerializer = [AFJSONResponseSerializer serializer];
     *  这样就可以自动解析了
     *  如果闲麻烦就按下面的方法写,返回的一般是NSData,而不是JSON数据,需要自己再手动解析一下
     */
    
    //4.返回数据的解析方式
    operation.responseSerializer = [AFHTTPResponseSerializer serializer];
    return operation;
}

///解析数据
+ (id)decodeData:(id)data
{
    return [data isKindOfClass:[NSData class]] ? [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil] : data;
}

@end
