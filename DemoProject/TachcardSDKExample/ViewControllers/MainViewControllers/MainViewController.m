//
//  MainViewControllers.m
//  TachcardSDKExample
//
//  Created by admin on 4/24/17.
//  Copyright © 2017 CWG. All rights reserved.
//

#import "MainViewController.h"
#import <TachcardSDK/TCCAPI.h>
#import "AccountsViewController.h"
#import "QrInvoiceViewController.h"
#import "QrScanViewController.h"
#import "PayTypeViewController.h"
#import "AuthViewController.h"

@interface MainViewController ()
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@end

@implementation MainViewController

#pragma mark -
#pragma mark Lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    [self getChanges];
}

- (void)getChanges {
    @weakify(self);
    [TCCAPI getChangesWithDate:@"1970-01-01 00:00:00" completion:^(id responseObject, NSString *errorStr) {
        @strongify(self);
        if (errorStr) {
            // ERROR
            return;
        }
        [self.amountLabel setText:[NSString stringWithFormat:@"%@",responseObject[@"user"][@"balance"]]];
    }];
}

- (IBAction)walletsList:(id)sender {
    AccountsViewController *accountVC = [[AccountsViewController alloc]initWithNibName:@"WalletPickController" bundle:nil];
    [self.navigationController pushViewController:accountVC animated:YES];
}

- (IBAction)getVC:(id)sender {
    QrInvoiceViewController *qrVC = [QrInvoiceViewController new];
    [self.navigationController pushViewController:qrVC animated:YES];
}

- (IBAction)scanVC:(id)sender {
    QrScanViewController *qrVC = [QrScanViewController new];
    [self.navigationController pushViewController:qrVC animated:YES];
}

- (IBAction)convertVC:(id)sender {
    PayTypeViewController *payTypeVC = [PayTypeViewController new];
    [self.navigationController pushViewController:payTypeVC animated:YES];
}

- (IBAction)logout:(id)sender {
    AuthViewController *authVC = [AuthViewController new];
    [self.navigationController pushViewController:authVC animated:YES];
    [TCCAPI logOut];
}

@end
