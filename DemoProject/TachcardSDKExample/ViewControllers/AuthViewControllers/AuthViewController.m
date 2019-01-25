//
//  RegistrationViewController.m
//  TachcardSDKExample
//
//  Created by admin on 4/20/17.
//  Copyright © 2017 CWG. All rights reserved.
//

#import "AuthViewController.h"
#import <TachcardSDK/TCCAPI.h>
#import "MainViewController.h"

@interface AuthViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tokenTextField;
@end

@implementation AuthViewController

#pragma mark -
#pragma mark Lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
}

#pragma mark -
#pragma mark IBAction

- (IBAction)authUser:(id)sender {
    @weakify(self);//USER TOKEN
    [TCCAPI authUserWithUserToken:@"USER TOKEN" pushToken:nil completion:^(id responseObject, NSString *errorStr) {
        @strongify(self);
        if (errorStr) {
            NSLog(@"%@",errorStr);
            // ERROR
            return;
        }
        MainViewController *mainVC = [MainViewController new];
        [self.navigationController pushViewController:mainVC animated:YES];
    }];
}


@end
