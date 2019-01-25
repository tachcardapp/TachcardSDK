//
//  ReceiptPayWithTokenViewController.m
//  TachcardSDKExample
//
//  Created by admin on 4/26/17.
//  Copyright © 2017 CWG. All rights reserved.
//

#import "ReceiptPayWithTokenViewController.h"

@interface ReceiptPayWithTokenViewController ()
@property (nonatomic, retain) NSString *invoiceToken;
@end

@implementation ReceiptPayWithTokenViewController

- (void)viewDidLoad {
    @weakify(self);
    [TCCAPI viewInvoiceWithToken:self.tokenString completion:^(id responseObject, NSString *errorStr) {
        @strongify(self);
        self.invoiceToken = responseObject[@"receipt"][@"token"];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    [TCCAPI payInvoiceWithToken:self.invoiceToken walletToken:self.walletsArray[indexPath.row][@"token"] completion:^(id responseObject, NSString *errorStr) {
        @strongify(self);
        [self payConfirm:responseObject[@"payment"][@"token"]];
    }];
}

- (void)payConfirm: (NSString *)paymentToken {
    @weakify(self);
    [TCCAPI payConfirmWithToken:paymentToken completion:^(id responseObject, NSString *errorStr) {
        @strongify(self);
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

@end
