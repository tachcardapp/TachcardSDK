//
//  PayTypeViewController.m
//  TachcardSDKExample
//
//  Created by admin on 5/15/17.
//  Copyright © 2017 CWG. All rights reserved.
//

#import "PayTypeViewController.h"
#import "ConvertPickWalletViewControllers.h"
#import "AnyCardTransferViewController.h"
#import "ServicePayViewController.h"
#import "MasterpassRegisterViewController.h"
#import "MasterpassPayViewController.h"
#import "MasterpassVcodeViewController.h"

@interface PayTypeViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation PayTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark -
#pragma mark UITableView delegate

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"convert";
            break;
        case 1:
            cell.textLabel.text = @"anyCard";
            break;
        case 2:
            cell.textLabel.text = @"service pay";
            break;
        case 3:
            cell.textLabel.text = @"masterpass";
            break;
        default:
            break;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            ConvertPickWalletViewControllers *cinvertVC = [ConvertPickWalletViewControllers new];
            [self.navigationController pushViewController:cinvertVC animated:YES];
        }
            break;
        case 1: {
            AnyCardTransferViewController *cardVC = [AnyCardTransferViewController new];
            [self.navigationController pushViewController:cardVC animated:YES];
        }
            break;
        case 2: {
            ServicePayViewController *cardVC = [ServicePayViewController new];
            [self.navigationController pushViewController:cardVC animated:YES];
        }
            break;
        case 3: {
            [self mpCellHandler];
        }
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark Masterpass actions

- (void)mpCellHandler {
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
                [self openPayViewController];
            } else {
                NSLog(@"MPEndUserUnknown");
            }
        }];
    }];
}

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

- (void)openPayViewController {
    MasterpassPayViewController *vc = [MasterpassPayViewController new];
    vc.operationType = OperationTypeSimplePay;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
