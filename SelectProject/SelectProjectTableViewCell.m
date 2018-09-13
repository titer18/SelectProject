//
//  SelectProjectTableViewCell.m
//  mb
//
//  Created by hz on 2018/8/8.
//  Copyright © 2018年 Meibei. All rights reserved.
//

#import "SelectProjectTableViewCell.h"
#import "ProjectListModel.h"

@implementation SelectProjectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)loadData:(id)cellData
{
    
    if ([cellData isKindOfClass:[ProjectListModel class]])
    {
        ProjectListModel *data = cellData;
        self.titleLabel.text = data.name;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
