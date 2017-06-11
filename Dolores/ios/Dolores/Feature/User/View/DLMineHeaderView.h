//
//  DLMineHeaderView.h
//  Dolores
//
//  Created by Heath on 19/05/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MineHeaderDelegate <NSObject>

- (void)didTapUserAvatar;

@end

@interface DLMineHeaderView : UIView

@property (nonatomic, weak) id <MineHeaderDelegate> delegate;

- (void)updateUserInfo:(RMStaff *)user;
@end
