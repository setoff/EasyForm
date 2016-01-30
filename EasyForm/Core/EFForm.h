//
//  Form.h
//  easyForm
//
//  Created by Ilya Sedov on 14/01/16.
//  Copyright © 2016 EasyForm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EFSection.h"
#import "EFElement.h"
#import "UITableView+EFAdditions.h"

@interface EFForm : NSObject <UITableViewDataSource, UITableViewDelegate>

/// Form sections
@property (nonatomic) NSArray *sections;

/// Table view to display form
@property (nonatomic, weak) UITableView *tableView;

/**
 Initializer set tableView's dataSource and delegate to new form instance.
 */
- (instancetype)initWithTableView:(UITableView *)tableView;

/**
 Returns section with given tag. Returns nil if section not found. If there are several sections with such tag returns th first one.
 */
- (EFSection *)sectionWithTag:(NSString *)tag;

@end
