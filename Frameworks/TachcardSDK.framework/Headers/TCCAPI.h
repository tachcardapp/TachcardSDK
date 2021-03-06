//
//  TCCAPI.h
//  TachcardSDK
//
//  Created by admin on 4/6/17.
//  Copyright © 2017 CWG. All rights reserved.
//

//  v 1

#import <Foundation/Foundation.h>
#import "MfsIOSLibrary.h"

typedef void(^TCCCompletionBlock)(id responseObject, NSString *errorStr);
typedef void(^MpRequestReturnResponse)(MfsResponse *responseObject);

@interface TCCAPI : NSObject

+ (void)setCustomToken: (NSString *)token secret: (NSString *)secret;

#pragma mark -
#pragma mark Settings

//requred  (BOOL) isTestServer

+ (void)setIsTestServer:(BOOL)isTestServer;

//requred  (NSString) publicKey

+ (void)setPublicKey: (NSString *)publicKey;

#pragma mark -
#pragma mark Authentication

//requred  (NSString) phone
//optional (NSString) pin

+ (void)authSystemUserWithPhone: (NSString *)phone pin:(NSString *)pin completion:(TCCCompletionBlock)completion;

//requred  (NSString) usertoken
//optional (NSString) pushToken

+ (void)authUserWithUserToken: (NSString *)usertoken pushToken:(NSString *)pushToken completion:(TCCCompletionBlock)completion;

//requred  (NSString) phone
//optional (NSString) pushToken

+ (void)authUserWithUserPhone: (NSString *)phone pushToken:(NSString *)pushToken completion:(TCCCompletionBlock)completion;

//requred  (NSString) pushToken

+ (void)renewPushTokenWithToken: (NSString *)pushToken completion:(TCCCompletionBlock)completion;

+ (void)checkPinWithPin: (NSString *)pin completion:(TCCCompletionBlock)completion;

+ (void)checkSmsWithSms: (NSString *)sms completion:(TCCCompletionBlock)completion;

+ (void)updateUserInfoWithEmail: (NSString *)email completion:(TCCCompletionBlock)completion;

#pragma mark -
#pragma mark Support

//requred  (NSString) feedbackText

+ (void)sendFeedbackWithText: (NSString *)feedbackText completion:(TCCCompletionBlock)completion;

#pragma mark -
#pragma mark History

//requred  (NSString) dateString (in format 1970-01-01 00:00:00)

+ (void)getTransactionsWithDate: (NSString *)dateString completion:(TCCCompletionBlock)completion;

//requred  (NSString) transactionId

+ (void)hideTransactionWithId: (NSNumber *)transactionId completion:(TCCCompletionBlock)completion;

#pragma mark -
#pragma mark Wallets

//

+ (void)getWallets: (TCCCompletionBlock)completion;

//requred  (NSString) walletToken

+ (void)deleteWalletWithToken: (NSString *)walletToken completion:(TCCCompletionBlock)completion;

//requred  (NSString) walletToken
//requred  (NSString) newWalletName

+ (void)renameWalletWithToken: (NSString *)walletToken newWalletName:(NSString *)newWalletName completion:(TCCCompletionBlock)completion;

//requred  (NSString) nameString

+ (void)addCreditCardWithName: (NSString *)nameString completion:(TCCCompletionBlock)completion;

//requred  (NSString) urlString

+ (void)dummyCreditCardRedirectWithURLString:(NSString *)urlString completion:(TCCCompletionBlock)completion;

//requred  (NSString) token

+ (void)addCreditCardConfirmWithToken: (NSString *)token completion:(TCCCompletionBlock)completion;

#pragma mark -
#pragma mark Transfer

//requred  (NSNumber) amount

+ (void)anyCardTransferCalcWithAmount: (NSNumber *)amount completion:(TCCCompletionBlock)completion;

//requred  (NSString) amount
//requred  (NSString) walletToken
//requred  (NSString) cardNumber

+ (void)anyCardTransferWithAmount: (NSString *)amount walletToken:(NSString *)walletToken cardNumber:(NSString *)cardNumber completion:(TCCCompletionBlock)completion;

//requred  (NSString) token

