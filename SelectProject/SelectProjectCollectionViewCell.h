//
//  SelectProjectCollectionViewCell.h
//  mb
//
//  Created by hz on 2018/8/8.
//  Copyright © 2018年 Meibei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectProjectCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *titleButton;
- (void)loadData:(id)data;
@end
