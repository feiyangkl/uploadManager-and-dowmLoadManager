//
//  DownloadManage.h
//  DownloadManager and downLoadManager
//
//  Created by feiyangkl on 16/11/8.
//  Copyright © 2016年 feiyangkl. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DownloadModel;

@interface DownloadManage : NSObject
/// 下载管理器中的下载数据
@property (nonatomic, readonly, strong) NSMutableArray *DownLoadDataModels;

/// 将上传管理器,单例化
+ (instancetype)shareDownloadManager;
/// 将数据添加到上传管理器中
- (void)addVideoModels:(NSMutableArray<DownloadModel *> *)DownLoadDataModels;
/// 开始上传
- (void)startWithVideoModel:(DownloadModel *)DownLoadDataModel;
/// 停止上传
- (void)stopWithVideoModel:(DownloadModel *)DownLoadDataModel;
/// 取消上传
- (void)cancelWithVideoModel:(DownloadModel *)DownLoadDataModel;


@end
