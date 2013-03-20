//
//  CollectionViewLayout.m
//  LanTaiOrder
//
//  Created by Ruby on 13-3-6.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "CollectionViewLayout.h"

@implementation CollectionViewLayout

- (id)init{
    self = [super init];
    if (self) {
        self.minimumInteritemSpacing = 30;
        self.itemSize = CGSizeMake(160, 180);
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.sectionInset = UIEdgeInsetsMake(20, 20, 0, 20);
        
    }
    return self;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForSupplementaryViewOfKind:kind atIndexPath:indexPath];
//    attrs.representedElementCategory = UICollectionElementCategorySupplementaryView;
    return attrs;
}
@end
