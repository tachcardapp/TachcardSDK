//
//  AccountsViewController.m
//  TachcardSDKExample
//
//  Created by admin on 4/25/17.
//  Copyright © 2017 CWG. All rights reserved.
//

#import "AccountsViewController.h"
#import <TachcardSDK/TCCAPI.h>
#import "AddCardViewController.h"

@interface AccountsViewController ()

@end

@implementation AccountsViewController

#pragma mark -
#pragma mark Lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];

    UIBarButtonItem *confirmBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"PlusIconNL"] style:UIBarButtonItemStylePlain target:self action:@selector(addWallet:)];
    self.navigationItem.rightBarButtonItem = confirmBtn;
}

#pragma mark -
#pragma mark IBAction

- (IBAction)addWallet:(id)sender {
    AddCardViewController *addCardVC = [AddCardViewController new];
    [self.navigationController pushViewController:addCardVC animated:YES];
}

@end
