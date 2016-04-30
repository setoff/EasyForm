//
//  EFArrayDataSource.h
//  Pods
//
//  Created by Ilya Sedov on 30/04/16.
//
//

#import <Foundation/Foundation.h>
#import "EFDataSource.h"

@interface EFArrayDataSource : NSObject <EFDataSource>

+ (EFArrayDataSource *)dataSourceWithArray:(NSArray<EFCellModel *> *)array;


@end
