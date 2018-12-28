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
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    CAShapeLayer *placeHolderShape = [[CAShapeLayer alloc] init];
    
    CGPoint center = self.view.center;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    [path   addArcWithCenter:center radius:100.0 startAngle:-M_PI_2 endAngle:M_PI_2 *4 clockwise:true];
    placeHolderShape.path = path.CGPath;
    placeHolderShape.strokeColor = [UIColor grayColor].CGColor;
    placeHolderShape.lineWidth = 10;
    placeHolderShape.lineCap = kCALineCapRound;
    placeHolderShape.fillColor = [UIColor clearColor].CGColor;
    [self.view.layer addSublayer:placeHolderShape];

    
    shape = [[CAShapeLayer alloc] init];
    shape.path = path.CGPath;
    shape.strokeColor = [UIColor greenColor].CGColor;
    shape.lineWidth = 10;
    shape.strokeEnd = 0.0;
  //  shape.transform = CATransform3DMakeRotation(-M_PI_2, 0, 0, 1);
    shape.lineCap = kCALineCapRound;
    shape.fillColor = [UIColor clearColor].CGColor;
    [self.view.layer addSublayer:shape];
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCircle)]];
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
    
    dispatch_async(dispatch_get_main_queue(), ^{
        self->shape.strokeEnd = (CGFloat)totalBytesWritten / (CGFloat)totalBytesExpectedToWrite;
    });

}

- (void)URLSession:(nonnull NSURLSession *)session downloadTask:(nonnull NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(nonnull NSURL *)location {
    
}

@end


