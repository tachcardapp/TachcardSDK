//
//  MfsIOSLibrary.h
//  MfsIOSLibrary
//
//  Created by ercu on 17/02/15.
//  Copyright (c) 2015 Phaymobile. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MfsResponse.h"
#import "MfsTextField.h"
#import "MfsWebView.h"
//#import "MfsCheckbox.h"

@interface MfsIOSLibrary : NSObject

//typedef void (^MfsCallback)(BOOL success, NSDictionary *response, NSError *error);

typedef enum InputType : NSUInteger {PIN = 5001, OTP = 5002, DEFINE_PIN = 5015} InputType;


-(id)registerClient:(MfsCard*)card token:(NSString*)token registerCallback:(SEL)callback registerTarget:(id)target __attribute__ ((deprecated));

-(id)registerClient:(MfsCard*)card token:(NSString*)token textField:(MfsTextField*)textField cvv:(MfsTextField*)cvv registerCallback:(SEL)callback registerTarget:(id)target;

-(id)validateTransaction:(NSString*)token validationCode:(NSString*)validationCode validateTransactionCallback:(SEL)callback validateTransactionTarget:(id)target inputType:(int)inputType __attribute__ ((deprecated));

-(id)validateTransaction:(NSString*)token textField:(MfsTextField*)textField  validateTransactionCallback:(SEL)callback validateTransactionTarget:(id)target;

-(id)validateTransaction3D:(MfsWebView*)webView response:(MfsResponse *)response validateCallback:(SEL)validateCallback validateTarget:(id)validateTarget;

-(id)forgotPassword:(NSString*)msisdn token:(NSString*)token cardNo:(NSString*)cardNo forgotPasswordCallback:(SEL)callback forgotPasswordTarget:(id)target;

-(id)forgotPassword:(NSString*)msisdn token:(NSString*)token cardNo:(NSString*)cardNo cvv:(MfsTextField*)cvv forgotPasswordCallback:(SEL)callback forgotPasswordTarget:(id)target;

-(id)pay:(NSString*)cardName token:(NSString*)token amount:(NSString*)amount cvv:(MfsTextField*)cvv orderId:(NSString*)orderId payCallback:(SEL)callback payTarget:(id)target;

-(id)pay:(NSString*)cardName token:(NSString*)token amount:(NSString*)amount cvv:(MfsTextField*)cvv orderId:(NSString*)orderNo  installmentCount:(NSNumber*)installmentCount rewardName:(NSString*)rewardName rewardValue:(NSString*)rewardValue payCallback:(SEL)callback payTarget:(id)target;
    
-(id)getCards:(SEL)callback token:(NSString*)token getCardsTarget:(id)target;

-(id)deleteCard:(NSString*)cardName token:(NSString*)token deleteCallback:(SEL)callback deleteTarget:(id)target;

-(id)addCardToMasterPass:(NSString*)msisdn token:(NSString*)token cardName:(NSString*)cardName addCardCallback:(SEL)callback addCardTarget:(id)target;


-(id)linkCardToClient:(NSString*)msisdn token:(NSString*)token cardName:(NSString*)cardName linkCallback:(SEL)callback linkTarget:(id)target;

-(id)checkMasterPassEndUser:(NSString*)userId token:(NSString*)token checkCallback:(SEL)callback checkTarget:(id)target;

-(id)resendOtp:(NSString*)token resendOtpCallback:(SEL)callback resendOtpTarget:(id)target;


-(id)directPurchase:(MfsCard*)card token:(NSString*)token amount:(NSString*)amount textField:(MfsTextField*)textField cvv:(MfsTextField*)cvv orderNo:(NSString*)orderNo installmentCount:(NSNumber*)installmentCount rewardName:(NSString*)rewardName rewardValue:(NSString*)rewardValue directPurchaseCallback:(SEL)callback directPurchaseTarget:(id)target;
    
-(id)directPurchase:(MfsCard*)card token:(NSString*)token amount:(NSString*)amount textField:(MfsTextField*)textField cvv:(MfsTextField*)cvv orderNo:(NSString*)orderNo directPurchaseCallback:(SEL)callback directPurchaseTarget:(id)target;

