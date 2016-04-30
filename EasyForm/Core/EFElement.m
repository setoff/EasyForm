//
//  EFElement.m
//  easyForm
//
//  Created by Ilya Sedov on 14/01/16.
//  Copyright © 2016 EasyForm. All rights reserved.
//

#import "EFElement.h"

@implementation EFElement

- (instancetype)initWithTag:(NSString *)tag cellClass:(Class)cellClass nibName:(NSString *)nibName
{
    self = [super init];
    if (self) {
        [self ef__elementConstruct:tag cellClass:cellClass nibName:nibName];
    }
    return self;
}

- (void)ef__elementConstruct:(NSString *)tag cellClass:(Class)cellClass nibName:(NSString *)nibName {
    _tag = tag;
    _cellClass = cellClass;
    _nibName = nibName;
    _cellStyle = UITableViewCellStyleDefault;
    _cellHeight = 44.0;
}

- (instancetype)initWithTag:(NSString *)tag {
    return [self initWithTag:tag cellClass:[UITableViewCell class] nibName:nil];
}

- (instancetype)initWithTag:(NSString *)tag nibName:(NSString *)nibName {
    return [self initWithTag:tag cellClass:nil nibName:nibName];
}

- (instancetype)initWithTag:(NSString *)tag cellClass:(Class)cellClass {
    return [self initWithTag:tag cellClass:cellClass nibName:nil];
}

- (BOOL)isEqual:(id)object {
    if (![object isKindOfClass:[EFElement class]]) {
        return NO;
    }

    return [self.tag isEqualToString:((EFElement *)object).tag];
}

#pragma mark - Dynamic element

- (instancetype)initDynamicWithTag:(NSString *)tag
                         cellClass:(Class)cellClass
                           nibName:(NSString *)nibName
{
    self = [super init];
    if (self) {
        _isDynamic = YES;
        [self ef__elementConstruct:tag cellClass:cellClass nibName:nibName];
    }
    return self;
}

- (instancetype)initDynamicWithTag:(NSString *)tag {
    return [self initDynamicWithTag:tag cellClass:[UITableViewCell class] nibName:nil];
}

- (instancetype)initDynamicWithTag:(NSString *)tag nibName:(NSString *)nibName {
    return [self initDynamicWithTag:tag cellClass:nil nibName:nibName];
}

- (instancetype)initDynamicWithTag:(NSString *)tag cellClass:(Class)cellClass {
    return [self initDynamicWithTag:tag cellClass:cellClass nibName:nil];
}

@end
