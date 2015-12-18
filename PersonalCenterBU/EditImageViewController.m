//
//  EditImageViewController.m
//  PersonalCenterBU
//
//  Created by Somiya on 15/10/20.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "EditImageViewController.h"
#import "ClipMaskView.h"

@interface EditImageViewController () <ClipMaskViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *editImageView;
@property (nonatomic, strong) UIImage *editedImage;

@property (weak, nonatomic) IBOutlet ClipMaskView *clipMaskView;
@property (nonatomic, assign) CGPoint statPoint;
@property (nonatomic, assign) CGPoint endPoint;

@end

@implementation EditImageViewController

#pragma mark ----------------system----------------
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ----------------init----------------
- (void)initBaseData {
}

- (void)initBaseView {
    self.clipMaskView.delegate = self;
    self.editImageView.image = self.sourceImage;
    self.clipMaskView.clipsToBounds = YES;
    [super initBaseView];
}

#pragma mark ----------------Action Methouds----------------
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.clipMaskView startClip];
    UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
    self.statPoint = [mytouch locationInView:self.clipMaskView];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *mytouch=[[touches allObjects] objectAtIndex:0];
    _endPoint = [mytouch locationInView:self.clipMaskView];
    [self.clipMaskView setClippingRec:[self rectWithStartPoint:self.statPoint endPoint:self.endPoint]];
    [self.clipMaskView setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.clipMaskView endClip];
}

#pragma mark ----------------ClipMaskViewDelegate----------------
/**
 *  取消编辑
 */
- (void)cancelEdit {
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  边界结束
 */
- (void)editDone {
    
    self.editedImage = [self crop:self.editImageView.image rect:[self rectWithStartPoint:[self convertPoint:self.statPoint] endPoint:[self convertPoint:self.endPoint]]];
    if (self.imageEditBlock != nil) {
        self.imageEditBlock(self.editedImage);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark ----------------功能函数----------------
/**
 *  从clipMaskView中的一个点转换到editImageView
 *
 *  @param point
 *
 *  @return <#return value description#>
 */
- (CGPoint)convertPoint:(CGPoint)point {
    return [self.editImageView convertPoint:point fromView:self.clipMaskView];
}
/**
 *  矩形原点转换
 *
 *  @param startP
 *  @param endP   <#endP description#>
 *
 *  @return <#return value description#>
 */
- (CGRect)rectWithStartPoint:(CGPoint)startP endPoint:(CGPoint)endP {
    if (endP.x > startP.x && endP.y > startP.y) {
        return CGRectMake(startP.x, startP.y, endP.x - startP.x, endP.y - startP.y);
    }
    if (endP.x > startP.x && endP.y < startP.y) {
        return CGRectMake(startP.x, endP.y, endP.x - startP.x, startP.y - endP.y);
    }
    if (endP.x < startP.x && endP.y < startP.y) {
        return CGRectMake(endP.x, endP.y, startP.x - endP.x, startP.y - endP.y);
    }
    return CGRectMake(endP.x, startP.y, startP.x - endP.x, endP.y - startP.y);
}

/**
 *  剪切图片
 *
 *  @param image image
 *  @param rect  剪切大小
 *
 *  @return new image
 */
#warning 在使用相机拍摄的不同方向的照片需要特殊处理----待优化
- (UIImage *)crop:(UIImage *)image rect:(CGRect)rect {
    CGRect convertedRect = [self convertRect:rect fromRect:self.editImageView.frame toRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], convertedRect);
    UIImage * croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}
/**
 *  把imageView上的坐标系转换为image上像素的坐标系
 *
 *  @param rect  要转换的rect
 *  @param fRect 从一个坐标系的rect
 *  @param tRect 转到另一个坐标系的rect
 *
 *  @return rect
 */
- (CGRect)convertRect:(CGRect)rect fromRect:(CGRect)fRect toRect:(CGRect)tRect {
    CGFloat imageW;
    CGFloat imageH;
    CGPoint startP;
    CGPoint fCenter = CGPointMake(fRect.size.width / 2, fRect.size.height / 2);
    CGPoint tCenter = CGPointMake(tRect.size.width / 2, tRect.size.height / 2);
    CGFloat compressionRate;

    
    CGFloat a = tRect.size.width / fRect.size.width;
    CGFloat b = tRect.size.height / fRect.size.height;
    if (a > 1 || b > 1) {
        compressionRate = MAX(a, b);
    } else {
        compressionRate = MIN(a, b);
    }
    startP.x = tCenter.x - (fCenter.x - rect.origin.x) * compressionRate;
    startP.y = tCenter.y - (fCenter.y - rect.origin.y) * compressionRate;
    
    imageW = rect.size.width * compressionRate;
    imageH = rect.size.height * compressionRate;
    return CGRectMake(startP.x, startP.y, imageW, imageH);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
