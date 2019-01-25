//
//  TPHTTPRoutes.h
//  TachPay
//
//  Created by Yaroslav Bulda on 3/28/15.
//  Copyright (c) 2015 tachcard. All rights reserved.
//

#define addRoute(name, path) static NSString *const name = path

addRoute(TCCHTTPRequestSystemRegister, @"/system-register");

addRoute(TCCHTTPRequestRegisterRoute, @"/register");
addRoute(TCCHTTPRequestRegisterConfirmRoute, @"/register/confirm");
addRoute(TCCHTTPRequestRenewPushTokenRoute, @"/register/renewpushtoken");
addRoute(TCCHTTPRequestUserInfoRoute, @"/register/userinfo");

addRoute(TCCHTTPRequestCheckeMailRoute, @"/register/checkemail");

addRoute(TCCHTTPRequestFeedbackRoute, @"/addopinion");

addRoute(TCCHTTPRequestTransactionsRoute, @"/transactions");
addRoute(TCCHTTPRequestTransactionsCancelRoute, @"transactions/cancel");
addRoute(TCCHTTPRequestTransactionsSwitchRoute, @"transactions/switch");

addRoute(TCCHTTPRequestWalletRoute, @"/account");
addRoute(TCCHTTPRequestWalletsListRoute, @"/accounts");

addRoute(TCCHTTPRequestCreateInvoiceRoute, @"/receipt/create");
addRoute(TCCHTTPRequestCancelInvoiceRoute, @"receipt/cancel");
addRoute(TCCHTTPRequestSendInvoiceRoute, @"/receipt/send");
addRoute(TCCHTTPRequestSendConfirmInvoiceRoute, @"receipt/send/confirm");
addRoute(TCCHTTPRequestViewInvoiceRoute, @"/receipt/view");

addRoute(TCCHTTPRequestPayInvoiceRoute, @"/pay");
addRoute(TCCHTTPRequestPayConfirmRoute, @"/pay/confirm");
addRoute(TCCHTTPRequestPayLongpullRoute, @"/lp");

//Card
addRoute(TCCHTTPRequestAddCreditCardRoute, @"/taslink/bind");
addRoute(TCCHTTPRequestAddCreditCardConfirmRoute, @"/taslink/view");

//Webmoney
addRoute(TCCHTTPRequestWMAddUWallletRoute, @"/webmoney/bind");
addRoute(TCCHTTPRequestWMConfirmWallletRoute, @"webmoney/bind/confirm");

//Transfer
addRoute(TCCHTTPRequestTransferRatesRoute, @"/transfer");
addRoute(TCCHTTPRequestTransferCalcRoute, @"/transfer/calc");
addRoute(TCCHTTPRequestTransferConfirmRoute, @"/transfer/confirm");

//Exchange
addRoute(TCCHTTPRequestExchangeRoute, @"/exchange");
addRoute(TCCHTTPRequestExchangeConfirm, @"/exchange/confirm");

//Security Pin
addRoute(TCCHTTPRequestSavePinRoute, @"/auth/savepin");
addRoute(TCCHTTPRequestCheckPinRoute, @"/auth/checkpin");

//Сhanges
addRoute(TCCHTTPRequestChangesRoute, @"/changes");

//Restore
addRoute(TCCHTTPRequestRestoreRoute, @"/auth/restore");
addRoute(TCCHTTPRequestRestoreConfirmRoute, @"/auth/restore/confirm");
addRoute(TCCHTTPRequestRestoreCompleteRoute, @"/auth/restore/complete");

//Address

addRoute(TCCHTTPRequestAddressRoute, @"/address");

//Сontacts
addRoute(TCCHTTPRequestContactsRoute, @"/contacts");

addRoute(TCCHTTPRequestC2ctransferCalcRoute, @"/c2ctransfer/calc");
addRoute(TCCHTTPRequestC2ctransferRoute, @"c2ctransfer");
addRoute(TCCHTTPRequestC2ctransferConfirmRoute, @"/c2ctransfer/confirm");

addRoute(TCCHTTPRequestC2cReceiversConfirmRoute, @"/c2c/receivers");

addRoute(TCCHTTPRequestAuthsRoute, @"auths");
addRoute(TCCHTTPRequestAuthRoute, @"auth");

addRoute(TCCHTTPRequestMasterPassToken, @"/masterpass/token");

// v - 2

addRoute(TCCHTTPRequestFCardInit, @"/f-card/init");
addRoute(TCCHTTPRequestFCardAccount, @"/f-card/account");
addRoute(TCCHTTPRequestFCardPrepare, @"/f-card/prepare");

// v - 3

addRoute(TCCHTTPRequestMasterpassToken, @"/masterpass/token");
addRoute(TCCHTTPRequestMasterpassConfig, @"/masterpass/config");
addRoute(TCCHTTPRequestMasterpassMakeAccount, @"/masterpass/make/account");
addRoute(TCCHTTPRequestMasterpassInit, @"/masterpass/init");
addRoute(TCCHTTPRequestMasterpassCommit, @"/masterpass/commit");

addRoute(TCCHTTPRequestPhoenixCategoriesInfo, @"/phoenix/categories/info");
addRoute(TCCHTTPRequestPhoenixCategories, @"/phoenix/categories");
addRoute(TCCHTTPRequestPhoenixOptions, @"/phoenix/options");

// v - 4

addRoute(TCCHTTPRequestMasterpassGetQrAccount, @"/masterpass/get-qr-account");

addRoute(TCCHTTPRequestMasterpassTlvToken, @"/masterpass/tlv-token");

// v - 6

addRoute(TCCHTTPRequestP2pAccount, @"/p2p-app/account");
addRoute(TCCHTTPRequestP2pInit, @"/p2p-app/init");
addRoute(TCCHTTPRequestP2pPrepare, @"/p2p-app/prepare");
addRoute(TCCHTTPRequestP2pCheckTransaction, @"/p2p-app/check-transaction");
addRoute(TCCHTTPRequestP2pCheckLookup, @"/p2p-app/check-lookup");
addRoute(TCCHTTPRequestP2pUpdateInfo, @"/p2p-app/update-info");


addRoute(TCCHTTPRequestRegisterGetQuestion, @"/register/questions");
addRoute(TCCHTTPRequestRegisterCheckQuestion, @"/register/check-question");
addRoute(TCCHTTPRequestRegisterEditQuestion, @"/register/edit-question");
addRoute(TCCHTTPRequestRegisterCreateQuestion, @"/register/create-question");
addRoute(TCCHTTPRequestAuthRestoreCheckAnswer, @"/auth/restore/check-answer");

// v - 10

addRoute(TCCHTTPRequestTokenize, @"/tokenize");
addRoute(TCCHTTPRequestTokenizeBindToAccount, @"/tokenize/bind-to-account");

addRoute(TCCHTTPRequestPayInit, @"/pay/init");
addRoute(TCCHTTPRequestP2pAppGetTokenAccount, @"/p2p-app/get-token-account");


// v - 11

addRoute(TCCHTTPRequestAppError, @"/app/error");



