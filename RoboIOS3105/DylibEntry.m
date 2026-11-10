#import <UIKit/UIKit.h>

@interface RoboIOS3105Loader : NSObject
@end

@implementation RoboIOS3105Loader

+ (void)load {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showLoadedOverlay];
    });
}

+ (void)showLoadedOverlay {
    UIWindow *window = nil;

    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:[UIWindowScene class]]) {
            continue;
        }

        UIWindowScene *windowScene = (UIWindowScene *)scene;
        for (UIWindow *candidate in windowScene.windows) {
            if (candidate.isKeyWindow) {
                window = candidate;
                break;
            }
        }

        if (window != nil) {
            break;
        }
    }

    if (window == nil) {
        window = UIApplication.sharedApplication.windows.firstObject;
    }

    UIViewController *root = window.rootViewController;
    if (root == nil) {
        return;
    }

    UILabel *label = [[UILabel alloc] init];
    label.text = @"ROBO iOS 3105\nDYLIB LOADED";
    label.textColor = UIColor.whiteColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 2;
    label.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
    label.backgroundColor = [UIColor colorWithRed:0.10 green:0.10 blue:0.12 alpha:0.96];
    label.layer.cornerRadius = 14.0;
    label.layer.masksToBounds = YES;
    label.translatesAutoresizingMaskIntoConstraints = NO;

    [root.view addSubview:label];

    [NSLayoutConstraint activateConstraints:@[
        [label.centerXAnchor constraintEqualToAnchor:root.view.centerXAnchor],
        [label.topAnchor constraintEqualToAnchor:root.view.safeAreaLayoutGuide.topAnchor constant:16.0],
        [label.widthAnchor constraintEqualToConstant:210.0],
        [label.heightAnchor constraintEqualToConstant:58.0]
    ]];
}

@end
