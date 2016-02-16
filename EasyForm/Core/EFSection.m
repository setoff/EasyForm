//
//  EFSection.m
//  easyForm
//
//  Created by Ilya Sedov on 14/01/16.
//  Copyright © 2016 EasyForm. All rights reserved.
//

#import "EFSection.h"
#import "EFElement.h"

@interface EFSection ()

@property (nonatomic, strong) NSArray *allElements;

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

- (NSArray *)elements {
    NSMutableArray *visibleElements = [NSMutableArray new];
    for (EFElement *item in self.allElements) {
        if (item.isVisible && !item.isVisible()) {
            continue;
        }
        [visibleElements addObject:item];
    }
    return [visibleElements copy];
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return self.elements[idx];
}

@end
