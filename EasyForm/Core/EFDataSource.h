//
//  EFDataSource.h
//  Pods
//
//  Created by Ilya Sedov on 30/04/16.
//
//

#import <Foundation/Foundation.h>

@class EFCellModel;

@protocol EFDataSource <NSObject>

@required

- (NSInteger)count;

- (EFCellModel *)objectAtIndex:(NSInteger)index;

- (void)add:(EFCellModel *)object;

- (void)removeAtIndex:(NSInteger)index;

- (void)updateAtIndex:(NSInteger)index model:(EFCellModel *)model;

- (id)objectAtIndexedSubscript:(NSUInteger)idx;

- (NSArray *)allObjects;

@end
