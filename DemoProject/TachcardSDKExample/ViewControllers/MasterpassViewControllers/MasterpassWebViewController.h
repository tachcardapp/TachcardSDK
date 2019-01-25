//
//  MasterpassWebViewController.h
//  TachcardSDKExample
//
//  Created by admin on 3/3/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MasterpassWebViewDelegate <NSObject>
- (void)confirmPaymentWithParams:(NSDictionary *)params;
@end

typedef NS_ENUM(NSUInteger, Masterpass3dWebType) {
    Masterpass3dWebTypeCard = 0,
    Masterpass3dWebTypePay
};

@interface MasterpassWebViewController : UIViewController

@property (nonatomic, retain) NSDictionary *responseObject;
@property Masterpass3dWebType webType;

@property (nonatomic, weak) NSObject<MasterpassWebViewDelegate> *delegate;

@end
