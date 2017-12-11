//
//  Engine.m
//  PositioningDome
//
//  Created by Mac on 2017/11/26.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "Engine.h"

@implementation Engine
static id _engine=nil;
static AFHTTPSessionManager *manager=nil;
#pragma mark ------单例类创建
+(instancetype)sharedEngine{
    return [[self alloc]init];
}
+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _engine=[super allocWithZone:zone];
    });
    return _engine;
}
-(instancetype)init{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _engine=[super init];
    });
    return _engine;
}
//copy在底层 会调用copyWithZone:
- (id)copyWithZone:(NSZone *)zone{
    return  _engine;
}
+ (id)copyWithZone:(struct _NSZone *)zone{
    return  _engine;
}
+ (id)mutableCopyWithZone:(struct _NSZone *)zone{
    return _engine;
}
- (id)mutableCopyWithZone:(NSZone *)zone{
    return _engine;
}
-(AFHTTPSessionManager *)manager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager==nil) {
            manager = [AFHTTPSessionManager manager];
        }
    });
     return manager;
}

#pragma mark --------网络请求封装
//post
-(void)postwithUrl:(NSString*)URL andParameter:(NSDictionary*)Parameter withSuccessBlock:(void(^)(NSDictionary*dic))succeedBlock andFailBlock:(void(^)(NSError*error))failBlock andprogressBlock:(void(^)(NSProgress*progress))progressBlock
{
  
    
    AFHTTPSessionManager *manager = [self manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"text/plain",@"text/json", @"application/json", @"text/javascript", @"text/xml", nil];
    [manager.securityPolicy setAllowInvalidCertificates:YES];
 
    [manager POST:URL parameters:Parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progressBlock(uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"=====%@",str);
        NSDictionary *dic = responseObject;
        succeedBlock(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [LCProgressHUD showFailure:@"服务器连接失败"];
        failBlock(error);
        
    }];
}

//get
-(void)getwithUrl:(NSString*)URL andParameter:(NSDictionary*)Parameter withSuccessBlock:(void(^)(NSDictionary*dic))succeedBlock andFailBlock:(void(^)(NSError*error))failBlock andprogressBlock:(void(^)(NSProgress*progress))progressBlock
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 
    [manager GET:URL parameters:Parameter progress:^(NSProgress * _Nonnull downloadProgress) {
        progressBlock(downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        succeedBlock(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failBlock(error);
    }];
}
//post
-(void)postPictureDatewithUrl:(NSString *)URL andParameter:(NSDictionary*)Parameter constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block withSuccessBlock:(void(^)(NSDictionary *dic))succeedBlock andFailBlock:(void(^)(NSError *error))failBlock andprogressBlock:(void(^)(NSProgress *progress))progressBlock
{
  
    AFHTTPSessionManager *manager =[self manager];;
    [manager POST:URL parameters:Parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        block(formData);
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progressBlock(uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
        NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"=====%@",str);
        NSDictionary *dic = responseObject;
        succeedBlock(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [LCProgressHUD showFailure:@"服务器链接失败"];
        failBlock(error);
    }];
    
    
    
    
    
    
    
}




@end