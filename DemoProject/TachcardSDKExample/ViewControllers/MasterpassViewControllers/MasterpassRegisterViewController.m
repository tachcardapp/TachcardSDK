//
//  MasterpassRegisterViewController.m
//  TachcardSDKExample
//
//  Created by admin on 3/2/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "MasterpassRegisterViewController.h"
#import "MasterpassVcodeViewController.h"
#import "MasterpassWebViewController.h"

@interface MasterpassRegisterViewController ()
@property (strong, nonatomic) IBOutlet MfsTextField *cvvTextField;
@property (strong, nonatomic) IBOutlet MfsTextField *cardNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UITextField *cardNameTextField;
@end

@implementation MasterpassRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.cardNumberTextField setType:1];
    self.cardNumberTextField.placeholder = @"0000 0000 0000 0000";
    [self.cardNumberTextField setMaxLength:20];
}

- (IBAction)nextButtonHandler:(id)sender {
    NSArray *dateArray = [self.dateTextField.text componentsSeparatedByString:@"/"];
    NSString *monthStr;
    NSString *yearStr;

    if ([dateArray count]>=2) {
        monthStr = dateArray[0];
        yearStr = dateArray[1];
    }
    [self.view endEditing:YES];

    [TCCAPI addMpCardWithName:self.cardNameTextField.text month:monthStr year:yearStr cardNumberField:self.cardNumberTextField cvvField:self.cvvTextField param:nil completion:^(id responseObject, NSString *errorStr) {
        if (errorStr) {
            if ([errorStr isEqualToString:@"5001"]) {
                NSLog(@"OTP verification required");
                            MasterpassVcodeViewController *vc = [MasterpassVcodeViewController new];
                            vc.tokenString = [(MfsResponse *)responseObject token];
                            vc.vcodeCurrentType = vcodeTypeCard;
                            [self.navigationController pushViewController:vc animated:YES];
            } else if ([errorStr isEqualToString:@"5007"]) {
                NSLog(@"OTP MasterPass Device verification required");
                            MasterpassVcodeViewController *vc = [MasterpassVcodeViewController new];
                            vc.vcodeCurrentType = vcodeTypeCard;
                            vc.tokenString = [(MfsResponse *)responseObject token];
                            [self.navigationController pushViewController:vc animated:YES];
            } else if([errorStr isEqualToString:@"5008"]) {
                NSLog(@"OTP MasterPass Phone Number verification required");
                            MasterpassVcodeViewController *vc = [MasterpassVcodeViewController new];
                            vc.vcodeCurrentType = vcodeTypeCard;
                            vc.tokenString = [(MfsResponse *)responseObject token];
                            [self.navigationController pushViewController:vc animated:YES];
            } else if([errorStr isEqualToString:@"5010"]) {
                NSLog(@"3D secure required");
                            MasterpassWebViewController *vc = [MasterpassWebViewController new];
                            vc.responseObject = @{@"mp_response":responseObject};
                            vc.webType = Masterpass3dWebTypeCard;
                            [self.navigationController pushViewController:vc animated:YES];
            } else if([errorStr isEqualToString:@"5015"]) {
                NSLog(@"PIN define required");
                            MasterpassVcodeViewController *vc = [MasterpassVcodeViewController new];
                            vc.vcodeCurrentType = vcodeTypeCard;
                            vc.tokenString = [(MfsResponse *)responseObject token];
                            [self.navigationController pushViewController:vc animated:YES];
            } else {
                NSLog(@"%@",errorStr);
            }
        } else {
            NSLog(@"SUCCES");
        }
    }];
}

@end
