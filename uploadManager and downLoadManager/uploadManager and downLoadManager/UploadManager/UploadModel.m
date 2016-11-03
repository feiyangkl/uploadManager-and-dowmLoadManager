//
//  UploadModel.m
//  uploadManager and downLoadManager
//
//  Created by lanxum on 16/11/2.
//  Copyright © 2016年 feiyangkl. All rights reserved.
//

#import "UploadModel.h"

@implementation UploadModel

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
- (void)setStatus:(UploadState)status {
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
        case UploadStateNone: {
            return @"上传";
            break;
        }
        case UploadStateUploading: {
            return @"上传中";
            break;
            
        }
        case UploadStateCompleted: {
            return @"上传完成";
            break;
        }
        case UploadStateFailed: {
            return @"上传失败";
            break;
        }
        case UploadStateWaiting: {
            return @"等待上传";
            break;
        }
    }
}


@end
