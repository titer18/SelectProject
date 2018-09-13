//
//  LeftEqualFlowLayout.m
//  meb5
//
//  Created by liang on 2017/7/20.
//  Copyright © 2017年 hz. All rights reserved.
//

#import "LeftEqualFlowLayout.h"

@implementation LeftEqualFlowLayout


- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
    // 获取系统帮我们计算好的Attributes
    NSArray *answer = [super layoutAttributesForElementsInRect:rect];
    
    // 遍历结果
    for(int i = 0; i < [answer count]; ++i) {
        
        UICollectionViewLayoutAttributes *currentLayoutAttributes = answer[i]; // 当前cell的位置信息
        UICollectionViewLayoutAttributes *prevLayoutAttributes = i == 0 ? nil : answer[i-1]; // 上一个cell 的位置信
        UICollectionViewLayoutAttributes *nextLayoutAttributs = i + 1 == answer.count ?
        nil : answer[i+1];//下一个cell 位置信息
        
        NSInteger previousX = CGRectGetMaxX(prevLayoutAttributes.frame);
        
        CGFloat previousY = prevLayoutAttributes == nil ? 0 : CGRectGetMaxY(prevLayoutAttributes.frame);
        CGFloat currentY = CGRectGetMaxY(currentLayoutAttributes.frame);
        CGFloat nextY = nextLayoutAttributs == nil ? 0 : CGRectGetMaxY(nextLayoutAttributs.frame);
        
        
        //如果当前cell是单独一行
        if (currentY != previousY && currentY != nextY)
        {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = self.sectionInset.left;
            currentLayoutAttributes.frame = frame;
        }
        //如果下一个不cell在本行，则开始调整Frame位置
        else if( currentY != nextY)
        {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = previousX + self.minimumInteritemSpacing;
            currentLayoutAttributes.frame = frame;
        }
        //如果当前cell在本行，调整Frame位置
         else if (previousY == currentY)
        {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = previousX + self.minimumInteritemSpacing;
            currentLayoutAttributes.frame = frame;
        }
 }

    return answer;
}
@end
