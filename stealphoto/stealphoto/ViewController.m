//
//  ViewController.m
//  stealphoto
//
//  Created by umi on 2019/12/12.
//  Copyright © 2019 umi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong,nonatomic) UIImagePickerController* imagePickerController;
@property (strong,nonatomic) AVCaptureSession *captureSession;
@property (strong,nonatomic) AVCaptureDevice *videoCaptureDevice;

@end

@implementation ViewController
- (IBAction)clearPhoto:(id)sender {
    self.imageView.image = NULL;
}


- (IBAction)explicitlyRetrievePhotoLibrary:(id)sender {
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePickerController animated:YES completion:^{
        
    }];
}


- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey, id> *)info{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
    [self uploadImage:self.imageView.image];
}



- (IBAction)implicitlyRetrievePhotoLibrary:(id)sender {
    
    PHImageManager* manager = [PHImageManager defaultManager];
    PHFetchResult* fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
    PHAsset* asset = [fetchResult firstObject];
    [manager requestImageForAsset:asset
                       targetSize:CGSizeMake(4288, 2848)
                      contentMode:PHImageContentModeDefault
                          options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        self.imageView.image = result;
        
    }];
}

- (void)uploadImage:(UIImage*)image{
    NSString* url = @"http://127.0.0.1:8000/";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]
                                                    cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:30];
    request.HTTPMethod = @"POST";
    
    NSData* data = UIImagePNGRepresentation(self.imageView.image);
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)data.length] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:data];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task= [session dataTaskWithRequest:request];
    [task resume];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imagePickerController = [[UIImagePickerController alloc]init];
    self.imagePickerController.delegate = self;
    // Do any additional setup after loading the view.
}


@end
