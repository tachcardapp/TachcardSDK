//
//  WalletPickController.m
//  TachcardSDKExample
//
//  Created by admin on 4/26/17.
//  Copyright © 2017 CWG. All rights reserved.
//

#import "WalletPickController.h"

@interface WalletPickController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation WalletPickController

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
}

@end
