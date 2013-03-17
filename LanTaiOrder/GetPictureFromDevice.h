//
//  AppDelegate.m
//  Dida
//
//  Created by test on 8/11/12.
//  Copyright (c) 2012 aurora. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PictureCell.h"

typedef enum {
    kAllType,
    kPhotoType,
    kMovieType
} FileType;

@protocol GetPictureFromDeviceDelegate;

@interface GetPictureFromDevice : NSObject
<UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    NSData *fileData_;
    FileType fileType_;
    NSString *fileName_;
    NSURL *fileUrl_;
    id<GetPictureFromDeviceDelegate> delegate_;
}

@property (nonatomic, strong) NSURL *fileUrl;
@property (nonatomic, strong) NSData *fileData;
@property (nonatomic, assign) FileType fileType;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) id<GetPictureFromDeviceDelegate> delegate;
@property (nonatomic, strong) id parentController;
@property (nonatomic,strong) PictureCell *picCell;

- (id)initWithParentViewController:(id)pc;
- (void)takePhotoWithCamera;
- (void)getPhotoFromLibrary;
@end

@protocol GetPictureFromDeviceDelegate <NSObject>
- (void)didGetFileWithFile:(GetPictureFromDevice *)getFile;
@optional
- (void)didGetFileFailedWithMessage:(NSString *)mes;
@end