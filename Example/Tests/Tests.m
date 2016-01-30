//
//  EasyFormTests.m
//  EasyFormTests
//
//  Created by Ilya Sedov on 01/25/2016.
//  Copyright (c) 2016 Ilya Sedov. All rights reserved.
//

// https://github.com/Specta/Specta

#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <UIKit/UIKit.h>
#import "EFForm.h"

#pragma mark - Elenent created from class

SpecBegin(InitialSpecs)


describe(@"Element", ^{
    __block EFForm *testForm;
    __block UITableView *tableView;
    beforeAll(^{
        testForm = [EFForm new];
        tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                 style:UITableViewStylePlain];
    });

    __block EFSection *section;
    NSString *const kStdTag = @"stdTag1";
    __block EFElement *testElement;

    NSIndexPath *const indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    beforeEach(^{
        testElement = [[EFElement alloc] initWithTag:kStdTag
                                              cellClass:[UITableViewCell class]
                                                nibName:nil];

        section = [[EFSection alloc] initWithTag:@"byClassName" elements:@[testElement]];
        testForm.sections = @[section];
    });

    it(@"builds cell", ^{
        UITableViewCell *cell = [testForm tableView:tableView
                              cellForRowAtIndexPath:indexPath];
        expect(cell).toNot.equal(nil);
    });

    it(@"calls setup block", ^{
        NSString *checkWord = @"check";
        testElement.setupCell = ^(UITableViewCell *cell) {
            cell.textLabel.text = checkWord;
        };
        UITableViewCell *cell = [testForm tableView:tableView
                              cellForRowAtIndexPath:indexPath];
        [testForm tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
        expect(cell.textLabel.text).to.equal(checkWord);
    });

    it(@"applies cell properties", ^{
        testElement.cellSelectionStyle = UITableViewCellSelectionStyleGray;
        testElement.cellStyle = UITableViewCellStyleSubtitle;
        testElement.cellHeight = 100;
        UITableViewCell *cell = [testForm tableView:tableView
                              cellForRowAtIndexPath:indexPath];
        expect(cell.selectionStyle).to.equal(UITableViewCellSelectionStyleGray);
        expect(cell.detailTextLabel).toNot.equal(nil);
        CGFloat height = [testForm tableView:tableView
                     heightForRowAtIndexPath:indexPath];
        expect(height).to.equal(100);
    });

    it(@"calls onTap when selected", ^{
        __block BOOL callCheck = NO;
        testElement.onTap = ^(UITableViewCell *cell, EFElement *item) {
            callCheck = YES;
        };
        [testForm tableView:tableView didSelectRowAtIndexPath:indexPath];
        expect(callCheck).to.beTruthy();
    });

    it(@"throws on duplicate tags", ^{
        expect(^{
            EFElement *sameTag = [[EFElement alloc] initWithTag:kStdTag];
            EFSection *sameTagsSection = [[EFSection alloc] initWithTag:@"sameElTags"
                                                               elements:@[testElement, sameTag]];
            testForm.sections = @[sameTagsSection];
        }).to.raiseAny();
    });
});

#pragma mark - Elenent created from NIB

describe(@"Element from NIB", ^{
    __block EFForm *testForm;
    __block UITableView *tableView;
    beforeAll(^{
        testForm = [EFForm new];
        tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                 style:UITableViewStylePlain];
    });

    NSString *const kNibName = @"TestCell";
    NSIndexPath *const kIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    beforeEach(^{
        NSString *nibTag = @"nibCell";
        EFElement *testElement = [[EFElement alloc] initWithTag:nibTag nibName:kNibName];
        EFSection *section = [[EFSection alloc] initWithTag:@"byNib" elements:@[testElement]];
        testForm.sections = @[section];
    });

    it(@"builds cell", ^{
        UITableViewCell *cell = [testForm tableView:tableView
                              cellForRowAtIndexPath:kIndexPath];
        expect(cell).toNot.equal(nil);
    });

    it(@"contains custom UI", ^{
        UITableViewCell *cell = [testForm tableView:tableView
                              cellForRowAtIndexPath:kIndexPath];
        UIView *customView = [cell.contentView viewWithTag:1];
        expect(customView).toNot.equal(nil);
        expect(customView).to.beAnInstanceOf([UISegmentedControl class]);
    });
});


#pragma mark - Sections cases

describe(@"Sections", ^{
    __block EFForm *testForm;
    __block UITableView *tableView;
    beforeAll(^{
        testForm = [EFForm new];
        tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                 style:UITableViewStylePlain];
    });

    NSString *const kTagOne = @"tagOne";
    EFSection *sectionOne = [[EFSection alloc] initWithTag:kTagOne elements:@[]];
    EFSection *sectionTwo = [[EFSection alloc] initWithTag:@"tagTwo" elements:@[]];
    beforeEach(^{
        testForm.sections = @[sectionOne, sectionTwo];
    });

    it(@"creates tableView sections", ^{
        NSInteger sections = [testForm numberOfSectionsInTableView:tableView];
        expect(sections).to.equal(2);
    });

    it(@"can be toggled", ^{
        sectionOne.hidden = YES;
        NSInteger sections = [testForm numberOfSectionsInTableView:tableView];
        expect(sections).to.equal(1);
        sectionOne.hidden = NO;
        sections = [testForm numberOfSectionsInTableView:tableView];
        expect(sections).to.equal(2);
    });

    it(@"can be found by tag", ^{
        EFSection *foundSection = [testForm sectionWithTag:kTagOne];
        expect(foundSection).to.equal(sectionOne);
    });

    it(@"can be found even if hidden", ^{
        sectionOne.hidden = YES;
        EFSection *hiddenSection = [testForm sectionWithTag:kTagOne];
        expect(hiddenSection).to.equal(sectionOne);
        expect(hiddenSection.hidden).to.beTruthy();
    });

    it(@"ok if not found by tag", ^{
        EFSection *section = [testForm sectionWithTag:@"this tag should not exists!!!"];
        expect(section).to.beNil();
    });

    it(@"returns first if tag duplicated", ^{
        EFSection *dupSection = [[EFSection alloc] initWithTag:kTagOne elements:@[]];
        testForm.sections = @[sectionOne, sectionTwo, dupSection];
        NSInteger sections = [testForm numberOfSectionsInTableView:tableView];
        expect(sections).to.equal(3);

        EFSection *found = [testForm sectionWithTag:kTagOne];
        expect(found).to.equal(sectionOne);
    });
});

SpecEnd

