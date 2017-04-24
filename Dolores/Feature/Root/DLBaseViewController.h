//
//  DLBaseViewController.h
//  Dolores
//
//  Created by Heath on 18/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProtocolHeader.h"

@interface DLBaseViewController : UIViewController <DLBaseControllerProtocol>

- (void)showLoadingView;

- (void)showInfo:(NSString *)info;
@end
