//
//  PictureCell.h
//  LanTaiOrder
//
//  Created by Ruby on 13-3-5.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PictureCellDelegate;

@interface PictureCell : UIView{
    UIButton *addBtn;
    UIImageView *carImageView;
    id<PictureCellDelegate> delegate;
}

@property (nonatomic,strong) UIButton *addBtn;
@property (nonatomic,strong) UIImageView *carImageView;
@property (nonatomic,strong) id<PictureCellDelegate> delegate;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title delegate:(id)delegate img:(NSString *)image;

@end

@protocol PictureCellDelegate <NSObject>

@optional
- (void)getCarPicture:(PictureCell *)cell;

@end
