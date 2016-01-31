//
//  EFViewController.m
//  EasyForm
//
//  Created by Ilya Sedov on 01/25/2016.
//  Copyright (c) 2016 Ilya Sedov. All rights reserved.
//

#import "EFViewController.h"
#import "EFExampleHelpers.h"
#import "EFCellsDemoForm.h"
#import <EasyForm/EFForm.h>

@interface EFViewController ()

@property (nonatomic, strong) EFForm *exampleForm;

@property (nonatomic, strong) EFCellsDemoForm *cellsForm;

@end

@implementation EFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Easy Demo";

    void(^onTap)(UITableViewCell *, EFElement *) = ^(UITableViewCell *cell, EFElement *item) {
        [self alertAction:cell.detailTextLabel.text];
        NSIndexPath *cellIndex = [self.tableView indexPathForCell:cell];
        [self.tableView deselectRowAtIndexPath:cellIndex animated:YES];
    };

    // Section which uses UITableViewCell customizing abilities.
    EFElement *value2 = [[EFElement alloc] initWithTag:@"value2"];
    value2.cellStyle = UITableViewCellStyleValue2;
    value2.setupCell = ^(UITableViewCell *cell) {
        cell.textLabel.text = @"Cell style";
        cell.detailTextLabel.text = @"value 2";
    };
    value2.onTap = onTap;

    EFElement *subtitle = [[EFElement alloc] initWithTag:@"subtitle"];
    subtitle.cellStyle = UITableViewCellStyleSubtitle;
    subtitle.setupCell = ^(UITableViewCell *cell) {
        cell.textLabel.text = @"Cell style";
        cell.detailTextLabel.text = @"subtitle";
    };
    subtitle.onTap = onTap;

    EFSection *stdCells = [[EFSection alloc] initWithTag:@"stdSetion"
                                                elements:@[subtitle, value2]];
    stdCells.title = @"UITableViewCells showcase";

    EFElement *change = [[EFElement alloc] initWithTag:@"change"];
    change.setupCell = ^(UITableViewCell *cell) {
        cell.textLabel.text = @"Tap to check EasyForm cells";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [EFExampleHelpers lightGrayColor];
        cell.backgroundColor = [EFExampleHelpers blueColor];
    };
    change.onTap = ^(UITableViewCell *cell, EFElement *item) {
        [self prepareForm2];
        [self.tableView displayForm:self.cellsForm];
    };

    EFElement *hideButton = [[EFElement alloc] initWithTag:@"hideSection"];
    hideButton.setupCell = ^(UITableViewCell *cell) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@ first section",
                               stdCells.isHidden ? @"Show" : @"Hide"];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.backgroundColor = [EFExampleHelpers redColor];
        cell.textLabel.textColor = [EFExampleHelpers lightGrayColor];
    };
    hideButton.onTap = ^(UITableViewCell *cell, EFElement *item) {
        stdCells.hidden = !stdCells.hidden;
    };

    EFSection *changeForm = [[EFSection alloc] initWithTag:@"changeSection"
                                                  elements:@[hideButton, change]];
    changeForm.title = @"Change form on fly";
    changeForm.setupTitle = ^{
        return stdCells.isHidden ? @"This is the same form with hidden section" : (NSString *)nil;
    };

    self.exampleForm = [EFForm new];
    self.exampleForm.sections = @[stdCells, changeForm];

    [self.tableView displayForm:self.exampleForm];
}

- (void)prepareForm2 {
    if (self.cellsForm) { // do not prepare form twice
        return;
    }

    self.cellsForm = [EFCellsDemoForm new];
    self.cellsForm.presentingController = self;
    __weak typeof(self)weakSelf = self;
    self.cellsForm.backToPrevious = ^{
        [weakSelf.tableView displayForm:weakSelf.exampleForm];
    };
    [self.cellsForm buildForm];
}

@end
