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
#import "EFCellModel.h"
#import "EFArrayDataSource.h"
#import "UITableViewCellSubtitle.h"
#import "UITableViewCellValue1.h"


#pragma mark - Elenent created from class

SpecBegin(InitialSpecs)


describe(@"Element", ^{
    __block EFForm *testForm;
    __block UITableView *tableView;
    __block EFSection *section;
    NSString *const kStdTag = @"stdTag1";
    __block EFElement *testElement;

    NSIndexPath *const indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    beforeEach(^{
        testForm = [EFForm new];
        tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                 style:UITableViewStylePlain];

        [tableView displayForm:testForm];
        testElement = [[EFElement alloc] initWithTag:kStdTag
                                              cellClass:[UITableViewCell class]
                                                nibName:nil];

        section = [[EFSection alloc] initWithTag:@"byClassName" elements:@[testElement]];
        testForm.sections = @[section];
    });

    afterEach(^{
        testForm = nil;
        tableView = nil;
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
        expect(cell).to.beInstanceOf([UITableViewCellSubtitle class]);
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

    it(@"can be hidden", ^{
        testElement.isVisible = ^{
            return NO;
        };
        expect([testForm tableView:tableView numberOfRowsInSection:0]).to.equal(0);
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
        [tableView displayForm:testForm];
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
        [tableView displayForm:testForm];
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

    it(@"sets section header title", ^{
        NSString *expectedTitle = @"Section one title";
        sectionOne.title = expectedTitle;
        NSString *sectionsTitle = [testForm tableView:tableView
                              titleForHeaderInSection:0];
        expect(sectionsTitle).to.equal(expectedTitle);
    });

    it(@"sets section header by block", ^{
        NSString *expectedTitle = @"dynamic title";
        __block BOOL calledBlock = NO;
        sectionOne.setupTitle = ^{
            calledBlock = YES;
            return expectedTitle;
        };
        NSString *buildedTitle = [testForm tableView:tableView titleForHeaderInSection:0];
        expect(buildedTitle).to.equal(expectedTitle);
        expect(calledBlock).to.beTruthy();
    });

    it(@"able to create custom section view", ^{
//        BOOL implemented = NO;
//        expect(implemented).to.equal(YES);
    });
});

#pragma mark - Form cases

describe(@"Form", ^{
    __block EFForm *testForm;
    __block UITableView *tableView;
    beforeAll(^{
        testForm = [EFForm new];
        tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                 style:UITableViewStylePlain];
    });

    it(@"cleans reuse all identifier before display", ^{

        EFForm *form2 = [EFForm new];
        EFElement *el2 = [[EFElement alloc] initWithTag:@"sameTag" nibName:@"TestCell"];
        EFSection *sec2 = [[EFSection alloc] initWithTag:@"sec2" elements:@[el2]];
        form2.sections = @[sec2];
        [tableView displayForm:form2];

        UITableViewCell *cell2 = [form2 tableView:tableView
                            cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        expect(cell2).to.notTo.beInstanceOf([UITableViewCellValue1 class]);

        EFElement *el1 = [[EFElement alloc] initWithTag:@"sameTag"];
        el1.cellStyle = UITableViewCellStyleValue1;
        EFSection *sec1 = [[EFSection alloc] initWithTag:@"sec1" elements:@[el1]];
        testForm.sections = @[sec1];
        [tableView displayForm:testForm];

        UITableViewCell *cell1 = [testForm tableView:tableView
                               cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        expect(cell1).to.beInstanceOf([UITableViewCellValue1 class]);
    });

});


#pragma mark - Dynamic sections

describe(@"Dynamic section", ^{
    __block EFForm *testForm;
    __block UITableView *tableView;
    __block EFArrayDataSource *dataSource;
    beforeAll(^{
        testForm = [EFForm new];
        tableView = [[UITableView alloc] initWithFrame:CGRectZero
                                                 style:UITableViewStylePlain];
        dataSource = [EFArrayDataSource dataSourceWithArray:
               @[
                 [EFCellModel modelWithTitle:@"test row 1" value:@"val 1"],
                 [EFCellModel modelWithTitle:@"test row 2" value:@"val 2"]]];
    });

    EFElement *dynamicElement = [[EFElement alloc] initDynamicWithTag:@"reusableCell"];
    dynamicElement.setupDynamicCell = ^(UITableViewCell *cell, EFCellModel *info) {
        cell.textLabel.text = info.title;
        cell.detailTextLabel.text = info.value;
    };
    EFSection *section = [[EFSection alloc] initWithTag:@"dynamicSection"
                                                element:dynamicElement
                                             dataSource:dataSource];
    beforeEach(^{
        testForm.sections = @[section];
        [tableView displayForm:testForm];
    });

    it(@"allows to create dynamic number of cell with the same type", ^{
        expect([testForm tableView:tableView numberOfRowsInSection:0]).to.equal(2);

        UITableViewCell *cell1 = [testForm tableView:tableView
                              cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        expect(cell1.textLabel.text).to.equal(@"test row 1");
        expect(cell1.detailTextLabel.text).to.equal(@"val 1");

        UITableViewCell *cell2 = [testForm tableView:tableView
                               cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        expect(cell2.textLabel.text).to.equal(@"test row 2");
        expect(cell2.detailTextLabel.text).to.equal(@"val 2");
    });

    it(@"immediately react on adding data to source", ^{
        [dataSource add:[EFCellModel modelWithTitle:@"test row 3" value:@"val 3"]];

        expect([testForm tableView:tableView numberOfRowsInSection:0]).to.equal(3);
        UITableViewCell *cell3 = [testForm tableView:tableView
                               cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        expect(cell3.textLabel.text).to.equal(@"test row 3");
        expect(cell3.detailTextLabel.text).to.equal(@"val 3");
    });

    it(@"immediately react on removing data", ^{
        [dataSource removeAtIndex:1];

        expect([testForm tableView:tableView numberOfRowsInSection:0]).to.equal(1);
        UITableViewCell *cell1 = [testForm tableView:tableView
                               cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        expect(cell1.textLabel.text).to.equal(@"test row 1");
        expect(cell1.detailTextLabel.text).to.equal(@"val 1");
    });

    it(@"immediately react on change data", ^{
        [dataSource updateAtIndex:0
                            model:[EFCellModel modelWithTitle:@"updated 1" value:@"updated val1"]];
        expect([testForm tableView:tableView numberOfRowsInSection:0]).to.equal(2);
        UITableViewCell *cell1 = [testForm tableView:tableView
                               cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        expect(cell1.textLabel.text).to.equal(@"updated 1");
        expect(cell1.detailTextLabel.text).to.equal(@"updated val1");
    });

});

SpecEnd

