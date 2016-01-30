//
//  EFSection.m
//  easyForm
//
//  Created by Ilya Sedov on 14/01/16.
//  Copyright © 2016 EasyForm. All rights reserved.
//

#import "EFSection.h"
#import "EFElement.h"

@implementation EFSection

- (instancetype)initWithTag:(NSString *)tag elements:(NSArray *)elements
{
    self = [super init];
    if (self) {
        _tag = tag;
        _elements = elements;
    }
    return self;
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return self.elements[idx];
}

@end
