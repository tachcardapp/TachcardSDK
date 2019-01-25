//
//  QrImageViewController.m
//  TachcardSDKExample
//
//  Created by admin on 4/26/17.
//  Copyright © 2017 CWG. All rights reserved.
//

#import "QrImageViewController.h"

@interface QrImageViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation QrImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setQrImage];
    [self startWaitingPayment];
}

- (void)setQrImage {
    [self.imageView setImage:[TCCAPI getQrImageWithToken:self.invoiceToken size:self.imageView.bounds.size.width]];
}

- (void)startWaitingPayment {
    @weakify(self);
    [TCCAPI startWaitPaymentWithSessionToken:self.invoiceToken walletToken:self.walletToken completion:^(id responseObject, NSString *errorStr) {
        @strongify(self);
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

- (IBAction)stopPayment:(id)sender {
    //[TCCAPI stopWaitPaymen];
}

@end
