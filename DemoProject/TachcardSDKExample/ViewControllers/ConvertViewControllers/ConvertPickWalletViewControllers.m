//
//  ConvertPickWalletViewControllers.m
//  TachcardSDKExample
//
//  Created by admin on 4/26/17.
//  Copyright © 2017 CWG. All rights reserved.
//

#import "ConvertPickWalletViewControllers.h"
#import "ConvertPickWalletViewController.h"

@interface ConvertPickWalletViewControllers ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *walletsArray;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@end

@implementation ConvertPickWalletViewControllers

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getWallets];
}

- (void)getWallets {
    [TCCAPI getWallets:^(id responseObject, NSString *errorStr) {
        if (errorStr) {
            // ERROR
            return;
        }
        if ([responseObject[@"accounts"] count]<2) { // must be more than one wallet 
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }

        self.walletsArray = [NSMutableArray new];
        [self.walletsArray addObject:responseObject[@"accounts"][0]];
        [self.walletsArray addObject:responseObject[@"accounts"][1]];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.textLabel.text = self.walletsArray[indexPath.section][@"name"];
    cell.detailTextLabel.text = self.walletsArray[indexPath.section][@"info"];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ConvertPickWalletViewController *pickVC = [[ConvertPickWalletViewController alloc]initWithNibName:@"WalletPickController" bundle:nil];
    pickVC.delegate = (id)self;
    pickVC.index = (int)indexPath.section;
    [self.navigationController pushViewController:pickVC animated:YES];
}

- (void)didCloseWithWallet :(NSDictionary *)wallet andIndex:(int)index {
    if ([self.walletsArray[1-index][@"token"] isEqualToString:wallet[@"token"]]) {
        [self replaceWallets:self];
        [self.walletsArray replaceObjectAtIndex:index withObject:wallet];
        [self.tableView reloadData];
    } else {
        [self.walletsArray replaceObjectAtIndex:index withObject:wallet];
        [self.tableView reloadData];
    }
}

- (IBAction)replaceWallets:(id)sender {
    NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:self.walletsArray];
    [self.walletsArray replaceObjectAtIndex:0 withObject:tmpArray[1]];
    [self.walletsArray replaceObjectAtIndex:1 withObject:tmpArray[0]];
    [self.tableView reloadData];
}

- (IBAction)convert:(id)sender {
    @weakify(self);
    [TCCAPI createExchangeInvoiceWithAmount:@(self.textField.text.floatValue) fromWalletToken:self.walletsArray[0][@"token"] toWalletToken:self.walletsArray[0][@"token"] completion:^(id responseObject, NSString *errorStr) {
        @strongify(self);

        [self confirmExchange:responseObject[@"exchange_token"]];

    }];
}

- (void)confirmExchange:(NSString *)token {
    @weakify(self);
    [TCCAPI confirmExchangeInvoiceWithToken:token completion:^(id responseObject, NSString *errorStr) {
        @strongify(self);
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

@end
