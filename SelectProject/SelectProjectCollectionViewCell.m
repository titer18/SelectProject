//
//  SelectProjectCollectionViewCell.m
//  mb
//
//  Created by hz on 2018/8/8.
//  Copyright © 2018年 Meibei. All rights reserved.
//

#import "SelectProjectCollectionViewCell.h"
#import "ProjectListModel.h"
#import <QMUIKit/QMUIKit.h>

@implementation SelectProjectCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleButton.layer.borderWidth = 0.5;
    self.titleButton.layer.borderColor = UIColorMake(213, 213, 213).CGColor;
}

- (void)loadData:(id)data
{
    ProjectListModel *model = data;
    [self.titleButton setTitle:model.name forState:UIControlStateNormal];
}
-(void)setSelected:(BOOL)selected
{
    if (selected)
    {
        [self.titleButton setTitleColor:UIColorMake(255, 255, 255) forState:UIControlStateNormal];
        [self.titleButton setBackgroundColor:UIColorMake(255, 122, 123)];
        self.titleButton.layer.borderColor = UIColorMake(255, 122, 123).CGColor;
    }
    else
    {
        [self.titleButton setTitleColor:UIColorMake(102, 102, 102) forState:UIControlStateNormal];
        [self.titleButton setBackgroundColor:[UIColor whiteColor]];
        self.titleButton.layer.borderColor = UIColorMake(213, 213, 213).CGColor;
    }
}
@end
