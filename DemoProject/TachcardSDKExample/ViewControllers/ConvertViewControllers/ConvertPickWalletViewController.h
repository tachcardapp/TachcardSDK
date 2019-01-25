//
//  ConvertPickWalletViewController.h
//  TachcardSDKExample
//
//  Created by admin on 4/26/17.
//  Copyright © 2017 CWG. All rights reserved.
//

#import "WalletPickController.h"

@protocol WalletsListDelegate <NSObject>
- (void)didCloseWithWallet :(NSDictionary *)wallet andIndex:(int)index;
@end


@interface ConvertPickWalletViewController : WalletPickController
@property int index;
@property (assign) __unsafe_unretained id <WalletsListDelegate> delegate;

@end
