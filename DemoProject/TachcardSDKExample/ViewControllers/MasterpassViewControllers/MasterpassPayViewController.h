//
//  MasterpassPayViewController.h
//  TachcardSDKExample
//
//  Created by admin on 3/2/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, OperationType) {
    OperationTypeSimplePay = 1,
    OperationTypeQrPay,
};

@interface MasterpassPayViewController : UIViewController
@property (nonatomic, assign) OperationType operationType;
@property (nonatomic, retain) NSString *qrString;
@end
