//
//  EFCellsDemoForm.h
//  EasyForm
//
//  Created by Ilya Sedov on 31/01/16.
//  Copyright © 2016 Ilya Sedov. All rights reserved.
//

#import <EasyForm/EFForm.h>

@interface EFCellsDemoForm : EFForm

@property (nonatomic, weak) UITableViewController *presentingController;

@property (nonatomic, copy) void (^backToPrevious)();

- (void)buildForm;

@end