-(id)purchaseAndRegister:(MfsCard*)card token:(NSString*)token amount:(NSString*)amount textField:(MfsTextField*)textField  cvv:(MfsTextField*)cvv orderNo:(NSString*)orderNo installmentCount:(NSNumber*)installmentCount rewardName:(NSString*)rewardName rewardValue:(NSString*)rewardValue purchaseAndRegisterCallback:(SEL)callback purchaseAndRegisterTarget:(id)target;
    
-(id)purchaseAndRegister:(MfsCard*)card token:(NSString*)token amount:(NSString*)amount textField:(MfsTextField*)textField  cvv:(MfsTextField*)cvv orderNo:(NSString*)orderNo  purchaseAndRegisterCallback:(SEL)callback purchaseAndRegisterTarget:(id)target;

-(id)completeRegistration:(NSString*)token token2:(NSString*)token2 cardName:(NSString*)cardName completeRegistrationCallback:(SEL)callback completeRegistrationTarget:(id)target;

-(id)updateUser:(NSString*)token oldValue:(NSString*)oldValue newValue:(NSString*)newValue valueType:(NSString*)valueType updateUserCallback:(SEL)callback updateUserTarget:(id)target;

-(id)verifyPin:(NSString*)msisdn token:(NSString*)token verifyPinCallback:(SEL)callback verifyPinTarget:(id)target;

-(void)startScanning:(MfsTextField*)cardNo cardIOCallback:(SEL)callback cardIOHandler:(id)targetController;

-(id)initWithMsisdn:(NSString*)msisdn;


@property (readwrite, nonatomic) SEL registerSelector;
@property (readwrite, nonatomic, strong) id registerHandler;

@property (readwrite, nonatomic) SEL validateSelector;
@property (readwrite, nonatomic, strong) id validateHandler;

@property (readwrite, nonatomic) SEL getCardsCallback;
@property (readwrite, nonatomic, strong) id getCardsHandler;

@property (readwrite, nonatomic) SEL payCallback;
@property (readwrite, nonatomic, strong) id payHandler;

@property (readwrite, nonatomic) SEL forgotPasswordCallback;
@property (readwrite, nonatomic, strong) id forgotPasswordHandler;

@property (readwrite, nonatomic) SEL checkMasterPassEndUserCallback;
@property (readwrite, nonatomic, strong) id checkMasterPassEndUserHandler;

@property (readwrite, nonatomic) SEL addCardToMasterPassCallback;
@property (readwrite, nonatomic, strong) id addCardToMasterPassHandler;

@property (readwrite, nonatomic) SEL linkCardToClientCallback;
@property (readwrite, nonatomic, strong) id linkCardToClientHandler;

@property (readwrite, nonatomic) SEL resendOtpCallback;
@property (readwrite, nonatomic, strong) id resendOtpHandler;


@property (readwrite, nonatomic) SEL completeRegistrationCallback;
@property (readwrite, nonatomic, strong) id completeRegistrationHandler;


@property (readwrite, nonatomic) SEL directPurchaseCallback;
@property (readwrite, nonatomic, strong) id directPurchaseHandler;

@property (readwrite, nonatomic) SEL purchaseAndRegisterCallback;
@property (readwrite, nonatomic, strong) id purchaseAndRegisterHandler;

@property (readwrite, nonatomic) SEL changeMsisdnCallback;
@property (readwrite, nonatomic, strong) id changeMsisdnHandler;

@property (strong, nonatomic)  NSString* merchantId;
@property (strong, nonatomic)  NSString* language;

@property (strong, nonatomic)  NSString* clientId;

@property (strong, nonatomic)  NSString* msisdn;

@property (strong, nonatomic)  NSString* baseURL;

@property (strong, nonatomic)  NSMutableDictionary* additionalParameters;

@property (strong, nonatomic)  NSString* macroMerchantId;

@property (strong, nonatomic)  MfsTextField* cardNo;

@property (readwrite, nonatomic) SEL cardIOCallback;
@property (readwrite, nonatomic, strong) id cardIOHandler;

@end


