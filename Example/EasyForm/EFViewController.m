//
//  EFViewController.m
//  EasyForm
//
//  Created by Ilya Sedov on 01/25/2016.
//  Copyright (c) 2016 Ilya Sedov. All rights reserved.
//

#import "EFViewController.h"
#import <EasyForm/EFForm.h>
#import <EasyForm/EFTextFieldCell.h>
#import <EasyForm/EFSwitchCell.h>
#import <EasyForm/EFWideButtonCell.h>
#import <EasyForm/EFOptionsListViewController.h>

@interface EFViewController ()

@property (nonatomic, strong) EFForm *exampleForm;

@property (nonatomic, strong) EFForm *form2;

@property (nonatomic, strong) NSArray *options;
@property (nonatomic, strong) NSDictionary *selectedOption;

@end

@implementation EFViewController

- (NSArray *)options {
    if (!_options) {
        _options = @[@{@"title": @"option 1", @"value": @"option1"},
                     @{@"title": @"option 2", @"value": @"options2"}];
    }
    return _options;
}

- (NSDictionary *)selectedOption {
    if (!_selectedOption) {
        _selectedOption = [self.options firstObject];
    }
    return _selectedOption;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    void(^onTap)(UITableViewCell *, EFElement *) = ^(UITableViewCell *cell, EFElement *item) {
        [self alertAction:cell.detailTextLabel.text];
        NSIndexPath *cellIndex = [self.tableView indexPathForCell:cell];
        [self.tableView deselectRowAtIndexPath:cellIndex animated:YES];
    };

    // Section which uses UITableViewCell customizing abilities.
    EFElement *value1 = [[EFElement alloc] initWithTag:@"value1"];
    value1.cellStyle = UITableViewCellStyleValue1;
    value1.setupCell = ^(UITableViewCell *cell) {
        cell.textLabel.text = @"Cell style";
        cell.detailTextLabel.text = @"value 1";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    };
    value1.onTap = onTap;

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

    EFElement *defCell = [[EFElement alloc] initWithTag:@"defaultCell"];
    defCell.setupCell = ^(UITableViewCell *cell) {
        cell.textLabel.text = @"Default cell";
    };
    defCell.onTap = onTap;

    EFSection *stdCells = [[EFSection alloc] initWithTag:@"stdSetion"
                                                elements:@[defCell,
                                                           subtitle,
                                                           value1,
                                                           value2]];
    stdCells.title = @"UITableViewCells showcase";


    EFElement *change = [[EFElement alloc] initWithTag:@"change"];
    change.setupCell = ^(UITableViewCell *cell) {
        cell.textLabel.text = @"tap to see check predefined cells";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    };
    change.onTap = ^(UITableViewCell *cell, EFElement *item) {
        [self prepareForm2];
        [self.tableView displayForm:self.form2];
    };

    EFSection *changeForm = [[EFSection alloc] initWithTag:@"changeSection"
                                                  elements:@[change]];
    changeForm.title = @"Change form on fly";
    changeForm.setupTitle = ^{
        return stdCells.isHidden ? @"This is the same form with hidden section" : (NSString *)nil;
    };

    self.exampleForm = [EFForm new];
    self.exampleForm.sections = @[stdCells, changeForm];

    [self.tableView displayForm:self.exampleForm];
}

- (void)prepareForm2 {
    if (self.form2) { // do not prepare form twice
        return;
    }

    self.form2 = [EFForm new];

    EFElement *input = [[EFElement alloc] initWithTag:@"inputField"
                                            cellClass:[EFTextFieldCell class]];
    input.setupCell = ^(UITableViewCell *cell) {
        ((EFTextFieldCell *)cell).textField.placeholder = @"Tap to type";
    };

    EFElement *switchElement = [[EFElement alloc] initWithTag:@"switch"
                                                    cellClass:[EFSwitchCell class]];
    switchElement.setupCell = ^(UITableViewCell *cell) {
        ((EFSwitchCell *)cell).titleLabel.text = @"Cell with switch";
        ((EFSwitchCell *)cell).onToggle = ^(BOOL isOn) {
            [self alertAction:[NSString stringWithFormat:@"Toggle is %@",
                               isOn ? @"ON" : @"OFF"]];
        };
    };

    EFElement *buttonCell = [[EFElement alloc] initWithTag:@"demoButton"
                                                 cellClass:[EFWideButtonCell class]];
    buttonCell.setupCell = ^(UITableViewCell *cell) {
        [((EFWideButtonCell *)cell).button setTitle:@"This is demo button"
                                           forState:UIControlStateNormal];
        [((EFWideButtonCell *)cell).button setTitle:@"Will display alert"
                                           forState:UIControlStateHighlighted];
        ((EFWideButtonCell *)cell).button.backgroundColor = [UIColor colorWithRed:158/255.0
                                                                            green:199/255.0
                                                                             blue:117/255.0
                                                                            alpha:1.0];
        ((EFWideButtonCell *)cell).onTap = ^{
            [self alertAction:@"Demo button has been tapped"];
        };
    };

    EFElement *optionSelect = [[EFElement alloc] initWithTag:@"optionCells"];
    optionSelect.cellStyle = UITableViewCellStyleValue1;
    optionSelect.setupCell = ^(UITableViewCell *cell) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"Options view controller demo";
        cell.detailTextLabel.text = self.selectedOption[@"title"];
    };
    optionSelect.onTap = ^(UITableViewCell *cell, EFElement *item) {
        EFOptionsListViewController *optionsViewController = [EFOptionsListViewController new];
        optionsViewController.options = self.options;
        optionsViewController.selectedObjects = @[self.selectedOption];
        optionsViewController.onSelect = ^(NSInteger index, NSDictionary *option) {
            self.selectedOption = option;
            [self.tableView reloadData];
        };

        [self.navigationController pushViewController:optionsViewController animated:YES];
    };

    EFSection *predefined = [[EFSection alloc] initWithTag:@"predefined"
                                                  elements:@[input,
                                                             switchElement,
                                                             buttonCell,
                                                             optionSelect]];
    predefined.title = @"EF provides these form cells:";


    EFElement *info = [[EFElement alloc] initWithTag:@"infoCell"];
    info.cellSelectionStyle = UITableViewCellSelectionStyleNone;
    info.cellHeight = 60.0;
    info.setupCell = ^(UITableViewCell *cell) {
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.textLabel.text = @"You may switch back to form 2 by tapping cell below.";
    };

    EFElement *back = [[EFElement alloc] initWithTag:@"backCell"];
    back.setupCell = ^(UITableViewCell *cell) {
        cell.textLabel.text = @"Back to form 1";
        cell.textLabel.textColor = [UIColor colorWithRed:73/255.0
                                                   green:172/255.0
                                                    blue:198/255.0 alpha:1.0];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    };
    back.onTap = ^(UITableViewCell *cell, EFElement *item) {
        [self.tableView displayForm:self.exampleForm];
    };

    EFSection *switchBack = [[EFSection alloc] initWithTag:@"formSection" elements:@[info, back]];
    self.form2.sections = @[predefined, switchBack];
}


- (void)alertAction:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Action"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * _Nonnull action) {
                                   [self dismissViewControllerAnimated:YES completion:nil];
                               }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
