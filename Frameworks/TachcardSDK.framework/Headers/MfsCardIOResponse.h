//
//  MfsCardIOResponse.h
//  MfsIOSLibrary
//
//  Created by ercu on 01/03/16.
//  Copyright © 2016 Phaymobile. All rights reserved.
//

#ifndef MfsCardIOResponse_h
#define MfsCardIOResponse_h

//#import "CardIOPaymentViewControllerDelegate.h"
//#import "CardIOCreditCardInfo.h"

@interface MfsCardIOResponse : NSObject

@property (strong, nonatomic)  NSString *expiryMonth;
@property (strong, nonatomic)  NSString *expiryYear;
//@property (nonatomic)  CardIOPaymentViewController *controller;
@end

#endif /* MfsCardIOResponse_h */
