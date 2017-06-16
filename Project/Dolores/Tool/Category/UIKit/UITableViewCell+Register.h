//
//  UITableViewCell+Register.h
//  CategoryCollection
//
//  Created by Heath on 27/03/2017.
//  Copyright © 2017 Heath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Identifier)

/**
 * get identifier: ClassName_identifier
 * @return identifier
 */
+ (NSString *)identifier;

@end

@interface UITableViewCell (Register)

+ (void)registerIn:(UITableView *)tableView;

@end

@interface UITableViewHeaderFooterView (Register)

+ (void)registerIn:(UITableView *)tableView;

@end

@interface UICollectionViewCell (Register)

+ (void)registerIn:(UICollectionView *)collectionView;

@end

