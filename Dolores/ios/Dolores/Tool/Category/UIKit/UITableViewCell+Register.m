//
//  UITableViewCell+Register.m
//  CategoryCollection
//
//  Created by Heath on 27/03/2017.
//  Copyright © 2017 Heath. All rights reserved.
//

#import "UITableViewCell+Register.h"

@implementation UIView (Identifier)

+ (NSString *)identifier {
    NSString *classStr = NSStringFromClass(self);
    return [NSString stringWithFormat:@"%@_identifier", classStr];
}

@end

@implementation UITableViewCell (Register)

+ (void)registerIn:(UITableView *)tableView {
    [tableView registerClass:[self class] forCellReuseIdentifier:[self identifier]];
}

@end

@implementation UITableViewHeaderFooterView (Register)

+ (void)registerIn:(UITableView *)tableView {
    [tableView registerClass:[self class] forHeaderFooterViewReuseIdentifier:[self identifier]];
}

@end

@implementation UICollectionViewCell (Register)

+ (void)registerIn:(UICollectionView *)collectionView {
    [collectionView registerClass:[self class] forCellWithReuseIdentifier:[self identifier]];
}

@end



