//
//  QrImageViewController.m
//  TachcardSDKExample
//
//  Created by admin on 4/26/17.
//  Copyright © 2017 CWG. All rights reserved.
//

#import "QrInvoiceViewController.h"
#import "QrImageViewController.h"

@interface QrInvoiceViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray *walletsArray;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@end

@implementation QrInvoiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [self getWallets];
}

- (void)getWallets {
    [TCCAPI getWallets:^(id responseObject, NSString *errorStr) {
        if (errorStr) {
            // ERROR
            return;
        }
        self.walletsArray = responseObject[@"accounts"];
        [self.tableView reloadData];
    }];
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
    return self.walletsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = self.walletsArray[indexPath.row][@"name"];
    cell.detailTextLabel.text = self.walletsArray[indexPath.row][@"info"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @weakify(self);
    [TCCAPI createInvoiceWithAmount:self.amountTextField.text walletToken:self.walletsArray[indexPath.row][@"token"] completion:^(id responseObject, NSString *errorStr) {
        @strongify(self);
        if (errorStr) {
            // ERROR
            return;
        }

        QrImageViewController *QrVC = [QrImageViewController new];
        QrVC.invoiceToken = responseObject[@"receipt"][@"token"];
        QrVC.walletToken = self.walletsArray[indexPath.row][@"token"];
        [self.navigationController pushViewController:QrVC animated:YES];
        
    }];
}


@end
