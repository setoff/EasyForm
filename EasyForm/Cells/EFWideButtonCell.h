//
//  EFWideButtonCell.h
//  Pods
//
//  Created by Ilya Sedov on 27/01/16.
//
//

#import <UIKit/UIKit.h>

@interface EFWideButtonCell : UITableViewCell

/// Button view placed on cell
@property (nonatomic, strong) UIButton *button;

/// This calls when user taps on button
@property (nonatomic, copy) void (^onTap)();

@end
