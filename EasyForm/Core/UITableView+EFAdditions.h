//
//  UITableView+EFAdditions.h
//  Pods
//
//  Created by Ilya Sedov on 25/01/16.
//
//

#import <UIKit/UIKit.h>

@class EFForm;
@interface UITableView (EFAdditions)

- (void)displayForm:(EFForm *)form;

@end
