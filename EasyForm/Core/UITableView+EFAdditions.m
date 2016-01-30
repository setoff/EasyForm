//
//  UITableView+EFAdditions.m
//  Pods
//
//  Created by Ilya Sedov on 25/01/16.
//
//

#import "UITableView+EFAdditions.h"
#import "EFForm.h"

@implementation UITableView (EFAdditions)

- (void)displayForm:(EFForm *)form {
    self.dataSource = form;
    self.delegate = form;
    form.tableView = self;
    [self reloadData];
}

@end
