//
//  ConvertPickWalletViewController.m
//  TachcardSDKExample
//
//  Created by admin on 4/26/17.
//  Copyright © 2017 CWG. All rights reserved.
//

#import "ConvertPickWalletViewController.h"

@interface ConvertPickWalletViewController ()

@end

@implementation ConvertPickWalletViewController


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(didCloseWithWallet:andIndex:)]) {
        [self.delegate didCloseWithWallet:self.walletsArray[indexPath.row] andIndex:self.index];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
