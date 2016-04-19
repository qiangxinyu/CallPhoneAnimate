//
//  MyMoveImageView.m
//  LvCheng
//
//  Created by 中科创奇 on 15/5/4.
//  Copyright (c) 2015年 中科创奇. All rights reserved.
//

#import "MyMoveImageView.h"


@interface MyMoveImageView ()
@property (nonatomic,assign)BOOL  isMove;
@end


@implementation MyMoveImageView

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    
    CGPoint  point =  [touch locationInView:self.superview];
    CGFloat x = point.x;
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGFloat superWidth = self.superview.frame.size.width;
    
    if (superWidth == kScreenWidth) {
        if (!self.isMove) {
            [super touchesEnded:touches withEvent:event];
        }
        
        self.isMove = NO;
        return;
    }
    
    CGPoint center = CGPointMake(superWidth - width/2, height/2);
    if (x <= superWidth/3*2) {
        center = CGPointMake(width/2, height/2);
    }
    
    [UIView animateWithDuration:.3 animations:^{
        self.center = center;
    } completion:^(BOOL finished) {
        if (x > superWidth/3*2) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kCallPhone object:self userInfo:nil];

        }

    }];
    
    
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.isMove = YES;
    
    UITouch * touch = [touches anyObject];
    
    CGPoint  point =  [touch locationInView:self.superview];
    
    
    CGFloat x = point.x;
    CGFloat y = point.y;
    
    
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    
    CGFloat superWidth = self.superview.frame.size.width;
    CGFloat superHeight = self.superview.frame.size.height;
    
    
    if (y <= height/2) {
        point = CGPointMake(x, height/2);
    }
    if (y >= superHeight - height/2)
    {
        point = CGPointMake(x, superHeight - height/2);
    }
    if (x <= width/2)
    {
        point = CGPointMake(width/2, y);
    }
    if (x >= superWidth - width/2)
    {
        point = CGPointMake(superWidth - width/2, y);
    }
    
    if (y <= height/2 && x <= width/2) {
        point = CGPointMake(width/2, height/2);
    }
    if (y <= height/2 && x >= superWidth - width/2) {
        point = CGPointMake(superWidth - width/2,height/2);
    }
    if (x <= width/2 && y >= superHeight - height/2) {
        point = CGPointMake( width/2,superHeight - height/2);
    }
    if (y >= superHeight - height/2 && x >= superWidth - width/2) {
        point = CGPointMake(superWidth - width/2, superHeight - height/2);
    }
    
    self.center = point;

}


@end
