//
//  uploadManager.h
//  uploadManager and downLoadManager
//
//  Created by feiyangkl on 16/11/2.
//  Copyright © 2016年 feiyangkl. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UploadModel;

@interface uploadManager : NSObject

/// 上传管理器中的上传数据
@property (nonatomic, readonly, strong) NSMutableArray *upLoadDataModels;
/// 将上传管理器,单例化
+ (instancetype)shareUploadManager;
/// 将数据添加到上传管理器中
- (void)addVideoModels:(NSMutableArray<UploadModel *> *)UpLoadDataModels;
/// 开始上传
- (void)startWithVideoModel:(UploadModel *)upLoadDataModel;
/// 停止上传
- (void)stopWithVideoModel:(UploadModel *)upLoadDataModel;
/// 取消上传
- (void)cancelWithVideoModel:(UploadModel *)upLoadDataModel;

@end
