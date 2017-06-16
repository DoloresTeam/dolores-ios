//
//  DLUser.h
//  Dolores
//
//  Created by Heath on 27/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

@protocol DLUserModel <IUserModel>

@property (nonatomic, assign) BOOL hasJoined;//是否已经加入群组
@property (nonatomic, assign) BOOL selected;//是否选中

@end

@interface DLUser : EaseUserModel <DLUserModel>

@property (nonatomic, assign) BOOL hasJoined;//是否已经加入群组
@property (nonatomic, assign) BOOL selected;//是否选中

@end
