//
//  EFElement.h
//  easyForm
//
//  Created by Ilya Sedov on 14/01/16.
//  Copyright © 2016 EasyForm. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Form element. Each element should have representing cell. You can specify your custom cell or use `UITableViewCell`.
 All element's behaviour and appearance can be configured with two blocks: `setupCell` and `onTap`.
 In case of using plain `UITableViewCells` you can also specify cell and selection style.
 */
@interface EFElement : NSObject

/// Element's identification tag.
@property (nonatomic, readonly) NSString *tag;

/// Element's representing cell nib file or `nil` if different cell initialization used.
@property (nonatomic, readonly) NSString *nibName;

/// Element's representing cell class. See initializers for details.
@property (nonatomic, readonly) Class cellClass;

/// UITableViewCellStyleDefault by default.
@property (nonatomic, assign) UITableViewCellStyle cellStyle;

/// Cell selection style. UITableViewCellSelectionStyleDefault by default.
@property (nonatomic, assign) UITableViewCellSelectionStyle cellSelectionStyle;

/// Statndart cell height for this element if it differs from 44. By default 44.
@property (nonatomic, assign) CGFloat cellHeight;

/// Called just before displaying Element's cell (tableView:willDisplayCell:...)
@property (nonatomic, copy) void (^setupCell)(UITableViewCell *cell);

/// Called when user taps on cell (tableView:didSelectRow:atIndexPath:)
@property (nonatomic, copy) void (^onTap)(UITableViewCell *cell, EFElement *element);

/**
 Initializes form element.
 @param tag Element tag. This tag is also used as reuse identifier for representing cell.
 @param cellClass Cell class. Your custom cell should subclass `UITableViewCell` and override `initWithStyle:
 reuseIdentifier:` initializer if you need some custom initializations.
 @param nibName IB nib for your custom element's representing cell.
 */
- (instancetype)initWithTag:(NSString *)tag cellClass:(Class)cellClass nibName:(NSString *)nibName;

//TODO: make several initializers: only with tag, tag and class, tag and nibName (extract class name from nib metadata).

/**
 Creates element with `UITableViewCell` representing cell. You can tune it within `setupCell` block.
 @param tag Element's tag and cell's `reuseIdentifier`.
 */
- (instancetype)initWithTag:(NSString *)tag;

/**
 Creates element with representing cell from a given nib file.
 @discussion When form rendered class name for given cell will extracted from nibFile metadata.
 @param tag Element's tag and cell's `reuseIdentifier`.
 @param nibName IB nib for your custom element's representing cell.
 */
- (instancetype)initWithTag:(NSString *)tag nibName:(NSString *)nibName;

/**
 Creates element with representing cell with a given class name.
 @param tag Element's tag and cell's `reuseIdentifier`.
 @param cellClass Representing cell class.
 */
- (instancetype)initWithTag:(NSString *)tag cellClass:(Class)cellClass;

@end
