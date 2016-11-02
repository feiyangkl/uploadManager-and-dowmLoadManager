//
//  UploadModel.h
//  uploadManager and downLoadManager
//
//  Created by feiyangkl on 16/11/2.
//  Copyright © 2016年 feiyangkl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class UploadModel;
typedef NS_ENUM(NSUInteger,UploadState){
XHTUploadStateNone = 0,       //未开始上传
XHTUploadStateWaiting = 1,    //等待上传
XHTUploadStateUploading = 2,  //上传中
XHTUploadStateCompleted = 3,  //上传完成
XHTUploadStateFailed = 4,     // 上传失败
};

typedef void(^StatusChanged)(UploadModel *model);
typedef void(^ProgressChanged)(UploadModel *model);

@interface UploadModel : NSObject

/// 上传文件url
@property(nonatomic,copy)NSString *url;
/// 状态文字
@property (nonatomic, readonly, copy) NSString *statusText;
/// 进度
@property (nonatomic, assign) CGFloat progress;
/// 状态
@property (nonatomic, assign)UploadState status;
/// 状态改变的回调
@property (nonatomic, copy) StatusChanged onStatusChanged;
/// 进度改变的回调
@property (nonatomic, copy) ProgressChanged onProgressChanged;
/// 上传的文件类型
@property (nonatomic, copy) NSString *fileType; //image/mov

@end
