//
//  OptionsListViewController.m
//  Fastpool
//
//  Created by Ilya Sedov on 15/01/16.
//
//

#import "EFOptionsListViewController.h"


NSString *const kOptionCellReuseId = @"optionCellId";

@interface EFOptionsListViewController ()

@property (nonatomic, strong) NSMutableArray *mutableIndexes;

@end

@implementation EFOptionsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:kOptionCellReuseId];
}

- (NSMutableArray *)mutableIndexes {
    if (!_mutableIndexes) {
        _mutableIndexes = [NSMutableArray new];
    }
    return _mutableIndexes;
}

- (void)setSelectedIndexes:(NSArray *)selectedIndexes {
    self.mutableIndexes = [selectedIndexes mutableCopy];
}

- (NSArray *)selectedIndexes {
    return [self.mutableIndexes copy];
}

- (void)setSelectedObjects:(NSArray *)selectedObjects {
    [self.mutableIndexes removeAllObjects];
    for (id obj in selectedObjects) {
        NSUInteger index = [self.options indexOfObject:obj];
        [self.mutableIndexes addObject:@(index)];
    }
}

- (NSArray *)selectedObjects {
    NSMutableArray *selected = [NSMutableArray new];
    for (NSNumber *index in self.selectedIndexes) {
        [selected addObject:self.options[[index integerValue]]];
    }
    return [selected copy];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOptionCellReuseId
                                                            forIndexPath:indexPath];
    NSDictionary *option = self.options[indexPath.row];
    cell.textLabel.text = option[self.optionTitleKey?: @"title"];
    if ([self.selectedIndexes containsObject:@(indexPath.row)]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.allowMultiply) {
        [self.mutableIndexes removeAllObjects];
    }

    [self.mutableIndexes addObject:@(indexPath.row)];
    [tableView reloadData];
    if (self.onSelect) {
        self.onSelect(indexPath.row, self.options[indexPath.row]);
    }
}

@end
