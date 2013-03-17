//
//  CollectionCell.h
//  LanTaiOrder
//
//  Created by Ruby on 13-3-6.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionCell : UICollectionViewCell{
    UIImageView *prodImage;
    UILabel *prodName;
}

@property (nonatomic,strong) IBOutlet UILabel *prodName;
@property (nonatomic,strong) IBOutlet UIImageView *prodImage;


@end
