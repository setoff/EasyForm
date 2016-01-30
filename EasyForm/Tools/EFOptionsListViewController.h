//
//  OptionsListViewController.h
//  Fastpool
//
//  Created by Ilya Sedov on 15/01/16.
//
//

#import <UIKit/UIKit.h>

@interface EFOptionsListViewController : UITableViewController

/// Array of dictionaries. You should specify optionTitleKey to point which field is option title.
@property (nonatomic, strong) NSArray *options;

/// Options title. Key from options dictionaries used to display option name. By default "title".
@property (nonatomic, copy) NSString *optionTitleKey;

/// Array of NSNumbers of selected options indexes.
@property (nonatomic, strong) NSArray *selectedIndexes;

/**
 You may specify selected objects instead of selectedIndexes. 
    If you specify both `selectedIndexes` will has been rewritten in according to this array.
 */
@property (nonatomic, strong) NSArray *selectedObjects;

/// If YES it is possible to choose several options. NO by default.
@property (nonatomic, assign) BOOL allowMultiply;

/// Called after option has been selected. In args passed index of selected option and option itself.
@property (nonatomic, copy) void (^onSelect)(NSInteger index, NSDictionary *option);

@end
