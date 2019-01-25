//
//  ServicePayViewController.m
//  TachcardSDKExample
//
//  Created by admin on 11/1/17.
//  Copyright © 2017 CWG. All rights reserved.
//

#import "ServicePayViewController.h"

@interface ServicePayViewController ()
@property (weak, nonatomic) IBOutlet UITextField *payPointTextField;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *panTextField;
@property (weak, nonatomic) IBOutlet UITextField *monthTextField;
@property (weak, nonatomic) IBOutlet UITextField *yearTextField;
@property (weak, nonatomic) IBOutlet UITextField *cvvTextField;

@property (nonatomic, retain) NSString *receiptTokenString;
@property (nonatomic, retain) NSString *paymentTokenString;

@property BOOL freePay;

@end

@implementation ServicePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.freePay = NO;

    [self getServiceReceipt:^(id responseObject, NSString *errorStr) {
        [self getPayInvoiceWithWalletToken:self.walletsArray[indexPath.row][@"token"]];
    }];
}

- (IBAction)freeCardPay:(id)sender {
    self.freePay = YES;
    [self getFreeCardToken];
}

- (void)getFreeCardToken {
    [self getServiceReceipt:^(id responseObject, NSString *errorStr) {
        [TCCAPI getFreeCardTokenWithCardNumber:self.panTextField.text cvvString:self.cvvTextField.text expMonth:self.monthTextField.text expYear:self.yearTextField.text receiptToken:self.receiptTokenString completion:^(id responseObject, NSString *errorStr) {

            [self getPayInvoiceWithWalletToken:responseObject[@"token"]];

        }];
    }];
}

- (void)getServiceReceipt:(TCCCompletionBlock)completion {
    [TCCAPI getServiceReceiptTokenWithPaydescUrl:self.payPointTextField.text amount:self.amountTextField.text accountId:self.accountTextField.text completion:^(id responseObject, NSString *errorStr) {

        NSLog(@"%@",responseObject);


        if (errorStr) {
            // ERROR
            return;
        }
        self.receiptTokenString = responseObject[@"receipt"][@"token"];
        completion(responseObject, nil);
    }];
}

- (void)getPayInvoiceWithWalletToken: (NSString *)walletToken {
    [TCCAPI payInvoiceWithToken:self.receiptTokenString walletToken:walletToken completion:^(id responseObject, NSString *errorStr) {
        if (errorStr) {
            // ERROR
            return;
        }

        self.paymentTokenString = responseObject[@"payment"][@"token"];
        if (self.freePay == YES) {
            [self freeCardPayPrepare];
        } else {
            [self confirmPayment];
        }
    }];
}


- (void)freeCardPayPrepare {
    [TCCAPI freeCardPaymentPrepareWithReceiptToken:self.receiptTokenString paymentToken:self.paymentTokenString completion:^(id responseObject, NSString *errorStr) {
        if ([[responseObject allKeys]containsObject:@"is_redirect"]) {
            if ([responseObject[@"is_redirect"]boolValue] == TRUE) {

                return;
            }
        }
        [self confirmPayment];
    }];

}

- (void)confirmPayment {
    [TCCAPI payConfirmWithToken:self.paymentTokenString completion:^(id responseObject, NSString *errorStr) {
        if (errorStr) {
            // ERROR
            return;
        }
        NSLog(@"SUCCES");
    }];
}



@end
