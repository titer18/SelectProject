//
//  ProjectListModel.m
//  mb
//
//  Created by 梁小磊 on 2018/8/17.
//  Copyright © 2018年 Meibei. All rights reserved.
//

#import "ProjectListModel.h"

@implementation ProjectListModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

+ (JSONKeyMapper *)keyMapper
{
    return [JSONKeyMapper mapperForTitleCase];
}
@end
