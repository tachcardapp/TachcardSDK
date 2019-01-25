//
//  QrScanViewController.m
//  TachcardSDKExample
//
//  Created by admin on 4/26/17.
//  Copyright © 2017 CWG. All rights reserved.
//

#import "QrScanViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "ReceiptPayWithTokenViewController.h"
#import "PaydescPayWithUrlViewController.h"

#import "MasterpassRegisterViewController.h"
#import "MasterpassVcodeViewController.h"
#import "MasterpassPayViewController.h"



@interface QrScanViewController () <AVCaptureMetadataOutputObjectsDelegate, UIGestureRecognizerDelegate> {
    BOOL canScanQR;
}

@property (weak, nonatomic) IBOutlet UIView *captureView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, strong) AVCaptureDeviceInput *input;
@property (nonatomic, strong) AVCaptureMetadataOutput *output;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *prevLayer;

@end

@implementation QrScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    @weakify(self);
    if ([AVCaptureDevice respondsToSelector:@selector(requestAccessForMediaType: completionHandler:)]) {
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                @strongify(self);
                if (granted) {
                    [self capruteSessionSetup];
                } else {
                    //@"To work you need a camera"
                }
            });
        }];
    } else {
        [self capruteSessionSetup];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    canScanQR = YES;
}

