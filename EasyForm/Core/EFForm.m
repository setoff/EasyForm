//
//  Form.m
//  easyForm
//
//  Created by Ilya Sedov on 14/01/16.
//  Copyright © 2016 EasyForm. All rights reserved.
//

#import "EFForm.h"


@interface EFForm ()

/// Array of visible EFSections
@property (nonatomic, strong) NSArray *actualSections;

@end

@implementation EFForm

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

- (EFSection *)sectionWithTag:(NSString *)tag {
    NSPredicate *sectionTag = [NSPredicate predicateWithFormat:@"tag == %@", tag];
    return [[self.sections filteredArrayUsingPredicate:sectionTag] firstObject];
}

- (void)setSections:(NSArray *)sections {
    __weak typeof(self)weakSelf = self;
    if ([_sections count]) {
        [self enumerateSections:^(EFSection *section) {
            [section removeObserver:weakSelf forKeyPath:@"hidden"];
        }];
    }
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

        [section addObserver:weakSelf
                  forKeyPath:@"hidden"
                     options:NSKeyValueObservingOptionNew
                     context:NULL];
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

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context
{
    if ([object isKindOfClass:[EFSection class]] && [keyPath isEqualToString:@"hidden"]) {
        NSPredicate *filter = [NSPredicate predicateWithFormat:@"hidden == NO"];
        self.actualSections = [self.sections filteredArrayUsingPredicate:filter];
    }
}

#pragma mark - UITableView DataSource & Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.actualSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    EFSection *formSection = self.actualSections[section];
    return [formSection.elements count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EFElement *element = self.actualSections[indexPath.section][indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:element.tag];
    if (!cell) {
        cell = [self buildCellForElement:element];
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    EFElement *element = self.actualSections[indexPath.section][indexPath.row];
    element.setupCell(cell);
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

#pragma mark - Build cells

- (UITableViewCell *)buildCellForElement:(EFElement *)element {
    UITableViewCell *cell;
    if (element.nibName) {
        cell = (UITableViewCell *)[[[NSBundle mainBundle] loadNibNamed:element.nibName
                                                                 owner:self
                                                               options:nil] lastObject];
        cell.selectionStyle = element.cellSelectionStyle;
    } else {
        cell = [[element.cellClass alloc] initWithStyle:element.cellStyle
                                        reuseIdentifier:element.tag];
        cell.selectionStyle = element.cellSelectionStyle;
    }

    return cell;
}

@end
