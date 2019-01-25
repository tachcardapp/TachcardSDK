//
//  AddCardViewController.m
//  TachcardSDKExample
//
//  Created by admin on 4/25/17.
//  Copyright © 2017 CWG. All rights reserved.
//

#import "AddCardViewController.h"

@interface AddCardViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic, copy) NSString *redirectURL;
@property (nonatomic, copy) NSString *orderToken;

@end

@implementation AddCardViewController

#pragma mark -
#pragma mark Lifecycle methods

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)addCreditCard:(id)sender {
    @weakify(self);
    [TCCAPI addCreditCardWithName:self.nameTextField.text completion:^(id responseObject, NSString *errorStr) {
        @strongify(self);
        if (errorStr) {
            // ERROR
            return;
        }
        self.orderToken = responseObject[@"oid"];
        self.redirectURL = responseObject[@"backUrl"];

        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:responseObject[@"formUrl"]]];
        [self.webView loadRequest:request];

        [self.webView setHidden:NO];

        [self.nameTextField resignFirstResponder];
    }];
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [UIView animateWithDuration:0.25f animations:^{
        webView.alpha = 1.f;
    }];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([error code] == 102) {
        return;
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithURL:request.URL resolvingAgainstBaseURL:NO];
    urlComponents.query = nil;


    NSString* baseURLString = [NSString stringWithFormat:@"%@://%@%@",
                               urlComponents.scheme,
                               urlComponents.host,
                               urlComponents.path];

    if ([baseURLString isEqualToString:self.redirectURL]) {
        @weakify(self);
        [TCCAPI dummyCreditCardRedirectWithURLString:request.URL.absoluteString completion:^(id responseObject, NSString *errorStr) {
            @strongify(self);
            if (errorStr) {
                // ERROR
                return;
            }
            [self confirmAdding];
        }];
        
        return NO;
    }

    return YES;
}

- (void)confirmAdding {
    @weakify(self);
    [TCCAPI addCreditCardConfirmWithToken:self.orderToken completion:^(id responseObject, NSString *errorStr) {
        @strongify(self);
        if (errorStr) {
            // ERROR
            return;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

@end
