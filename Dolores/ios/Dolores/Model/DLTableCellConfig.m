//
//  DLTableCellConfig.m
//  Dolores
//
//  Created by Heath on 19/05/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import "DLTableCellConfig.h"

@implementation DLTableCellConfig
- (instancetype)initWithName:(NSString *)name showMore:(BOOL)showMore {
    self = [super init];
    if (!self) return nil;

    _name = name;
    _showMore = showMore;

    return self;
}


@end

@implementation DLTableSectionConfig

- (instancetype)initWithCells:(NSArray *)cells {
    self = [super init];
    if (!self) return nil;

    _cells = cells;

    return self;
}


@end
