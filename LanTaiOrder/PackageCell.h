//
//  PackageCell.h
//  LanTaiOrder
//
//  Created by comdosoft on 13-7-9.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PackageCell : UITableViewCell

@property (nonatomic,strong) NSMutableDictionary *packageDic;
@property (nonatomic,strong) UILabel *nameLab,*dateLab;
@property (nonatomic,strong) NSMutableArray *products;
@property (nonatomic,strong) NSIndexPath *index;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier item:(NSMutableDictionary *)item indexPath:(NSIndexPath *)idx;
@end
