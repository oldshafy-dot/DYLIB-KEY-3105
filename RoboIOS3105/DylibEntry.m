#import <UIKit/UIKit.h>

@interface RoboIOS3105LicenseViewController : UIViewController <UITextFieldDelegate>
@property(nonatomic,strong) UITextField *keyField;
@property(nonatomic,strong) UIButton *verifyButton;
@property(nonatomic,strong) UIActivityIndicatorView *spinner;
@property(nonatomic,strong) UILabel *messageLabel;
@end

@implementation RoboIOS3105LicenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = UIColor.blackColor;

    UILabel *title = [[UILabel alloc] init];
    title.translatesAutoresizingMaskIntoConstraints = NO;
    title.textAlignment = NSTextAlignmentCenter;
    title.attributedText = [[NSAttributedString alloc] initWithString:@"ROBO iOS"
        attributes:@{
            NSFontAttributeName: [UIFont systemFontOfSize:42 weight:UIFontWeightBlack],
            NSForegroundColorAttributeName: UIColor.whiteColor
        }];

    UILabel *subtitle = [[UILabel alloc] init];
    subtitle.translatesAutoresizingMaskIntoConstraints = NO;
    subtitle.text = @"3105";
    subtitle.textAlignment = NSTextAlignmentCenter;
    subtitle.textColor = [UIColor whiteColor colorWithAlphaComponent:0.65];
    subtitle.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];

    UILabel *notice = [[UILabel alloc] init];
    notice.translatesAutoresizingMaskIntoConstraints = NO;
    notice.text = @"This 3105 is cracked by Shafay, owner of Robo Mods";
    notice.textAlignment = NSTextAlignmentCenter;
    notice.numberOfLines = 0;
    notice.textColor = [UIColor whiteColor colorWithAlphaComponent:0.72];
    notice.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];

    self.keyField = [[UITextField alloc] init];
    self.keyField.translatesAutoresizingMaskIntoConstraints = NO;
    self.keyField.placeholder = @"Enter a license key";
    self.keyField.textColor = UIColor.whiteColor;
    self.keyField.tintColor = UIColor.redColor;
    self.keyField.backgroundColor = [UIColor whiteColor colorWithAlphaComponent:0.07];
    self.keyField.layer.cornerRadius = 14;
    self.keyField.layer.borderWidth = 1;
    self.keyField.layer.borderColor = [UIColor whiteColor colorWithAlphaComponent:0.12].CGColor;
    self.keyField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0,0,16,1)];
    self.keyField.leftViewMode = UITextFieldViewModeAlways;
    self.keyField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0,0,16,1)];
    self.keyField.rightViewMode = UITextFieldViewModeAlways;
    self.keyField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.keyField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.keyField.delegate = self;

    self.verifyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.verifyButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.verifyButton setTitle:@"VERIFY" forState:UIControlStateNormal];
    [self.verifyButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.verifyButton.titleLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightBold];
    self.verifyButton.backgroundColor = UIColor.redColor;
    self.verifyButton.layer.cornerRadius = 14;
    [self.verifyButton addTarget:self action:@selector(verifyPressed) forControlEvents:UIControlEventTouchUpInside];

    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    self.spinner.translatesAutoresizingMaskIntoConstraints = NO;
    self.spinner.hidden = YES;
    self.spinner.color = UIColor.whiteColor;

    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.textColor = [UIColor redColor colorWithAlphaComponent:0.95];
    self.messageLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];

    UIButton *telegram = [UIButton buttonWithType:UIButtonTypeSystem];
    telegram.translatesAutoresizingMaskIntoConstraints = NO;
    [telegram setTitle:@"Join Robo Official" forState:UIControlStateNormal];
    [telegram setTitleColor:[UIColor whiteColor colorWithAlphaComponent:0.7] forState:UIControlStateNormal];
    telegram.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightSemibold];
    [telegram addTarget:self action:@selector(openTelegram) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:title];
    [self.view addSubview:subtitle];
    [self.view addSubview:notice];
    [self.view addSubview:self.keyField];
    [self.view addSubview:self.verifyButton];
    [self.view addSubview:self.spinner];
    [self.view addSubview:self.messageLabel];
    [self.view addSubview:telegram];

    UILayoutGuide *safe = self.view.safeAreaLayoutGuide;
    [NSLayoutConstraint activateConstraints:@[
        [title.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [title.topAnchor constraintEqualToAnchor:safe.topAnchor constant:70],

        [subtitle.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [subtitle.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:4],

        [notice.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:28],
        [notice.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-28],
        [notice.topAnchor constraintEqualToAnchor:subtitle.bottomAnchor constant:18],

        [self.keyField.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:24],
        [self.keyField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-24],
        [self.keyField.topAnchor constraintEqualToAnchor:notice.bottomAnchor constant:28],
        [self.keyField.heightAnchor constraintEqualToConstant:52],

        [self.verifyButton.leadingAnchor constraintEqualToAnchor:self.keyField.leadingAnchor],
        [self.verifyButton.trailingAnchor constraintEqualToAnchor:self.keyField.trailingAnchor],
        [self.verifyButton.topAnchor constraintEqualToAnchor:self.keyField.bottomAnchor constant:12],
        [self.verifyButton.heightAnchor constraintEqualToConstant:52],

        [self.spinner.centerXAnchor constraintEqualToAnchor:self.verifyButton.centerXAnchor],
        [self.spinner.centerYAnchor constraintEqualToAnchor:self.verifyButton.centerYAnchor],

        [self.messageLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:30],
        [self.messageLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-30],
        [self.messageLabel.topAnchor constraintEqualToAnchor:self.verifyButton.bottomAnchor constant:14],

        [telegram.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [telegram.bottomAnchor constraintEqualToAnchor:safe.bottomAnchor constant:-20]
    ]];
}

- (void)verifyPressed {
    NSString *key = [self.keyField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (key.length == 0) {
        self.messageLabel.text = @"Please enter a license key.";
        return;
    }

    self.verifyButton.enabled = NO;
    self.spinner.hidden = NO;
    [self.spinner startAnimating];
    self.messageLabel.text = @"";

    NSString *deviceID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    NSURL *url = [NSURL URLWithString:@"https://shafaykeyauthadmin.lovable.app/api/public/v1/verify-license"];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    NSDictionary *body = @{
        @"key": key,
        @"device_id": deviceID ?: @"",
        @"product_identifier": @"3105"
    };
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:body options:0 error:nil];

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.verifyButton.enabled = YES;
            [self.spinner stopAnimating];
            self.spinner.hidden = YES;

            if (error) {
                self.messageLabel.text = @"Unable to connect to the license server.";
                return;
            }

            NSDictionary *json = data ? [NSJSONSerialization JSONObjectWithData:data options:0 error:nil] : nil;
            BOOL success = [json[@"success"] boolValue] || [json[@"valid"] boolValue];

            NSDictionary *nested = [json[@"data"] isKindOfClass:[NSDictionary class]] ? json[@"data"] : nil;
            success = success || [nested[@"success"] boolValue] || [nested[@"valid"] boolValue];

            NSString *message = json[@"message"] ?: json[@"error"] ?: json[@"detail"];

            if (success) {
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"RoboIOS3105LicenseVerified"];
                [[NSUserDefaults standardUserDefaults] synchronize];

                self.messageLabel.textColor = [UIColor greenColor colorWithAlphaComponent:0.9];
                self.messageLabel.text = @"License verified.";
                self.verifyButton.hidden = YES;
                self.keyField.hidden = YES;
            } else {
                self.messageLabel.textColor = [UIColor redColor colorWithAlphaComponent:0.95];
                self.messageLabel.text = message.length ? message : @"License is invalid or not authorized for this device.";
            }
        });
    }];
    [task resume];
}

