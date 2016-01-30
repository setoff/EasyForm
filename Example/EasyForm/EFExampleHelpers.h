//
//  EFExampleStyle.h
//  EasyForm
//
//  Created by Ilya Sedov on 31/01/16.
//  Copyright © 2016 Ilya Sedov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EFExampleHelpers : NSObject

+ (UIColor *)redColor;
+ (UIColor *)greenColor;
+ (UIColor *)blueColor;
+ (UIColor *)lightGrayColor;

@end


@interface UIViewController (Alert)

- (void)alertAction:(NSString *)message;

@end