+ (void)anyCardTransferConfirmWithToken: (NSString *)token completion:(TCCCompletionBlock)completionl;

#pragma mark -
#pragma mark Invoice

//requred  (NSString) amount
//requred  (NSString) walletToken

+ (void)createInvoiceWithAmount: (NSString *)amount walletToken:(NSString *)walletToken completion:(TCCCompletionBlock)completion;

//requred  (NSString) invoiceToken

+ (void)cancelInvoiceWithToken: (NSString *)invoiceToken completion:(TCCCompletionBlock)completion;

//requred  (NSString) invoiceToken

+ (void)viewInvoiceWithToken: (NSString *)invoiceToken completion:(TCCCompletionBlock)completion;

//requred  (NSString) requestString

+ (void)viewStaticInvoiceWithRequest: (NSString *)requestString completion:(TCCCompletionBlock)completion;

//requred  (NSString) invoiceToken
//requred  (NSString) walletToken

+ (void)payInvoiceWithToken: (NSString *)invoiceToken walletToken:(NSString *)walletToken completion:(TCCCompletionBlock)completion;

//requred  (NSString) paymentToken

+ (void)payConfirmWithToken: (NSString *)paymentToken completion:(TCCCompletionBlock)completion;

//requred  (NSString) invoiceToken
//requred  (CGFloat) size

+ (UIImage*)getQrImageWithToken: (NSString *)invoiceToken size:(CGFloat)size;

//requred  (NSString) sessionToken
//requred  (NSString) walletToken

+ (void)startWaitPaymentWithSessionToken:(NSString *)sessionToken walletToken:(NSString *)walletToken completion:(TCCCompletionBlock)completion;

//

+ (void)stopWaitPayment;

#pragma mark -
#pragma mark Exchange

//requred  (NSString) toWalletToken
//requred  (NSString) fromWalletToken
//requred  (NSNumber) amount

+ (void)createExchangeInvoiceWithAmount:(NSNumber *)amount fromWalletToken:(NSString *)fromWalletToken toWalletToken:(NSString *)toWalletToken completion:(TCCCompletionBlock)completion;

//requred (NSString) exchangeToken

+ (void)confirmExchangeInvoiceWithToken: (NSString *)exchangeToken completion:(TCCCompletionBlock)completion;

#pragma mark -
#pragma mark Сhanges

//requred  (NSString) dateString (in format 1970-01-01 00:00:00)

+ (void)getChangesWithDate: (NSString *)dateString completion:(TCCCompletionBlock)completion;

#pragma mark -
#pragma mark Address

//requred (NSDictionary) params =
//{
//apartment = stringValue;
//city = stringValue;
//country = stringValue;
//email = stringValue;
//firstname = stringValue;
//house = stringValue;
//lastname = stringValue;
//name = stringValue;
//other = stringValue;
//phone = stringValue;
//street = stringValue;
//}

+ (void)addAddressWithParams:(NSDictionary *)params completion:(TCCCompletionBlock)completion;

//requred (NSDictionary) params =
//{
//apartment = stringValue;
//city = stringValue;
//country = stringValue;
//email = stringValue;
//firstname = stringValue;
//house = stringValue;
//lastname = stringValue;
//name = stringValue;
//other = stringValue;
//phone = stringValue;
//street = stringValue;
//}

//requred  (NSInteger) idAddress

+ (void)editAddressWithParams:(NSDictionary *)params idAddress:(NSInteger)idAddress completion:(TCCCompletionBlock)completion;

//requred  (NSInteger) idAddress

+ (void)deleteAddressWithIdAddress:(NSInteger)idAddress completion:(TCCCompletionBlock)completion;

#pragma mark -
#pragma mark Sessions

//

+ (void)getSessions:(TCCCompletionBlock)completion;

//requred  (NSString) sessionToken

+ (void)deleteSessionWithToken:(NSString *)sessionToken completion:(TCCCompletionBlock)completion;

#pragma mark -
#pragma mark Url Request

//requred  (NSString)     url
//optional (NSDictionary) params

+ (void)getRequestWithUrl: (NSString *)url params:(NSDictionary *)params completion:(TCCCompletionBlock)completion;

//requred  (NSString)     url
//optional (NSDictionary) params

