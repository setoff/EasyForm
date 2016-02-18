//
//  EFCellsDemoForm.m
//  EasyForm
//
//  Created by Ilya Sedov on 31/01/16.
//  Copyright © 2016 Ilya Sedov. All rights reserved.
//

#import "EFCellsDemoForm.h"
#import "EFExampleHelpers.h"
#import <EasyForm/EFTextFieldCell.h>
#import <EasyForm/EFSwitchCell.h>
#import <EasyForm/EFWideButtonCell.h>
#import <EasyForm/EFOptionsListViewController.h>


@interface EFCellsDemoForm ()

@property (nonatomic, strong) NSArray *options;
@property (nonatomic, strong) NSDictionary *selectedOption;

@end

@implementation EFCellsDemoForm


- (NSArray *)options {
    if (!_options) {
        _options = @[@{@"title": @"Objective-C", @"value": @0},
                     @{@"title": @"Swift", @"value": @1}];
    }
    return _options;
}

- (NSDictionary *)selectedOption {
    if (!_selectedOption) {
        _selectedOption = [self.options firstObject];
    }
    return _selectedOption;
}

- (void)buildForm {
    EFElement *input = [[EFElement alloc] initWithTag:@"inputField"
                                            cellClass:[EFTextFieldCell class]];
    input.setupCell = ^(UITableViewCell *cell) {
        ((EFTextFieldCell *)cell).textField.placeholder = @"Tap to type";
    };

    EFElement *switchElement = [[EFElement alloc] initWithTag:@"switch"
                                                    cellClass:[EFSwitchCell class]];
    switchElement.cellHeight = UITableViewAutomaticDimension;
    switchElement.setupCell = ^(UITableViewCell *cell) {
        ((EFSwitchCell *)cell).titleLabel.numberOfLines = 0;
        if (((EFSwitchCell *)cell).switchToggle.isOn) {
            ((EFSwitchCell *)cell).titleLabel.text = @"As you can see this cell builded using autolayout. One notice: you should set cellHeight property of an EFElement with `UITableViewAutomaticDimension` to self-sizing cell feature works. Now switch me off.";
        } else {
            ((EFSwitchCell *)cell).titleLabel.text = @"Switch me on";
        }

        ((EFSwitchCell *)cell).switchToggle.onTintColor = [EFExampleHelpers greenColor];
        ((EFSwitchCell *)cell).onToggle = ^(BOOL isOn) {
            [self.tableView reloadData];
        };
    };

    EFElement *buttonCell = [[EFElement alloc] initWithTag:@"demoButton"
                                                 cellClass:[EFWideButtonCell class]];
    buttonCell.setupCell = ^(UITableViewCell *cell) {
        [((EFWideButtonCell *)cell).button setTitle:@"This is a demo button"
                                           forState:UIControlStateNormal];
        [((EFWideButtonCell *)cell).button setTitle:@"Will display alert"
                                           forState:UIControlStateHighlighted];
        [((EFWideButtonCell *)cell).button setTitleColor:[EFExampleHelpers lightGrayColor]
                                                forState:UIControlStateNormal];
        ((EFWideButtonCell *)cell).button.backgroundColor = [EFExampleHelpers greenColor];

        ((EFWideButtonCell *)cell).onTap = ^{
            [self.presentingController alertAction:@"Demo button has been tapped"];
        };
    };

    EFElement *optionSelect = [[EFElement alloc] initWithTag:@"optionCells"];
    optionSelect.cellStyle = UITableViewCellStyleValue1;
    optionSelect.setupCell = ^(UITableViewCell *cell) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"What language you prefer?";
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

        [self.presentingController.navigationController pushViewController:optionsViewController
                                                                  animated:YES];
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
        cell.textLabel.text = @"❮ Back to UITableViewCells form";
        cell.textLabel.textColor = [EFExampleHelpers blueColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    };
    back.onTap = ^(UITableViewCell *cell, EFElement *item) {
        self.backToPrevious();
    };

    EFSection *switchBack = [[EFSection alloc] initWithTag:@"formSection" elements:@[info, back]];
    self.sections = @[predefined, switchBack];
}

@end
