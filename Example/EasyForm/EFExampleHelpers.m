//
//  EFExampleStyle.m
//  EasyForm
//
//  Created by Ilya Sedov on 31/01/16.
//  Copyright © 2016 Ilya Sedov. All rights reserved.
//

#import "EFExampleHelpers.h"


@implementation EFExampleHelpers

+ (UIColor *)redColor {
    return [UIColor colorWithRed:211/255.0 green:80/255.0 blue:78/255.0 alpha:1.0];
}

+ (UIColor *)greenColor {
    return [UIColor colorWithRed:158/255.0 green:199/255.0 blue:117/255.0 alpha:1.0];
}

+ (UIColor *)blueColor {
    return [UIColor colorWithRed:73/255.0 green:172/255.0 blue:198/255.0 alpha:1.0];
}

+ (UIColor *)lightGrayColor {
    return [UIColor colorWithWhite:0.98 alpha:1.0];
}

@end

@implementation UIViewController (Alert)

- (void)alertAction:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Action"
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * _Nonnull action) {
                                   [self dismissViewControllerAnimated:YES completion:nil];
                               }];
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
