//
//  DownloadModel.m
//  DownloadManager and downLoadManager
//
//  Created by feiyangkl on 16/11/8.
//  Copyright © 2016年 feiyangkl. All rights reserved.
//

#import "DownloadModel.h"

@implementation DownloadModel

/// 当进度改变的时候,回到进度改变block
- (void)setProgress:(CGFloat)progress {
    if (_progress != progress) {
        _progress = progress;
        
        if (self.onProgressChanged) {
            self.onProgressChanged(self);
        } else {
            NSLog(@"progress changed block is empty");
        }
    }
}

/// 同理,当状态改变的时候,回调状态改变block
- (void)setStatus:(DownloadState)status {
    if (_status != status) {
        _status = status;
        
        if (self.onStatusChanged) {
            self.onStatusChanged(self);
        }
    }
}

/// 根据状态的改变,随机改变更新文件
- (NSString *)statusText {
    switch (self.status) {
        case DownloadStateNone: {
            return @"下载";
            break;
        }
        case DownloadStateDownloading: {
            return @"下载中";
            break;
            
        }
        case DownloadStateCompleted: {
            return @"下载完成";
            break;
        }
        case DownloadStateFailed: {
            return @"下载失败";
            break;
        }
        case DownloadStatesuspend: {
            return @"停止";
            break;
        }
        case DownloadStateWaiting: {
            return @"等待下载";
            break;
        }
    }
}

@end
