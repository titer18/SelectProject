//
//  ProjectListModel.h
//  mb
//
//  Created by 梁小磊 on 2018/8/17.
//  Copyright © 2018年 Meibei. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol ProjectListModel
@end

@interface ProjectListModel : JSONModel
@property (strong, nonatomic) NSString *id;
@property (assign, nonatomic) NSInteger intId;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSURL *image;
@property (strong, nonatomic) NSString *spellName;
@property (strong, nonatomic) NSString *shortDescription;
@property (strong, nonatomic) NSArray <ProjectListModel>*childs;
@end
