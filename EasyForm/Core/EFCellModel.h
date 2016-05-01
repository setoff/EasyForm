//
//  EFCellModel.h
//  Pods
//
//  Created by Ilya Sedov on 30/04/16.
//
//

#import <Foundation/Foundation.h>

@interface EFCellModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;

+ (EFCellModel *)modelWithTitle:(NSString *)title value:(NSString *)value;

@end
