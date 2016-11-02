//
//  uploadManager.m
//  uploadManager and downLoadManager
//
//  Created by lanxum on 16/11/2.
//  Copyright © 2016年 feiyangkl. All rights reserved.
//

#import "uploadManager.h"
#import "UploadModel.h"
#import "AFNetworking.h"
static uploadManager *_uploadManager = nil;
@interface uploadManager ()
/// 上传管理器中的上传数据
@property (nonatomic, strong) NSMutableArray *upLoadDataModels;
/// 网络管理者
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end


@implementation uploadManager

/// 将上传管理器,单例化
+ (instancetype)shareUploadManager {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _uploadManager = [[uploadManager alloc] init];
    });
    return _uploadManager;
}

- (instancetype)init {
    if (self = [super init]) {
        _upLoadDataModels = [NSMutableArray array];
    }
    
    return self;
}
- (id)copyWithZone:(NSZone *)zone
{
    return _uploadManager;
}


/// 将数据添加到上传管理器中
- (void)addVideoModels:(NSMutableArray<UploadModel *> *)UpLoadDataModels {

    [self.upLoadDataModels addObjectsFromArray:UpLoadDataModels];
}
/// 开始上传
- (void)startWithVideoModel:(UploadModel *)upLoadDataModel {

    //多线程判断任务是否存在 存在不执行上传方法(防止多线程下的)
    for (NSURLSessionUploadTask *task  in self.sessionManager.uploadTasks) {
        if ( [task.taskDescription isEqualToString:upLoadDataModel.url]) {
            return;
        }
    }
    // 只用是waitting时才能去上传
    if (upLoadDataModel.status == XHTUploadStateWaiting) {
        
        [self uploadingModel:upLoadDataModel];
        
    }
  
}
/// 停止上传
- (void)stopWithVideoModel:(UploadModel *)upLoadDataModel {
    for (NSURLSessionUploadTask *task  in self.sessionManager.uploadTasks) {
        if ( [task.taskDescription isEqualToString:upLoadDataModel.url]) {
            [task suspend];
            return;
        }
    }
    

}
/// 取消上传
- (void)cancelWithVideoModel:(UploadModel *)upLoadDataModel {

    for (NSURLSessionUploadTask *task  in self.sessionManager.uploadTasks) {
        if ( [task.taskDescription isEqualToString:upLoadDataModel.url]) {
             [task cancel];
            return;
        }
    }
}

- (void)uploadingModel:(UploadModel *)model{
    //    model.status = XHTUploadStateUploading;
    NSDictionary *parms =@{@"user":@"id"};
    NSString *URL = @"127.0.0.1";

    //  将上传文件转换为data
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.url]];
    
    // 序列化请求
    AFHTTPRequestSerializer *Serializer=[[AFHTTPRequestSerializer alloc]init];
    // 创建request
    NSMutableURLRequest *request =
    [Serializer multipartFormRequestWithMethod:@"POST"
                                     URLString:URL
                                    parameters:parms
                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                         
                         [formData appendPartWithFileData:data name:@"fileData" fileName:model.url.lastPathComponent mimeType:model.fileType];
                         
                     } error:nil];
    
    
    NSURLSessionUploadTask *uploadTask = [self.sessionManager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        
        CGFloat progress = uploadProgress.fractionCompleted;
        
        dispatch_async(dispatch_get_main_queue(), ^{

            model.status = XHTUploadStateUploading;
            model.progress = progress;
        });
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"错误");
            
            CGFloat progress = 0;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                model.progress = progress;
            });
            model.status = XHTUploadStateFailed;
            
            
        }else {
            
            model.status = XHTUploadStateCompleted;
         
        }
    }];
    
         uploadTask.taskDescription = model.url;
         [uploadTask resume];
    
    
}

- (AFHTTPSessionManager *)sessionManager {
    
    if (!_sessionManager) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];//设置返回数据为json
        _sessionManager.requestSerializer.timeoutInterval= 20;
        _sessionManager.operationQueue.maxConcurrentOperationCount = 2;
        
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                                          @"text/html",
                                                                                          @"text/json",
                                                                                          @"text/plain",
                                                                                          @"text/javascript",
                                                                                          @"text/xml",
                                                                                          @"image/*"]];
    }
    return _sessionManager;
}




@end
