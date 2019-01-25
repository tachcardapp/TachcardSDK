//
//  MasterpassVcodeViewController.m
//  TachcardSDKExample
//
//  Created by admin on 3/2/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "MasterpassVcodeViewController.h"

@interface MasterpassVcodeViewController ()
@property (nonatomic, retain) IBOutlet MfsTextField *codeTextField;
@end

@implementation MasterpassVcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)nextButtonHandler:(id)sender {
    [TCCAPI validateMpTransaction:self.tokenString textField:self.codeTextField completion:^(id responseObject, NSString *errorStr) {
        if (errorStr) {
            NSLog(@"%@",errorStr);
        } else {
            if([(MfsResponse *)responseObject result]){
                switch (self.vcodeCurrentType) {
                    case vcodeTypePay: {
                        NSLog(@"SUCCES");
                        if ([self.delegate respondsToSelector:@selector(confirmPaymentWithParams:)]) {
                            [self.responseObject[@"additional_params"][@"mp_data"]setObject:[(MfsResponse *)responseObject token] forKey:@"token"]; // important to change token!!! 
                            [self.delegate confirmPaymentWithParams:self.responseObject[@"additional_params"]];
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    }
                        break;
                    case vcodeTypeCard: {
                         [self.navigationController popToRootViewControllerAnimated:YES];
                    }
                        break;
                    case vcodeTypeLink: {
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                        break;
                    default:
                        break;
                }
            } else if ([[(MfsResponse *)responseObject errorCode] isEqualToString:@"5001"]){
                NSLog(@"OTP asked");
                MasterpassVcodeViewController *vc = [MasterpassVcodeViewController new];
                vc.vcodeCurrentType = self.vcodeCurrentType;
                vc.tokenString = [(MfsResponse *)responseObject token];
                vc.delegate = (id)self;
                [self.navigationController pushViewController:vc animated:YES];
            } else if ([[(MfsResponse *)responseObject errorCode] isEqualToString:@"5007"]){
                NSLog(@"OTP MasterPass is asked");
                MasterpassVcodeViewController *vc = [MasterpassVcodeViewController new];
                vc.tokenString = [(MfsResponse *)responseObject token];
                vc.vcodeCurrentType = self.vcodeCurrentType;
                vc.delegate = (id)self;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    }];
}

- (IBAction)resentSms:(id)sender {
    [TCCAPI resendMpOtp:self.tokenString completion:^(id responseObject, NSString *errorStr) {
        if (errorStr) {
            NSLog(@"%@",errorStr);
        }
        NSLog(@"succes");
    }];
}

@end
