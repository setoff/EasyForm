//
//  EFSection.m
//  easyForm
//
//  Created by Ilya Sedov on 14/01/16.
//  Copyright © 2016 EasyForm. All rights reserved.
//

#import "EFSection.h"
#import "EFElement.h"
#import "EFDataSource.h"

NSString *const EFSectionHiddenStateChangedNotification = @"EFSectionHiddenStateChangedNotification";

@interface EFSection ()

@property (nonatomic, strong) NSArray *allElements;

@property (nonatomic, readonly) BOOL isDynamic;
@property (nonatomic, readonly) NSObject<EFDataSource> *dataSource;
@property (nonatomic, readonly) EFElement *dynamicElement;

@end


@implementation EFSection

- (instancetype)initWithTag:(NSString *)tag elements:(NSArray *)elements
{
    self = [super init];
    if (self) {
        _tag = tag;
        self.allElements = elements;
    }
    return self;
}

- (void)setHidden:(BOOL)hidden {
    _hidden = hidden;
    [[NSNotificationCenter defaultCenter] postNotificationName:EFSectionHiddenStateChangedNotification
                                                        object:self];
}

- (NSArray *)elements {
    return self.isDynamic ? @[self.dynamicElement] : [self staticElements];
}

- (NSInteger)rowsCount {
    return self.isDynamic ? [self.dataSource count] : [self staticElements].count;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return self.isDynamic ? self.dynamicElement : self.elements[idx];
}

#pragma mark - Static section

- (NSArray *)staticElements {
    NSMutableArray *visibleElements = [NSMutableArray new];
    for (EFElement *item in self.allElements) {
        if (item.isVisible && !item.isVisible()) {
            continue;
        }
        [visibleElements addObject:item];
    }
    return [visibleElements copy];
}


#pragma mark - Dynamic section

- (instancetype)initWithTag:(NSString *)tag
                    element:(EFElement *)dynamicElement
                 dataSource:(NSObject<EFDataSource> *)dataSource
{
    self = [super init];
    if (self) {
        _tag = tag;
        _isDynamic = YES;
        _dynamicElement = dynamicElement;
        _dataSource = dataSource;
    }
    return self;
}

- (EFCellModel *)infoAtIndex:(NSInteger)index {
    return self.dataSource[index];
}

@end
