//
//  DLTableCellConfig.h
//  Dolores
//
//  Created by Heath on 19/05/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLTableCellConfig : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) BOOL showMore;

- (instancetype)initWithName:(NSString *)name showMore:(BOOL)showMore;


@end

@interface DLTableSectionConfig : NSObject

@property (nonatomic, copy) NSArray *cells;

- (instancetype)initWithCells:(NSArray *)cells;


@end
