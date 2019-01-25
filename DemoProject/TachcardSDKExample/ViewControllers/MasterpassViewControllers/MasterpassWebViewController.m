//
//  MasterpassWebViewController.m
//  TachcardSDKExample
//
//  Created by admin on 3/3/18.
//  Copyright © 2018 CWG. All rights reserved.
//

#import "MasterpassWebViewController.h"

@interface MasterpassWebViewController ()
@property (nonatomic, retain) IBOutlet MfsWebView *webView;
@end

@implementation MasterpassWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    switch (self.webType) {
        case Masterpass3dWebTypeCard:
            self.title = @"НОВАЯ КАРТА";
            break;
        case Masterpass3dWebTypePay:
            self.title = @"ОПЛАТА";
            break;
        default:
            self.title = @"";
            break;
    }

    [TCCAPI validateMpTransaction3D:self.webView response:self.responseObject[@"mp_response"] completion:^(id responseObject, NSString *errorStr) {
        if (errorStr) {
            NSLog(@"%@",errorStr);
        } else {
            switch (self.webType) {
                case Masterpass3dWebTypeCard: {
                    NSLog(@"succes");
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
                    break;
                case Masterpass3dWebTypePay: {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self succesActionAfter3ds];
                    });
                }
                    break;
                default:

                    break;
            }
        }
        NSLog(@"%@",responseObject);
        NSLog(@"%@",errorStr);
    }];
}

#pragma mark -
#pragma mark UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    CGSize contentSize = webView.scrollView.contentSize;
    CGSize viewSize = webView.bounds.size;

    float rw = viewSize.width / contentSize.width;

    NSString *zoomString = [NSString stringWithFormat:@"document. body.style.zoom = %f;",rw];
    [webView stringByEvaluatingJavaScriptFromString:zoomString];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithURL:request.URL resolvingAgainstBaseURL:NO];
    urlComponents.query = nil;
    
    return YES;
}

- (void)succesActionAfter3ds {
    switch (self.webType) {
        case Masterpass3dWebTypeCard:
            [self succesAnimation];
            break;
        case Masterpass3dWebTypePay:
            [self confirm3dsPay];
            break;
        default:
            [self succesAnimation];
            break;
    }
}

- (void)confirm3dsPay {
    [self.navigationController popViewControllerAnimated:YES];
    if ([self.delegate respondsToSelector:@selector(confirmPaymentWithParams:)]) {
        [self.delegate confirmPaymentWithParams:@{@"mp_token":self.responseObject[@"additional_params"][@"mp_token"],
                                                  @"payment_token":self.responseObject[@"payment_token"]
                                                  }];
    }
}

- (void)succesAnimation {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
