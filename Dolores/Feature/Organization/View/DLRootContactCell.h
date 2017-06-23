//
// Created by Heath on 23/06/2017.
// Copyright (c) 2017 Dolores. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DLRootContactCell : UITableViewCell

@property (nonatomic, strong) UIImageView *imgPlace;
@property (nonatomic, strong) UILabel *lblTitle;

- (void)updateImage:(UIImage *)image title:(NSString *)title;

- (void)updateHead:(NSString *)avatarURL title:(NSString *)title;
@end
