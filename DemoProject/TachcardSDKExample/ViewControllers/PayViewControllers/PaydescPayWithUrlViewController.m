//
//  paydescPayWithUrlViewController.m
//  TachcardSDKExample
//
//  Created by admin on 4/26/17.
//  Copyright © 2017 CWG. All rights reserved.
//

#import "PaydescPayWithUrlViewController.h"

@interface PaydescPayWithUrlViewController ()
@property (nonatomic, retain) NSString *invoiceToken;
@end

@implementation PaydescPayWithUrlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self paydescPayWithUrl:self.urlString];
}

- (void)paydescPayWithUrl: (NSString *)url {
    @weakify(self);
    [TCCAPI viewStaticInvoiceWithRequest:url completion:^(id responseObject, NSString *errorStr) {
        @strongify(self);
        if ([responseObject[@"receipt"]isKindOfClass:[NSNull class]]) {

            NSDictionary *fooDict = @{@"name_1":@"value",@"name_2":@"value"}; // dictionary with data where key = responseObject[@"fields"][i][@"name"] and value that wrote user in field

            [self postRequestWithParams:fooDict];

        } else {
            [self payReceiptWithtoken:responseObject[@"receipt"][@"token"]];
        }
    }];
}

- (void)postRequestWithParams: (NSDictionary *)params {
    @weakify(self);
    [TCCAPI postRequestWithUrl:self.urlString params:params completion:^(id responseObject, NSString *errorStr) {
        @strongify(self);
        if ([responseObject[@"receipt"]isKindOfClass:[NSNull class]]) {
            //something wrong with params or need more data from user, check responseObject and send new params dictionary
            [self postRequestWithParams:params];
        } else {
            [self payReceiptWithtoken:responseObject[@"receipt"][@"token"]];
        }
    }];
}

- (void)payReceiptWithtoken:(NSString *)token {
    @weakify(self);
    [TCCAPI viewInvoiceWithToken:token completion:^(id responseObject, NSString *errorStr) {
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
