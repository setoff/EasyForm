//
//  EFSwitchCell.h
//  Pods
//
//  Created by Ilya Sedov on 27/01/16.
//
//

#import <UIKit/UIKit.h>

@interface EFSwitchCell : UITableViewCell

@property (nonatomic, strong) UISwitch *switchToggle;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, copy) void (^onToggle)(BOOL isOn);

@end
