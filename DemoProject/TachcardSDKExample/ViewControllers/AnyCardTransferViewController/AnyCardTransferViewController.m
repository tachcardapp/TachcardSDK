//
//  AnyCardTransferViewController.m
//  TachcardSDKExample
//
//  Created by admin on 5/15/17.
//  Copyright © 2017 CWG. All rights reserved.
//

#import "AnyCardTransferViewController.h"

@interface AnyCardTransferViewController ()
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardNumTextField;
@end

@implementation AnyCardTransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [TCCAPI anyCardTransferCalcWithAmount:@(self.amountTextField.text.floatValue) completion:^(id responseObject, NSString *errorStr) {

    }];
    
    @weakify(self);
    [TCCAPI anyCardTransferWithAmount:self.amountTextField.text walletToken:self.walletsArray[indexPath.row][@"token"] cardNumber:self.cardNumTextField.text completion:^(id responseObject, NSString *errorStr) {
        if (errorStr) {
            NSLog(@"%@",errorStr);
            return;
        }
        [TCCAPI anyCardTransferConfirmWithToken:responseObject[@"c2ctransfer_token"] completion:^(id responseObject, NSString *errorStr) {
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}


@end
