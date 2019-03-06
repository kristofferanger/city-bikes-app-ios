//
//  ErrorHelpers.m
//  CityBikesApp
//
//  Created by Kristoffer Anger on 2019-03-06.
//  Copyright © 2019 kriang. All rights reserved.
//

#import "ErrorHelpers.h"

static NSString *defaultErrorTitle = @"Error";
static NSString *defaultErrorMessage = @"An unknown error occurred.";
static NSString *defaultOkayButtonTitle = @"OK";

@implementation ErrorHelpers

+ (void)showError:(NSError *)error onView:(UIView *)view {
    [self showError:error withTitle:nil toView:view popViewControllerWhenFinished:NO];
}

+ (void)showError:(nonnull NSError *)error withTitle:(nullable NSString *)title toView:(nonnull UIView *)view popViewControllerWhenFinished:(BOOL)pop {
    
    // create error message
    NSString *errorMessage = [self errorMessageForError:error withDefaultMessage:defaultErrorMessage];
    
    // create error alert
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title ? : defaultErrorTitle message:errorMessage preferredStyle:UIAlertControllerStyleAlert];
    
    UIViewController *parentViewController = [self parentViewControllerForView:view];
    
    // add okay button and handle action
    [alert addAction:[UIAlertAction actionWithTitle:defaultOkayButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // dismiss alert view
        [parentViewController dismissViewControllerAnimated:YES completion:^{
            if (pop) {
                // pop view controller that presented the alert (if not root)
                [parentViewController.navigationController popViewControllerAnimated:YES];
            };
        }];
    }]];
    
    // present alert view
    [parentViewController presentViewController:alert animated:YES completion:nil];
}

+ (NSString *)errorMessageForError:(NSError *)error withDefaultMessage:(NSString *)defaultMessage {
    
    NSString *errorMessage = nil;
    
    switch (error.code) {
        case kCFURLErrorUnknown:
            errorMessage = @"An unknown error occurred.";
            break;
        case kCFURLErrorCancelled:
            errorMessage = @"The connection was cancelled.";
            break;
        case kCFURLErrorBadURL:
            errorMessage = @"The connection failed due to a malformed URL.";
            break;
        case kCFURLErrorTimedOut:
            errorMessage = @"The connection timed out.";
            break;
        case kCFURLErrorCannotFindHost:
            errorMessage = @"The connection failed because the host could not be found.";
            break;
        case kCFURLErrorNetworkConnectionLost:
            errorMessage = @"The connection failed because the network connection was lost.";
            break;
        case kCFURLErrorResourceUnavailable:
            errorMessage = @"The connection’s resource is unavailable.";
            break;
        case kCFURLErrorNotConnectedToInternet:
            errorMessage = @"The connection failed because the device is not connected to the internet.";
            break;
        case kCFURLErrorBadServerResponse:
            errorMessage = @"The connection received an invalid server response.";
            break;
        case kCFURLErrorUserAuthenticationRequired:
            errorMessage = @"The connection failed because authentication is required.";
            break;
        default:
            errorMessage = defaultMessage;
            break;
    }
    return errorMessage;
}


#pragma mark - Helper methods

+ (UIViewController *)parentViewControllerForView:(UIView *)view {
    UIResponder *responder = view;
    while ([responder isKindOfClass:[UIView class]])
        responder = [responder nextResponder];
    return (UIViewController *)responder;
}


@end