- (void)capruteSessionSetup {
    self.session = [[AVCaptureSession alloc] init];
    self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    self.input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:nil];
    [self.session addInput:self.input];

    self.output = [[AVCaptureMetadataOutput alloc] init];
    self.output.rectOfInterest = CGRectMake(0, 0, 1, 1);
    [self.session addOutput:self.output];

    self.output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];

    self.prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.prevLayer.frame = self.captureView.bounds;
    self.prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.captureView.layer addSublayer:self.prevLayer];

    [self.output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [self.session startRunning];

    NSError *error = nil;
    if ([self.device lockForConfiguration:&error]) {

        if ([self.device isFocusPointOfInterestSupported] && [self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        }

        if ([self.device isExposurePointOfInterestSupported] && [self.device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
            [self.device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
        }

        [self.device unlockForConfiguration];
    }

    UITapGestureRecognizer *focusTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(focusTapGestureHandler:)];
    focusTap.delegate = self;
    [self.view addGestureRecognizer:focusTap];
}

#pragma mark -
#pragma mark AVCaptureMetadataOutputObjectsDelegate


- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {

    if (!canScanQR) {
        return;
    }

    AVMetadataMachineReadableCodeObject *qrCodeObject;
    AVMetadataMachineReadableCodeObject *metadata = [metadataObjects lastObject];
    qrCodeObject = (AVMetadataMachineReadableCodeObject *)[self.prevLayer transformedMetadataObjectForMetadataObject:metadata];

    NSString *searchedString = qrCodeObject.stringValue;

    if ([self isMpQrScan:searchedString]) {
        canScanQR = NO;
        [self parseQRCode:searchedString];
        return;
    }

    NSString *pattern = @"(http|https):\\/\\/([\\w|\\-|\\_]+\\.|)tachcard.com(.{2,})";
    NSError  *error = nil;
    NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern: pattern options:0 error:&error];

    [regex enumerateMatchesInString:searchedString options:0 range:NSMakeRange(0, [searchedString length]) usingBlock:^(NSTextCheckingResult *match, NSMatchingFlags flags, BOOL *stop){

        BOOL paydesk = ([qrCodeObject.stringValue rangeOfString:@"/paydesk/"].location != NSNotFound);

        if (paydesk) {
            [self paydescPayWithUrl:qrCodeObject.stringValue];
        } else {
            NSString *token = [[qrCodeObject.stringValue componentsSeparatedByString:@"/receipt/"] lastObject];
            [self receiptPayWithToken:token];
        }

        canScanQR = NO;

    }];
}

- (BOOL)isMpQrScan: (NSString *)qrCodeString {
    NSString *const expression = @"^0002.{2}0102.*";
    NSError *error = nil;

    NSRegularExpression * const regExpr =
    [NSRegularExpression regularExpressionWithPattern:expression
                                              options:NSRegularExpressionCaseInsensitive
                                                error:&error];

    NSTextCheckingResult * const matchResult = [regExpr firstMatchInString:qrCodeString
                                                                   options:0 range:NSMakeRange(0, [qrCodeString length])];

    return matchResult ? YES : NO;
}

- (void)parseQRCode:(NSString *)code {
    //USER PHONE IN FORMAT 380#########
    NSString *userPhoneNumber = @"380951912889";
    [TCCAPI initMpWithUserPhone:userPhoneNumber completion:^(id responseObject, NSString *errorStr) {
        [TCCAPI checkMpEndUser:^(MfsResponse *responseObject) {
            NSString *userPassEndString = [[responseObject.cardStatus substringFromIndex:1]substringToIndex:4];
            if ([userPassEndString isEqualToString:@"0000"]) {
                NSLog(@"MPEndUserDontHave");
                [self openRegisterViewController];
            } else if ([userPassEndString isEqualToString:@"1100"]) {
                NSLog(@"MPEndUserNotLink");
                [self linkMpToMerchant];
            } else if ([userPassEndString isEqualToString:@"1110"]) {
                NSLog(@"MPEndUserLink");
                [self openPayViewControllerWithQrString:code];
            } else {
                NSLog(@"MPEndUserUnknown");
            }
        }];
    }];
}



- (void)paydescPayWithUrl: (NSString *)url {
    PaydescPayWithUrlViewController *rpVC = [[PaydescPayWithUrlViewController alloc]initWithNibName:@"WalletPickController" bundle:nil];
    rpVC.urlString = url;
    [self.navigationController pushViewController:rpVC animated:YES];
}

- (void)receiptPayWithToken: (NSString *)token {
    ReceiptPayWithTokenViewController *rpVC = [[ReceiptPayWithTokenViewController alloc]initWithNibName:@"WalletPickController" bundle:nil];
    rpVC.tokenString = token;
    [self.navigationController pushViewController:rpVC animated:YES];
}

#pragma mark -
#pragma mark Masterpass actions

- (void)openRegisterViewController {
    MasterpassRegisterViewController *vc = [MasterpassRegisterViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)linkMpToMerchant {
    [TCCAPI linkMpAccount:^(id responseObject, NSString *errorStr) {
        if ([(MfsResponse *)responseObject result]) {
            NSLog(@"succes link");
        } else if([[(MfsResponse *)responseObject errorCode] isEqualToString:@"5001"]){
            NSLog(@"OTP asked");
            MasterpassVcodeViewController *vc = [MasterpassVcodeViewController new];
            vc.vcodeCurrentType = vcodeTypeLink;
            vc.tokenString = [(MfsResponse *)responseObject token];
            [self.navigationController pushViewController:vc animated:YES];

        } else if([[(MfsResponse *)responseObject errorCode] isEqualToString:@"5007"]){
            NSLog(@"OTP asked");
            MasterpassVcodeViewController *vc = [MasterpassVcodeViewController new];
            vc.tokenString = [(MfsResponse *)responseObject token];
            vc.vcodeCurrentType = vcodeTypeLink;
            [self.navigationController pushViewController:vc animated:YES];
        } else {
            NSLog(@"%@",errorStr);
        }
    }];
}

- (void)openPayViewControllerWithQrString:(NSString *)qrString {
    MasterpassPayViewController *vc = [MasterpassPayViewController new];
    vc.operationType = OperationTypeQrPay;
    vc.qrString = qrString;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -
#pragma mark Focus

- (void)focusTapGestureHandler:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state != UIGestureRecognizerStateRecognized) {
        return;
    }

    CGPoint location = [recognizer locationInView:self.contentView];
    CGSize frameSize = self.contentView.bounds.size;

    CGPoint pointOfInterest = CGPointMake(location.y / frameSize.height, 1.f - (location.x / frameSize.width));

    NSError *error = nil;
    if ([self.device lockForConfiguration:&error]) {

        if ([self.device isFocusPointOfInterestSupported] && [self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.device setFocusPointOfInterest:pointOfInterest];
            [self.device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        }

        if ([self.device isExposurePointOfInterestSupported] && [self.device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
            [self.device setExposurePointOfInterest:pointOfInterest];
            [self.device setExposureMode:AVCaptureExposureModeContinuousAutoExposure];
        }

        [self.device unlockForConfiguration];
    }
}


@end
