//
//  EFSection.h
//  easyForm
//
//  Created by Ilya Sedov on 14/01/16.
//  Copyright © 2016 EasyForm. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXTERN NSString *const EFSectionHiddenStateChangedNotification;

@interface EFSection : NSObject

/// Section tag. Should be unique for form
@property (nonatomic, readonly) NSString *tag;

/// Determines whether the section is hidden.
@property (nonatomic, assign, getter=isHidden) BOOL hidden;

/// Sections rows elements
@property (nonatomic, readonly) NSArray *elements;

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

@end
