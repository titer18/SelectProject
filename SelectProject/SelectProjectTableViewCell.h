//
//  SelectProjectTableViewCell.h
//  mb
//
//  Created by hz on 2018/8/8.
//  Copyright © 2018年 Meibei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectProjectTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *styleView;
- (void)loadData:(id)data;
@end
