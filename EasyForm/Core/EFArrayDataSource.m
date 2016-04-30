//
//  EFArrayDataSource.m
//  Pods
//
//  Created by Ilya Sedov on 30/04/16.
//
//

#import "EFArrayDataSource.h"

@interface EFArrayDataSource ()

@property (nonatomic, strong) NSMutableArray *objects;

@end


@implementation EFArrayDataSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.objects = [NSMutableArray new];
    }
    return self;
}

+ (EFArrayDataSource *)dataSourceWithArray:(NSArray<EFCellModel *> *)array {
    EFArrayDataSource *dataSource = [EFArrayDataSource new];
    dataSource.objects = [array mutableCopy];
    return dataSource;
}

- (NSInteger)count {
    return self.objects.count;
}

- (EFCellModel *)objectAtIndex:(NSInteger)index {
    return self.objects[index];
}

- (void)add:(EFCellModel *)object {
    [self.objects addObject:object];
}

- (void)removeAtIndex:(NSInteger)index {
    [self.objects removeObjectAtIndex:index];
}

- (void)updateAtIndex:(NSInteger)index model:(EFCellModel *)model {
    [self.objects setObject:model atIndexedSubscript:index];
}

- (id)objectAtIndexedSubscript:(NSUInteger)idx {
    return [self objectAtIndex:idx];
}

- (NSArray *)allObjects {
    return [self.objects copy];
}

@end
