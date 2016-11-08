//
//  DownloadManage.m
//  uploadManager and downLoadManager
//
//  Created by feiyangkl on 16/11/8.
//  Copyright © 2016年 feiyangkl. All rights reserved.
//

#import "DownloadManage.h"
#import "DownloadModel.h"
#import "AFNetworking.h"

@interface DownloadManage ()
/// 下载管理器中的下载数据
@property (nonatomic, strong) NSMutableArray *DownLoadDataModels;

@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;
@end
static DownloadManage *_downloadManage;
@implementation DownloadManage



/// 将下载管理器,单例化
+ (instancetype)shareDownloadManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _downloadManage = [[DownloadManage alloc] init];
    });
    return _downloadManage;
}


- (instancetype)init {
    if (self = [super init]) {
        _DownLoadDataModels = [NSMutableArray array];
    }
    
    return self;
}
- (id)copyWithZone:(NSZone *)zone
{
    return _downloadManage;
}


/// 将数据添加到下载管理器中
- (void)addVideoModels:(NSMutableArray<DownloadModel *> *)DownLoadDataModels {
    
    [self.DownLoadDataModels addObjectsFromArray:DownLoadDataModels];
}
/// 开始下载
- (void)startWithVideoModel:(DownloadModel *)DownLoadDataModel {
    //多线程判断任务是否存在 存在不执行上传方法(防止多线程下的)
    for (NSURLSessionUploadTask *task  in self.sessionManager.uploadTasks) {
        if ( [task.taskDescription isEqualToString:DownLoadDataModel.url]) {
            return;
        }
    }
    
    if (DownLoadDataModel.status == DownloadStateWaiting ) {
        [self startDown:DownLoadDataModel];
    }
}
/// 停止下载
- (void)stopWithVideoModel:(DownloadModel *)DownLoadDataModel {
    for (NSURLSessionDownloadTask *task in self.sessionManager.downloadTasks) {
        if ([task.taskDescription isEqualToString:DownLoadDataModel.url]) {
            DownLoadDataModel.status = DownloadStatesuspend;
            [task suspend];
        }
    }
}
/// 取消下载
- (void)cancelWithVideoModel:(DownloadModel *)DownLoadDataModel {
    for (NSURLSessionDownloadTask *task in self.sessionManager.downloadTasks) {
        if ([task.taskDescription isEqualToString:DownLoadDataModel.url]) {
            DownLoadDataModel.status = DownloadStateNone;
            [task cancel];
        }
    }
}

/// 下载
- (void)startDown:(DownloadModel *)model {
    
    NSDictionary *parameter = @{@"nodef":@"123"};
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request =[serializer requestWithMethod:@"GET" URLString:model.url parameters:parameter error:nil];
    
    NSURLSessionDownloadTask *task = [self.sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        model.status = DownloadStateDownloading;
        model.progress = downloadProgress.fractionCompleted;
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
//        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//        NSString *filePath = [NSString stringWithFormat:@"%@/allImages",pathDocuments];
//        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        NSURL *path = [NSURL fileURLWithPath:pathDocuments];
        // 返回一个下载路径
        return [path URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        if (error) {
            model.status = DownloadStateFailed;
            NSLog(@"失败");
        }else {
            // 下载的数据
//            NSData *data=[NSData dataWithContentsOfURL:filePath];
            
            model.status = DownloadStateCompleted;
            NSLog(@"Success");
        }
        
    }];
    task.taskDescription = model.url;
    [task resume];
    
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
