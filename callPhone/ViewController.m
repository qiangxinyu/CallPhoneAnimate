//
//  ViewController.m
//  callPhone
//
//  Created by apple on 15/7/24.
//  Copyright (c) 2015年 apple. All rights reserved.
//

#import "ViewController.h"
#import "MyMoveImageView.h"
#import "FXBlurView.h"
#import "UIView+YYAdd.h"

@interface ViewController ()
@property (nonatomic,strong)MyMoveImageView * moveImageView;
@property (nonatomic,strong)UIImageView * imageView;
@property (nonatomic,strong)FXBlurView * blurView;
@property (nonatomic,strong)UIView * slideView;

@property (nonatomic,strong)NSTimer * timer;

@property (nonatomic,assign)CGPoint  moveImageViewCenter;
@property (nonatomic,assign)CGPoint oldCenter;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.blurView];
    [self.view addSubview:self.slideView];
    [self.view addSubview:self.moveImageView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callPhone) name:kCallPhone object:nil];
}


- (void)callPhone
{
    [self removeBlurViewWithCall:nil];
}
- (void)clickMoveImageView
{
    self.blurView.hidden = NO;
        [UIView animateWithDuration:.5 animations:^{
            self.slideView.width = kScreenWidth/3*2;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:.5 animations:^{
                self.oldCenter = self.moveImageView.center;
                self.moveImageView.center = CGPointMake(kScreenWidth/2 - self.slideView.frame.size.width/2 + 25, kScreenHeight/4 * 3);
                self.moveImageViewCenter = self.moveImageView.center;
            } completion:^(BOOL finished) {
                
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(moveWhiteView) userInfo:nil repeats:YES];
                [self moveWhiteView];
                
                [self.moveImageView removeFromSuperview];
                self.moveImageView.center = CGPointMake(25, 25);
                [self.slideView addSubview:self.moveImageView];
            }];
        }];
}

- (void)removeBlurViewWithCall:(id)isCall
{
    [self.moveImageView removeFromSuperview];
    self.moveImageView.center = self.moveImageViewCenter;
    [self.view addSubview:self.moveImageView];
    
    [UIView animateWithDuration:.5 animations:^{
        self.moveImageView.center = self.oldCenter;
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:.3 animations:^{
           self.slideView.width = 0;
        } completion:^(BOOL finished) {
            self.blurView.hidden = YES;
            [self.timer invalidate];
            self.timer = nil;
            
            if (!isCall) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",@"18735359200"]]];

            }
        }];
       
    }];
}

- (void)moveWhiteView
{
    UIView * view = [self.view viewWithTag:1000];
    CGPoint center = view.center;
    [UIView animateWithDuration:1 animations:^{
        view.center = CGPointMake(view.superview.frame.size.width, view.center.y);
    } completion:^(BOOL finished) {
        view.center = center;
    }];
    
}
- (MyMoveImageView *)moveImageView
{
    if (!_moveImageView) {
        _moveImageView = [[MyMoveImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _moveImageView.image = [UIImage imageNamed:@"phone_press"];
        _moveImageView.userInteractionEnabled = YES;
        [_moveImageView addTarget:self action:@selector(clickMoveImageView)];
    }
    return _moveImageView;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
        _imageView.image = [UIImage imageNamed:@"4.jpg"];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (FXBlurView *)blurView
{
    if (!_blurView) {
        _blurView = [[FXBlurView alloc]initWithFrame:self.view.bounds];
        _blurView.tintColor = [UIColor whiteColor];
        _blurView.userInteractionEnabled = YES;
        _blurView.hidden = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeBlurViewWithCall:)];
        [_blurView addGestureRecognizer:tap];
    }
    return _blurView;
}

- (UIView *)slideView
{
    if (!_slideView) {
        _slideView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/3*2, 50)];
        _slideView.center = CGPointMake(kScreenWidth/2, kScreenHeight/4*3);
        _slideView.backgroundColor = [UIColor whiteColor];
        _slideView.layer.cornerRadius = 25;
        _slideView.layer.borderWidth = 1;
        _slideView.layer.borderColor = [UIColor colorWithRed:28/255.0 green:156/255.0 blue:178/255.0 alpha:1].CGColor;
        _slideView.layer.masksToBounds = YES;
        _slideView.width = 0;
        
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 120, 50)];
        label.center = CGPointMake((kScreenWidth/3*2+50)/2, 25);
        label.font = [UIFont systemFontOfSize:19];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"右滑联系客服";
        [_slideView addSubview:label];

        FXBlurView * view = [[FXBlurView alloc]initWithFrame:CGRectMake(0, 0, 25, 50)];
        view.tintColor = [UIColor whiteColor];
        view.alpha = .8;
        view.tag = 1000;
        [_slideView addSubview:view];
    
    }
    return _slideView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
