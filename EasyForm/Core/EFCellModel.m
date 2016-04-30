//
//  EFCellModel.m
//  Pods
//
//  Created by Ilya Sedov on 30/04/16.
//
//

#import "EFCellModel.h"

@implementation EFCellModel

+ (EFCellModel *)modelWithTitle:(NSString *)title value:(NSString *)value {
    EFCellModel *model = [EFCellModel new];
    model.title = title;
    model.value = value;

    return model;
}

@end
