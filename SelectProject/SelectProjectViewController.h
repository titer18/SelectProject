//
//  SelectProjectViewController.h
//  mb
//
//  Created by hz on 2018/8/8.
//  Copyright © 2018年 Meibei. All rights reserved.
//

#import <QMUIKit/QMUIKit.h>

typedef void(^SelectProjectBlock)(NSString *projectName,NSString *projectID);
@interface SelectProjectViewController : QMUICommonViewController
- (void)selectProjectAction:(SelectProjectBlock )projectBlock;
@end