- (void)openTelegram {
    NSURL *url = [NSURL URLWithString:@"https://t.me/roboios"];
    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
}

@end

@interface RoboIOS3105Loader : NSObject
@end

@implementation RoboIOS3105Loader

+ (void)load {
    [self waitForHostWindow:0];
}

+ (void)waitForHostWindow:(NSInteger)attempt {
    if (attempt > 100) return;

    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = nil;

        for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
            if (![scene isKindOfClass:[UIWindowScene class]]) continue;

            UIWindowScene *sceneWindow = (UIWindowScene *)scene;
            for (UIWindow *candidate in sceneWindow.windows) {
                if (candidate.isKeyWindow) {
                    window = candidate;
                    break;
                }
            }
            if (window) break;
        }

        if (!window) {
            for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
                if ([scene isKindOfClass:[UIWindowScene class]]) {
                    UIWindowScene *sceneWindow = (UIWindowScene *)scene;
                    if (sceneWindow.windows.count > 0) {
                        window = sceneWindow.windows.firstObject;
                        break;
                    }
                }
            }
        }

        if (!window || !window.rootViewController) {
            [self waitForHostWindow:attempt + 1];
            return;
        }

        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"RoboIOS3105LicenseVerified"]) {
            return;
        }

        RoboIOS3105LicenseViewController *licenseVC = [RoboIOS3105LicenseViewController new];
        licenseVC.modalPresentationStyle = UIModalPresentationFullScreen;

        UIViewController *presenter = window.rootViewController;
        while (presenter.presentedViewController) {
            presenter = presenter.presentedViewController;
        }

        [presenter presentViewController:licenseVC animated:NO completion:nil];
    });
}

@end
