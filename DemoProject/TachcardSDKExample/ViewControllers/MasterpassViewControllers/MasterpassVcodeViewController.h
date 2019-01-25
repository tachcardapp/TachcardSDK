//
//  MasterpassVcodeViewController.h
//  TachcardSDKExample
//
//  Created by admin on 3/2/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, vcodeType) {
    vcodeTypePay = 1,
    vcodeTypeCard,
    vcodeTypeLink
};

@protocol MasterpassVcodeDelegate <NSObject>
- (void)confirmPaymentWithParams:(NSDictionary *)params;
@end

@interface MasterpassVcodeViewController : UIViewController

@property (nonatomic, retain) NSString *tokenString;
@property (nonatomic, weak) NSObject<MasterpassVcodeDelegate> *delegate;
@property (nonatomic, retain) NSDictionary *responseObject;

@property vcodeType vcodeCurrentType;

@end