+ (void)postRequestWithUrl: (NSString *)url params:(NSDictionary *)params completion:(TCCCompletionBlock)completion;

#pragma mark -
#pragma mark Url AuthorizationStatus

//

+ (BOOL)isAuthorized;

//

+ (void)logOut;

// v - 2

//requred  (NSString) paydesc
//requred  (NSString) amount
//requred  (NSString) accountId

+ (void)getServiceReceiptTokenWithPaydescUrl: (NSString *)paydesc amount:(NSString *)amount accountId:(NSString *)accountId completion:(TCCCompletionBlock)completion;

//requred  (NSString) cardNumber
//requred  (NSString) cvvString
//requred  (NSString) expMonth
//requred  (NSString) expYear
//requred  (NSString) receiptToken

+ (void)getFreeCardTokenWithCardNumber: (NSString *)cardNumber cvvString:(NSString *)cvvString expMonth:(NSString *)expMonth expYear:(NSString *)expYear receiptToken:(NSString *)receiptToken completion:(TCCCompletionBlock)completion;

//requred  (NSString) receiptToken
//requred  (NSString) paymentToken

// if ([responseObject[@"is_redirect"]boolValue] == TRUE) open POST in webView responseObject[@"url"] and int request setHTTPBody responseObject[@"fields"]
// after a successful input 3DS code webview redirect to the page with @"success3ds" string
// than make serviceConfirmPaymentWithPaymentToken
// else serviceConfirmPaymentWithPaymentToken

+ (void)freeCardPaymentPrepareWithReceiptToken: (NSString *)receiptToken paymentToken:(NSString *)paymentToken completion:(TCCCompletionBlock)completion;

// v - 3 masterpass

//requred  (NSString) userPhone (in format 380#########)

+ (void)initMpWithUserPhone: (NSString *)userPhone completion:(TCCCompletionBlock)completion;

+ (void)checkMpEndUser: (MpRequestReturnResponse)returnResponse;

//requred  (NSString) name
//requred  (NSString) month (in format ##)
//requred  (NSString) year (in format ##)
//requred  (MfsTextField) cardNumberField
//requred  (MfsTextField) cvvField
//optional (NSDictionary) param (default nil)

+ (void)addMpCardWithName: (NSString *)name month:(NSString *)month year:(NSString *)year cardNumberField:(MfsTextField *)cardNumberField cvvField:(MfsTextField *)cvvField param:(NSDictionary *)param completion:(TCCCompletionBlock)completion;

//requred  (NSString) token
//requred  (MfsTextField) textField

+ (void)validateMpTransaction:(NSString*)token textField:(MfsTextField*)textField completion:(TCCCompletionBlock)completion;

//requred  (MfsWebView) webView
//requred  (MfsResponse) response

+ (void)validateMpTransaction3D:(MfsWebView*)webView response:(MfsResponse*)response completion:(TCCCompletionBlock)completion;

//requred  (NSString) cardName

+ (void)deleteMpCardWithName: (NSString *)cardName completion:(TCCCompletionBlock)completion;

//requred  (NSString) cardName
//requred  (NSString) amount
//requred  (NSString) paymentToken
//requred  (NSDictionary) paramsDict

+ (void)payMpWithCardName: (NSString *)cardName amount:(NSString *)amount paymentToken:(NSString *)paymentToken paramsDict:(NSDictionary *)paramsDict qrData:(NSString *)qrData completion:(TCCCompletionBlock)completion;

//requred  (NSString) token

+ (void)resendMpOtp:(NSString*)token completion:(TCCCompletionBlock)completion;

+ (void)linkMpAccount: (TCCCompletionBlock)completion;

+ (void)getMpWallets: (TCCCompletionBlock)completion;

//requred  (NSDictionary) additionalParams

+ (void)payConfirmWithAdditionalParams:(NSDictionary *)additionalParams completion:(TCCCompletionBlock)completion;

//requred  (NSString) invoiceToken

+ (void)payInvoiceMpWithToken: (NSString *)invoiceToken completion:(TCCCompletionBlock)completion;

// v - 3 phoenix

//requred  (NSString) urlString

+ (void)getPhoenixOptionWithUrlString: (NSString *)urlString completion:(TCCCompletionBlock)completion;

