//
//  Form.m
//  easyForm
//
//  Created by Ilya Sedov on 14/01/16.
//  Copyright © 2016 EasyForm. All rights reserved.
//

#import "EFForm.h"
#import "UITableViewCellValue1.h"
#import "UITableViewCellValue2.h"
#import "UITableViewCellSubtitle.h"

@interface EFForm ()

/// Array of visible EFSections
@property (nonatomic, strong) NSArray *actualSections;

@property (nonatomic, strong) NSObject *sectionVisibilityObserver;

@end

@implementation EFForm


#pragma mark - Lifecycle

- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [super init];
    if (self) {
        self.tableView = tableView;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    return self;
}

#pragma mark - Managing tableview

- (void)setTableView:(UITableView *)tableView {
    _tableView = tableView;
    self.sectionVisibilityObserver = [[NSNotificationCenter defaultCenter]
                                      addObserverForName:EFSectionHiddenStateChangedNotification
                                      object:nil
                                      queue:[NSOperationQueue mainQueue]
                                      usingBlock:^(NSNotification * _Nonnull note) {
                                          [self ef_sectionVisibleStateChanged:note];
                                      }];
    [self enumerateSections:^(EFSection *section) {
        for (EFElement *item in section.elements) {
            [self ef_unregCellClassForElement:item];
        }
    }];
}

- (EFSection *)sectionWithTag:(NSString *)tag {
    NSPredicate *sectionTag = [NSPredicate predicateWithFormat:@"tag == %@", tag];
    return [[self.sections filteredArrayUsingPredicate:sectionTag] firstObject];
}

- (void)setSections:(NSArray *)sections {
    _sections = sections;

    NSMutableArray *allTags = [NSMutableArray new];
    [self enumerateSections:^(EFSection *section) {
        // validating tag unique
        for (EFElement *item in section.elements) {
            if ([allTags containsObject:item.tag]) {
                [NSException raise:NSInternalInconsistencyException
                            format:@"Tag '%@' appears twice in form.", item.tag];
            } else {
                [allTags addObject:item.tag];
            }
        }
    }];
    self.actualSections = sections;
}

- (void)setActualSections:(NSArray *)actualSections {
    _actualSections = actualSections;
    [self.tableView reloadData];
}

- (void)enumerateSections:(void(^)(EFSection *section))eachBlock {
    NSAssert(eachBlock, @"eachBlock shouldn't be nil");
    for (EFSection *section in self.sections) {
        eachBlock(section);
    }
}

#pragma mark - Observe changes

- (void)ef_sectionVisibleStateChanged:(NSNotification *)notification {
    NSPredicate *filter = [NSPredicate predicateWithFormat:@"hidden == NO"];
    self.actualSections = [self.sections filteredArrayUsingPredicate:filter];
}

#pragma mark - UITableView DataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.actualSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    EFSection *formSection = self.actualSections[section];
    return [formSection rowsCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EFElement *element = self.actualSections[indexPath.section][indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:element.tag];
    if (!cell) {
        [self buildCellForElement:element];
        cell = [tableView dequeueReusableCellWithIdentifier:element.tag];
        cell.selectionStyle = element.cellSelectionStyle;
    }
    if (element.isDynamic) {
        EFSection *dynamicSection = self.actualSections[indexPath.section];
        element.setupDynamicCell(cell, [dynamicSection infoAtIndex:indexPath.row]);
    } else if (element.setupCell != nil) {
        element.setupCell(cell);
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    EFElement *element = self.actualSections[indexPath.section][indexPath.row];
    if (element.onTap) {
        element.onTap([tableView cellForRowAtIndexPath:indexPath], element);
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    EFSection *formSection = self.actualSections[section];
    NSString *title = formSection.title;
    if (formSection.setupTitle) {
        title = formSection.setupTitle() ?: formSection.title;
    }
    return title ?: @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    EFElement *element = self.actualSections[indexPath.section][indexPath.row];
    return element.cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    EFElement *element = self.actualSections[indexPath.section][indexPath.row];
    return element.cellHeight;
}

#pragma mark - Build cells

- (void)buildCellForElement:(EFElement *)element {
    if (element.nibName) {
        [self.tableView registerNib:[UINib nibWithNibName:element.nibName
                                                   bundle:[NSBundle mainBundle]]
             forCellReuseIdentifier:element.tag];
    } else {
        [self.tableView registerClass:[self ef__patchClassForElement:element]
               forCellReuseIdentifier:element.tag];
    }
}

- (void)ef_unregCellClassForElement:(EFElement *)element {
    [self.tableView registerNib:nil forCellReuseIdentifier:element.tag];
    [self.tableView registerClass:nil
           forCellReuseIdentifier:element.tag];
}

- (Class)ef__patchClassForElement:(EFElement *)element {
    NSAssert([element.cellClass isSubclassOfClass:[UITableViewCell class]],
             @"Cell class should be a subclass of UITableViewCell");
    if (element.cellClass == [UITableViewCell class]) {
        Class patchClass = [UITableViewCell class];
        switch (element.cellStyle) {
            case UITableViewCellStyleSubtitle:
                patchClass = [UITableViewCellSubtitle class];
                break;
            case UITableViewCellStyleValue1:
                patchClass = [UITableViewCellValue1 class];
                break;
            case UITableViewCellStyleValue2:
                patchClass = [UITableViewCellValue2 class];
                break;
            default:
                break;
        }
        return patchClass;
    }

    return element.cellClass;
}

@end
