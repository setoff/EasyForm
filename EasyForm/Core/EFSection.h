//
//  EFSection.h
//  easyForm
//
//  Created by Ilya Sedov on 14/01/16.
//  Copyright © 2016 EasyForm. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EFElement;
@class EFCellModel;
@protocol EFDataSource;

FOUNDATION_EXTERN NSString *const EFSectionHiddenStateChangedNotification;


@interface EFSection : NSObject

/// Section tag. Should be unique for form
@property (nonatomic, readonly) NSString *tag;

/// Determines whether the section is hidden.
@property (nonatomic, assign, getter=isHidden) BOOL hidden;

/// Sections rows elements. You mustn't relate on `count` of this array to estimate rows number. Use `rowsCount` intead.
@property (nonatomic, readonly) NSArray<EFElement *> *elements;

// Number of rows in section
@property (nonatomic, readonly) NSInteger rowsCount;

/// Section static title. If you need dynamic title use `setupTitle` block.
@property (nonatomic, copy) NSString *title;

/**
 Sets up the section title. If this block returns `nil` title property will used.
 */
@property (nonatomic, copy) NSString *(^setupTitle)();

/**
 Initialize section with given tag and elements.
 */
- (instancetype)initWithTag:(NSString *)tag elements:(NSArray *)elements;

/**
 Accesses section's row elements by [n]
 */
- (id)objectAtIndexedSubscript:(NSUInteger)idx;

#pragma mark - Dynamic section

/**
 Creates a dynamic section.
 @param tag Section tag.
 @param element Dynamic element which used to config and display cells.
 @param dataSource 
 */
- (instancetype)initWithTag:(NSString *)tag
                    element:(EFElement *)dynamicElement
                 dataSource:(NSObject<EFDataSource> *)dataSource;

- (EFCellModel *)infoAtIndex:(NSInteger)index;

@end
