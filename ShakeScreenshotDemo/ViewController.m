//
//  ViewController.m
//  ShakeScreenshotDemo
//
//  Created by MacBook on 2018/12/1.
//  Copyright © 2018 MacBook. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic,strong)UIView * tmpView;

@property(nonatomic,strong)UIImageView * tmpImageView;

@property(nonatomic,strong)NSString * isShake;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // UIResponder
    
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    
    [self becomeFirstResponder];
    
    self.isShake = @"0";
    
    UIImageView * imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds .size.width, [UIScreen mainScreen].bounds .size.height)];
    
    [imageview setImage:[UIImage imageNamed:@"001.jpg"]];
    
    [self.view addSubview:imageview];
   
    self.tmpView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen]bounds].size.width, [[UIScreen mainScreen]bounds].size.height)];
    
    [self.tmpView setBackgroundColor:[UIColor colorWithRed:2.0/255.0 green:2.0/255.0 blue:2.0/255.0 alpha:0.2]];
    
    [self.tmpView setHidden:YES];
    
    [self.view addSubview:self.tmpView];
    
    
   self.tmpImageView = [[UIImageView alloc]initWithFrame:CGRectMake(40, 100, [[UIScreen mainScreen]bounds].size.width - 80, [[UIScreen mainScreen]bounds].size.height - 200)];
    
   [self.tmpView addSubview:self.tmpImageView];
    
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setFrame:CGRectMake(CGRectGetMinX(self.tmpImageView.frame), CGRectGetMaxY(self.tmpImageView.frame)+15, CGRectGetWidth(self.tmpImageView.frame)/2 - 10, 40)];
    
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [btn setBackgroundColor:[UIColor orangeColor]];
    
    [btn addTarget:self action:@selector(setSaveImageAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tmpView addSubview:btn];
    
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [cancelBtn setFrame:CGRectMake(CGRectGetMaxX(btn.frame)+10, CGRectGetMaxY(self.tmpImageView.frame)+15, CGRectGetWidth(self.tmpImageView.frame)/2 - 10, 40)];
    
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [cancelBtn setBackgroundColor:[UIColor orangeColor]];
    
    [cancelBtn addTarget:self action:@selector(setCancelImageAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tmpView addSubview:cancelBtn];
    
    
}

// 开始摇一摇
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"开始摇一摇");
    
    
}

//取消摇一摇
- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    NSLog(@"取消摇一摇");
}

//结束摇一摇
-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if(event.subtype == UIEventSubtypeMotionShake)
    {
         NSLog(@"摇动结束");

        if([self.isShake isEqualToString:@"0"])
        {
             [self setCutScreen];
        }
        
        
    }
}

-(void)setSaveImageAction:(UIButton *)sender
{
    if(sender && [sender isKindOfClass:[UIButton class]])
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"是否将图片保存到相册？" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
        
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
            //将图片保存到本地
            UIImageWriteToSavedPhotosAlbum(self.tmpImageView.image, self , @selector(image:didFinishSavingWithError:contextInfo:), nil);
            
            [self.tmpView setHidden:YES];
            
            self.isShake = @"0";
        }];
        
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
           
            [self.tmpView setHidden:YES];
            
            self.isShake = @"0";
        }];
        
        [alert addAction:cancelAction];
        
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
        
    
        
    }
}

-(void)setCancelImageAction:(UIButton *)sender
{
    if(sender && [sender isKindOfClass:[UIButton class]])
    {
        [self.tmpView setHidden:YES];
        
        self.isShake = @"0";
    }
}
-(void)setCutScreen
{
    self.isShake = @"1";
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    {
        UIGraphicsBeginImageContextWithOptions(self.view.window.bounds.size, NO, [UIScreen mainScreen].scale);
    }
    else
    {
        UIGraphicsBeginImageContext(self.view.window.bounds.size);
    }
    
    [self.view.window.layer renderInContext:UIGraphicsGetCurrentContext()];
   
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    [self.tmpView setHidden:NO];
    
    [self.tmpImageView setImage:image];
    
    
   
   
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"图片保存成功！" message:nil preferredStyle:(UIAlertControllerStyleAlert)];
    
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}
@end
