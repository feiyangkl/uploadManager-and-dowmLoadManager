//
//  DownloadModel.h
//  DownloadManager and downLoadManager
//
//  Created by feiyangkl on 16/11/8.
//  Copyright © 2016年 feiyangkl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class DownloadModel;
typedef NS_ENUM(NSUInteger,DownloadState){
    DownloadStateNone = 0,         //未开始下载
    DownloadStateWaiting = 1,      //等待下载
    DownloadStateDownloading = 2,  //下载中
    DownloadStateCompleted = 3,    //下载完成
    DownloadStatesuspend = 4,     // 停止下载
    DownloadStateFailed = 5,       // 下载失败
};

typedef void(^StatusChanged)(DownloadModel *model);
typedef void(^ProgressChanged)(DownloadModel *model);

@interface DownloadModel : NSObject
/// 下载文件url
@property(nonatomic,copy)NSString *url;
/// 状态文字
@property (nonatomic, readonly, copy) NSString *statusText;
/// 进度
@property (nonatomic, assign) CGFloat progress;
/// 状态
@property (nonatomic, assign)DownloadState status;
/// 状态改变的回调
@property (nonatomic, copy) StatusChanged onStatusChanged;
/// 进度改变的回调
@property (nonatomic, copy) ProgressChanged onProgressChanged;
/// 下载的文件类型
@property (nonatomic, copy) NSString *fileType; //image/mov
@end
