//
//  ViewController.m
//  CircularTimer
//
//  Created by Macbook on 12/28/18.
//  Copyright © 2018 Abdulbaqy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<NSURLSessionDownloadDelegate>{
    CAShapeLayer *shape;
    CAShapeLayer *pulseShape,*pulseShape2;
    UILabel *lblProgress;
}

@end

@implementation ViewController

- (void)addPlacHolderLayerWithPath:(UIBezierPath *)path {
    CAShapeLayer *placeHolderShape = [[CAShapeLayer alloc] init];
    placeHolderShape.path = path.CGPath;
    placeHolderShape.strokeColor =   [UIColor colorWithRed:0.95 green:0.27 blue:0.27 alpha:1.0].CGColor;
    placeHolderShape.lineWidth = 10;
    placeHolderShape.position = self.view.center;
    placeHolderShape.lineCap = kCALineCapRound;
    placeHolderShape.fillColor = [UIColor blackColor].CGColor;
    [self.view.layer addSublayer:placeHolderShape];
}

- (void)pulseShape2:(UIBezierPath *)path {
    pulseShape2 = [[CAShapeLayer alloc] init];
    pulseShape2.path = path.CGPath;
    pulseShape2.strokeColor = [UIColor clearColor].CGColor;
    pulseShape2.lineWidth = 10;
    pulseShape2.position = self.view.center;
    pulseShape2.lineCap = kCALineCapRound;
    pulseShape2.fillColor =  [UIColor colorWithRed:0.95 green:0.27 blue:0.27 alpha:0.6].CGColor;
    [self.view.layer addSublayer:pulseShape2];
}

- (void)pulseShape:(UIBezierPath *)path {
    pulseShape = [[CAShapeLayer alloc] init];
    pulseShape.path = path.CGPath;
    pulseShape.strokeColor = [UIColor clearColor].CGColor;
    pulseShape.lineWidth = 10;
    pulseShape.position = self.view.center;
    pulseShape.lineCap = kCALineCapRound;
    pulseShape.fillColor =  [UIColor colorWithRed:0.95 green:0.27 blue:0.27 alpha:0.4].CGColor;
    [self.view.layer addSublayer:pulseShape];
}

- (UIBezierPath *)createBezierPath {
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path   addArcWithCenter:CGPointZero radius:100.0 startAngle:-M_PI_2 endAngle:M_PI_2 *4 clockwise:true];
    return path;
}

- (void)createMainShape:(UIBezierPath *)path {
    shape = [[CAShapeLayer alloc] init];
    shape.path = path.CGPath;
    shape.strokeColor = [UIColor redColor].CGColor;
    shape.lineWidth = 20;
    shape.strokeEnd = 0.0;
    shape.position = self.view.center;
    shape.lineCap = kCALineCapRound;
    shape.fillColor = [UIColor clearColor].CGColor;
    [self.view.layer addSublayer:shape];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor blackColor];
    UIBezierPath * path = [self createBezierPath];
    
    [self pulseShape:path];
    [self pulseShape2:path];
    //CGPathRef
    [self addPlacHolderLayerWithPath:path];

    [self aniamatitePulsingLayer];
    
    [self createMainShape:path];
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCircle)]];
    [self addProgressLabel];
}

-(void) addProgressLabel{
    
    lblProgress = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 90, 50)];
    lblProgress.center = self.view.center;
    [lblProgress setText:@"Start"];
    [lblProgress setFont:[UIFont systemFontOfSize:40]];
    [lblProgress setTextColor:[UIColor whiteColor]];
    [lblProgress setTextAlignment:NSTextAlignmentCenter];
    lblProgress.adjustsFontSizeToFitWidth=YES;
    lblProgress.minimumScaleFactor = 0.5;
    [self.view addSubview:lblProgress];
}

- (void)addanimation1 {
    CABasicAnimation * animate = [[CABasicAnimation alloc] init];
    animate.keyPath = @"transform.scale";
    animate.toValue = @(1.2);
    animate.duration = 0.8;
    animate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animate.autoreverses = true;
    animate.repeatCount = INFINITY;
    [pulseShape addAnimation:animate forKey:@"pulsing"];
}

- (void)addanimation2 {
    CABasicAnimation * animate2 = [[CABasicAnimation alloc] init];
    animate2.keyPath = @"transform.scale";
    animate2.toValue = @(1.15);
    animate2.duration = 0.8;
    animate2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animate2.autoreverses = true;
    animate2.repeatCount = INFINITY;
    [pulseShape2 addAnimation:animate2 forKey:@"pulsing"];
}

-(void) aniamatitePulsingLayer{
    [self addanimation1];
    [self addanimation2];
}

-(void) tapCircle{
    
//    CABasicAnimation * animate = [[CABasicAnimation alloc] init];
//    animate.keyPath = @"strokeEnd";
//    animate.toValue = @1;
//   // animate.duration = 2;
//    animate.fillMode = kCAFillModeForwards;
//    animate.removedOnCompletion = false;
//    [shape addAnimation:animate forKey:@"urSoBasic"];
    [self startDownload];
    
}

-(void) startDownload{
    //
    shape.strokeEnd = 0;
    NSString *downloadLink = @"https://firebasestorage.googleapis.com/v0/b/firestorechat-e64ac.appspot.com/o/intermediate_training_rec.mp4?alt=media&token=e20261d0-7219-49d2-b32d-367e1606500c";
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSOperationQueue *operatioQueue = [NSOperationQueue new];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:operatioQueue];
    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:downloadLink]];
    [downloadTask resume];
    
}

-(void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    NSLog(@"%f" ,(CGFloat) totalBytesWritten / (CGFloat)totalBytesExpectedToWrite);
    CGFloat progress = (CGFloat)totalBytesWritten / (CGFloat)totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{
        self->shape.strokeEnd = progress;
        [self->lblProgress setText:[NSString stringWithFormat:@"%0.1f %@",progress*100.0,@"%"]];
    });

}

- (void)URLSession:(nonnull NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->lblProgress setText:@"Complete"];
    });

}

@end