// v - 4 masterpass QR

+ (void)getMasterpassQrAccountWithCompletion:(TCCCompletionBlock)completion;

// v - 5

//requred  (NSString) phoneString

+ (void)getPayPointByPhone: (NSString *)phoneString completion:(TCCCompletionBlock)completion;

// v - 6 p2p

+ (void)getP2pAccountWithCompletion:(TCCCompletionBlock)completion;

//requred  (NSString) fromWalletToken
//requred  (NSString) fromCardNumber
//requred  (NSString) toCardNumber
//requred  (NSString) cvvString
//requred  (NSString) expMonth
//requred  (NSString) expYear
//requred  (NSString) amount

+ (void)initP2pWithWalletToken: (NSString *)fromWalletToken fromCardNumber: (NSString *)fromCardNumber toCardNumber: (NSString *)toCardNumber cvvString:(NSString *)cvvString expMonth:(NSString *)expMonth expYear:(NSString *)expYear amount:(NSString *)amount completion:(TCCCompletionBlock)completion;

//requred  (NSString) paymentToken

+ (void)prepareP2pWithPaymentToken:(NSString *)paymentToken completion:(TCCCompletionBlock)completion;

//requred  (NSString) paymentToken

+ (void)checkP2pTransactionWithPaymentToken:(NSString *)paymentToken completion:(TCCCompletionBlock)completion;

//requred  (NSString) paymentToken
//requred  (NSString) lookuCode

+ (void)checkP2pLookupWithPaymentToken:(NSString *)paymentToken lookuCode:(NSString *)lookuCode completion:(TCCCompletionBlock)completion;

//requred  (NSString) paymentToken

+ (void)updateP2pInfoWithPaymentToken:(NSString *)paymentToken completion:(TCCCompletionBlock)completion;


// v - 7

+ (void)getSecretQuestionsWithCompletion:(TCCCompletionBlock)completion;

+ (void)checkSecretQuestionWithAnswer: (NSString *)answer completion:(TCCCompletionBlock)completion;

+ (void)editSecretQuestionWithAnswer: (NSString *)answer questionId:(NSString *)questionId completion:(TCCCompletionBlock)completion;

+ (void)createSecretQuestionWithAnswer: (NSString *)answer question:(NSString *)question completion:(TCCCompletionBlock)completion;

+ (void)checkRestoreSecretQuestionWithAnswer: (NSString *)answer completion:(TCCCompletionBlock)completion;

+ (void)savePinWithPin: (NSString *)pin oldPin:(NSString *)oldPin completion:(TCCCompletionBlock)completion;



// v - 10

+ (void)tokenizeCardWithPan: (NSString *)pan mm:(NSString *)mm yy:(NSString *)yy cvv:(NSString *)cvv name:(NSString *)name completion:(TCCCompletionBlock)completion;

+ (void)tokenizeBindWithToken: (NSString *)token completion:(TCCCompletionBlock)completion;

+ (void)payInitWithPaymentToken: (NSString *)token cvv:(NSString *)cvv additionalParams:(NSDictionary *)additionalParams completion:(TCCCompletionBlock)completion;

+ (void)getPhoenixCategoriesInfoWithServiceId: (int)serviceId completion:(TCCCompletionBlock)completion;

+ (void)checkEmail: (NSString *)email completion:(TCCCompletionBlock)completion;

+ (void)updateUserInfoWithEmail: (NSString *)email oldEmail: (NSString *)oldEmail completion:(TCCCompletionBlock)completion;


+ (void)restorePinWithCompletion:(TCCCompletionBlock)completion;

+ (void)restoreConfirmWithConfirmCode: (NSString *)confirmCode completion:(TCCCompletionBlock)completion;

+ (void)restoreCompleteWithRestoreToken: (NSString *)restoreToken key: (NSString *)key completion:(TCCCompletionBlock)completion;

+ (void)getP2pAppTokenAccountWithType: (NSString *)type pan:(NSString *)pan completion:(TCCCompletionBlock)completion;


+ (void)sendError: (NSString *)error phone:(NSString *)phone device:(NSString *)device completion:(TCCCompletionBlock)completion;

@end
























