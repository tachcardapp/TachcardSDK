//
//  MasterpassPayViewController.m
//  TachcardSDKExample
//
//  Created by admin on 3/2/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "MasterpassPayViewController.h"
#import "MasterpassWebViewController.h"
#import "MasterpassVcodeViewController.h"
#import "MasterpassRegisterViewController.h"
@import MasterpassQRCoreSDK;

@interface MasterpassPayViewController ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *urlStringTextField;
@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSArray *mpWalletsArray;
@end

@implementation MasterpassPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getMpWallets];

    switch (self.operationType) {
        case OperationTypeQrPay: {
            MPQRError *error;
            PushPaymentData *pushPaymentData = [MPQRParser parseWithoutTagValidation:self.qrString error:&error];

            NSString *masterpassMerchantNameString = (pushPaymentData.languageData)?pushPaymentData.languageData.alternateMerchantName:pushPaymentData.merchantName;
            NSString *masterpassAmountString = [NSString stringWithFormat:@"%.2f",pushPaymentData.transactionAmount.floatValue/100];

            [self.amountTextField setText:masterpassAmountString];
            [self.urlStringTextField setText:self.qrString];
            [self.nameLabel setText:masterpassMerchantNameString];

            [self.accountTextField setHidden:YES];
        }

            break;

        default:
            break;
    }

    UIBarButtonItem *confirmBtn = [[UIBarButtonItem alloc] initWithTitle:@"ADD" style:UIBarButtonItemStylePlain target:self action:@selector(addMpWallet)];
    self.navigationItem.rightBarButtonItem = confirmBtn;
}

- (void)addMpWallet {
    MasterpassRegisterViewController *vc = [MasterpassRegisterViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)getMpWallets {
    [TCCAPI getMpWallets:^(id responseObject, NSString *errorStr) {
        if (errorStr) {
            NSLog(@"%@",errorStr);
        } else {
            self.mpWalletsArray = responseObject;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark -
#pragma mark UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.mpWalletsArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;

    cell = [tableView dequeueReusableCellWithIdentifier:@""];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:@""];

        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = [(MfsCard *)self.mpWalletsArray[indexPath.row] cardName];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (self.operationType) {
        case OperationTypeSimplePay: {
            [TCCAPI getPhoenixOptionWithUrlString:self.urlStringTextField.text completion:^(id responseObject, NSString *errorStr) {

                [TCCAPI getServiceReceiptTokenWithPaydescUrl:responseObject[@"paydescUrl"] amount:self.amountTextField.text accountId:self.accountTextField.text completion:^(id responseObject, NSString *errorStr) {
                    if (errorStr) {
                        NSLog(@"%@",errorStr);
                    } else {
                        [TCCAPI payInvoiceMpWithToken:responseObject[@"receipt"][@"token"] completion:^(id responseObject, NSString *errorStr) {
                            if (errorStr) {
                                NSLog(@"%@",errorStr);
                            } else {
                                [TCCAPI payMpWithCardName:[(MfsCard *)self.mpWalletsArray[indexPath.row] cardName] amount:responseObject[@"payment"][@"amount"] paymentToken:responseObject[@"payment"][@"token"] paramsDict:nil qrData:nil completion:^(id responseObject, NSString *errorStr) {

                                    if([(MfsResponse *)responseObject[@"mp_response"] result]){
                                        NSLog(@"Purchase Successfully completed");
                                        [self confirmPaymentWithParams:responseObject[@"additional_params"]];
                                    } else if ([[(MfsResponse *)responseObject[@"mp_response"] errorCode] isEqualToString:@"5001"]){
                                        MasterpassVcodeViewController *vc = [MasterpassVcodeViewController new];
                                        vc.vcodeCurrentType = vcodeTypePay;
                                        vc.responseObject = responseObject;
                                        vc.delegate = (id)self;
                                        vc.tokenString = [(MfsResponse *)responseObject[@"mp_response"] token];
                                        [self.navigationController pushViewController:vc animated:YES];
                                        NSLog(@"OTP asked");
                                    } else if([[(MfsResponse *)responseObject[@"mp_response"] errorCode] isEqualToString:@"5010"]){
                                        MasterpassWebViewController *vc = [MasterpassWebViewController new];
                                        vc.responseObject = responseObject;
                                        vc.webType = Masterpass3dWebTypePay;
                                        vc.delegate = (id)self;
                                        [self.navigationController pushViewController:vc animated:YES];
                                        NSLog(@"3D OTP asked");
                                    } else {
                                        NSLog(@"%@",[(MfsResponse *)responseObject[@"mp_response"] errorDescription]);
                                    }
                                }];
                            }
                        }];
                    }
                }];
            }];
        }
            break;
        case OperationTypeQrPay: {
            [TCCAPI getMasterpassQrAccountWithCompletion:^(id responseObject, NSString *errorStr) {
                NSString *walletToken = responseObject[@"account"][@"token"];
                [TCCAPI createInvoiceWithAmount:self.amountTextField.text walletToken:walletToken completion:^(id responseObject, NSString *errorStr) {
                    [TCCAPI payInvoiceMpWithToken:responseObject[@"receipt"][@"token"] completion:^(id responseObject, NSString *errorStr) {

                        // important qrData:self.qrString
                        [TCCAPI payMpWithCardName:[(MfsCard *)self.mpWalletsArray[indexPath.row] cardName] amount:responseObject[@"payment"][@"amount"] paymentToken:responseObject[@"payment"][@"token"] paramsDict:nil qrData:self.qrString completion:^(id responseObject, NSString *errorStr) {

                            if([(MfsResponse *)responseObject[@"mp_response"] result]){
                                NSLog(@"Purchase Successfully completed");
                                [self confirmPaymentWithParams:responseObject[@"additional_params"]];
                            } else if ([[(MfsResponse *)responseObject[@"mp_response"] errorCode] isEqualToString:@"5001"]){
                                MasterpassVcodeViewController *vc = [MasterpassVcodeViewController new];
                                vc.vcodeCurrentType = vcodeTypePay;
                                vc.responseObject = responseObject;
                                vc.delegate = (id)self;
                                vc.tokenString = [(MfsResponse *)responseObject[@"mp_response"] token];
                                [self.navigationController pushViewController:vc animated:YES];
                                NSLog(@"OTP asked");
                            } else if([[(MfsResponse *)responseObject[@"mp_response"] errorCode] isEqualToString:@"5010"]){
                                MasterpassWebViewController *vc = [MasterpassWebViewController new];
                                vc.responseObject = responseObject;
                                vc.webType = Masterpass3dWebTypePay;
                                vc.delegate = (id)self;
                                [self.navigationController pushViewController:vc animated:YES];
                                NSLog(@"3D OTP asked");
                            } else {
                                NSLog(@"%@",[(MfsResponse *)responseObject[@"mp_response"] errorDescription]);
                            }
                        }];
                    }];
                }];
            }];
        }
            break;
        default:
            break;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [TCCAPI deleteMpCardWithName:[(MfsCard *)self.mpWalletsArray[indexPath.row] cardName] completion:^(id responseObject, NSString *errorStr) {
            if (errorStr) {
                NSLog(@"%@",errorStr);
            } else {
                NSLog(@"succes");
                [self getMpWallets];
            }
        }];
    }
}


#pragma mark -
#pragma mark Payment actions

- (void)confirmPaymentWithParams:(NSDictionary *)params {
    [TCCAPI payConfirmWithAdditionalParams:params completion:^(id responseObject, NSString *errorStr) {
        if (errorStr) {
            NSLog(@"%@",errorStr);
        } else {
            NSLog(@"Succes PAY");
        }
    }];
}



@end
