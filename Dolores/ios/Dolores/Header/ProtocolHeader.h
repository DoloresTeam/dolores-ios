//
//  ProtocolHeader.h
//  Dolores
//
//  Created by Heath on 18/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#ifndef ProtocolHeader_h
#define ProtocolHeader_h


@protocol DLBaseControllerProtocol <NSObject>

@optional

- (void)setupView;
- (void)setupData;
- (void)setupNavigationBar;
- (void)setupViewConstraints;

@end

@protocol DLContactCellDelegate <NSObject>

@optional
- (void)tableViewCell:(UITableViewCell *)cell didSelectButton:(UIButton *)sender;
- (void)tableViewCell:(UITableViewCell *)cell didTapAvatar:(NSString *)userId;

@end

@protocol DLGroupChatDelegate <NSObject>

@optional
- (void)createGroupSuccess:(NSString *)groupId;

@end

#endif /* ProtocolHeader_h */


