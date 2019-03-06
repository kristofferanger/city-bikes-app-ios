//
//  ErrorHelpers.h
//  CityBikesApp
//
//  Created by Kristoffer Anger on 2019-03-06.
//  Copyright © 2019 kriang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ErrorHelpers : NSObject

// shows error on current view with default error title
+ (void)showError:(nonnull NSError *)error onView:(nonnull UIView *)view;

// shows error on current view with options
+ (void)showError:(nonnull NSError *)error withTitle:(nullable NSString *)title toView:(nonnull UIView *)view popViewControllerWhenFinished:(BOOL)pop;

// returns error an app-specific message for certain status code, or default message if not found
+ (NSString *)errorMessageForError:(NSError *)error withDefaultMessage:(NSString *)defaultMessage;

@end

NS_ASSUME_NONNULL_END
