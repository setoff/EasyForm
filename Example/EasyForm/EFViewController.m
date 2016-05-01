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
#import <EasyForm/EFSwitchCell.h>
#import <EasyForm/EFForm.h>
#import <EasyForm/EFArrayDataSource.h>
#import <EasyForm/EFCellModel.h>
#import "AutolayoutCell.h"

@interface EFViewController ()

@property (nonatomic, strong) EFForm *exampleForm;

@property (nonatomic, strong) EFCellsDemoForm *cellsForm;

@property (nonatomic, assign) BOOL optionVisible;

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

    self.optionVisible = YES;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    EFElement *thisRowIsOptional = [[EFElement alloc] initWithTag:@"optionalRow"];
    thisRowIsOptional.cellHeight = UITableViewAutomaticDimension;
    thisRowIsOptional.setupCell = ^(UITableViewCell *cell) {
        cell.textLabel.text = @"This row is optional. Its visibility depends on value of `optionVisible` flag.";
        cell.textLabel.numberOfLines = 0;
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    };

    thisRowIsOptional.isVisible = ^{
        return self.optionVisible;
    };

    EFElement *hideRowBtn = [[EFElement alloc] initWithTag:@"hideFormTag"
                                                 cellClass:[EFSwitchCell class]];
    hideRowBtn.setupCell = ^(UITableViewCell *cell) {
        ((EFSwitchCell *)cell).titleLabel.text = [NSString stringWithFormat:@"Row below is %@",
                                                  self.optionVisible ? @"visible" : @"hidden"];
        ((EFSwitchCell *)cell).switchToggle.on = self.optionVisible;
        ((EFSwitchCell *)cell).switchToggle.onTintColor = [EFExampleHelpers greenColor];
        ((EFSwitchCell *)cell).onToggle = ^(BOOL isOn) {
            self.optionVisible = isOn;
            [self.tableView reloadData];
        };
    };

    EFSection *changeForm = [[EFSection alloc] initWithTag:@"changeSection"
                                                  elements:@[hideButton, change, hideRowBtn, thisRowIsOptional]];
    changeForm.title = @"Change form on fly";
    changeForm.setupTitle = ^{
        return stdCells.isHidden ? @"This is the same form with hidden section" : (NSString *)nil;
    };

    EFElement *autolayoutCell = [[EFElement alloc] initWithTag:@"autolCell"
                                                       nibName:@"AutolayoutCell"];
    autolayoutCell.cellHeight = UITableViewAutomaticDimension;
    autolayoutCell.setupCell = ^(UITableViewCell *cell) {
        AutolayoutCell *autoCell = (AutolayoutCell *)cell;

        autoCell.value.text = [[NSUUID UUID] UUIDString];
        autoCell.comment.text = @"Demo of a self-sizing cell which created from nib.";
        NSArray *list = @[@1, @234, @234, @"item #2", @234];
        autoCell.itemsList.text = [list description];
    };

    EFSection *autolSection = [[EFSection alloc] initWithTag:@"autolSection"
                                                    elements:@[autolayoutCell]];


    EFElement *dynamicElement = [[EFElement alloc] initDynamicWithTag:@"dynamicCell"];
    dynamicElement.cellStyle = UITableViewCellStyleSubtitle;
    dynamicElement.setupDynamicCell = ^(UITableViewCell *cell, EFCellModel *model) {
        cell.textLabel.text = model.title;
        cell.detailTextLabel.text = model.value;
    };
    EFArrayDataSource *src = [EFArrayDataSource dataSourceWithArray:
                              @[[EFCellModel modelWithTitle:@"Event #1"
                                                      value:[[NSDate new] description]]
                                ]];

    dynamicElement.onTap = ^(UITableViewCell *cell, EFElement *item) {
        NSString *eventTitle = [NSString stringWithFormat:@"Event #%@", @([src count] + 1)];
        [src add:[EFCellModel modelWithTitle:eventTitle
                                       value:[[NSDate new] description]]];
        [self.tableView reloadData];
    };

    EFSection *dynSection = [[EFSection alloc] initWithTag:@"dynSection"
                                                   element:dynamicElement
                                                dataSource:src];
    dynSection.title = @"Tap on cell to add more rows";


    self.exampleForm = [EFForm new];
    self.exampleForm.sections = @[stdCells, changeForm, autolSection, dynSection];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
