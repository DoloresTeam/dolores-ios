//
//  DLSearchResultController.h
//  Dolores
//
//  Created by Heath on 26/04/2017.
//  Copyright © 2017 Dolores. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLBaseViewController.h"

@interface DLSearchResultController : UIViewController <UISearchResultsUpdating, UISearchControllerDelegate>

@property (nonatomic, weak) UISearchController *searchController;

@end
