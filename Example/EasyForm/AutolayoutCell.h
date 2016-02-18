//
//  AutolayoutCell.h
//  EasyForm
//
//  Created by Ilya Sedov on 18/02/16.
//  Copyright © 2016 Ilya Sedov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AutolayoutCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *value;
@property (weak, nonatomic) IBOutlet UILabel *comment;
@property (weak, nonatomic) IBOutlet UILabel *itemsList;

@end
