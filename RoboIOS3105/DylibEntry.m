#import <UIKit/UIKit.h>
#import <Security/Security.h>
#import <QuartzCore/QuartzCore.h>

static NSString * const kLicenseService = @"ROBO-iOS-3105";
static NSString * const kLicenseAccount = @"com.robomods.roboios3105.license";
static NSString * const kInstallationAccount = @"com.robomods.roboios3105.installation-id";
static NSString * const kProductIdentifier = @"vvvvvvvvvv";
static NSString * const kVerifyURL = @"https://shafaykeyauthadmin.lovable.app/api/public/v1/verify-license";

static UIColor *ROBOOrange(void) {
    return [UIColor colorWithRed:1.0 green:0.36 blue:0.0 alpha:1.0]; // Sunset Orange
}

static NSString *ROBOKeychainRead(NSString *account) {
    NSDictionary *query = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService: kLicenseService,
        (__bridge id)kSecAttrAccount: account,
        (__bridge id)kSecReturnData: @YES,
        (__bridge id)kSecMatchLimit: (__bridge id)kSecMatchLimitOne
    };

    CFTypeRef result = NULL;
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)query, &result);
    if (status != errSecSuccess || !result) {
        return nil;
    }

    NSData *data = CFBridgingRelease(result);
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

static BOOL ROBOKeychainWrite(NSString *value, NSString *account) {
    NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
    if (!data) return NO;

    NSDictionary *query = @{
        (__bridge id)kSecClass: (__bridge id)kSecClassGenericPassword,
        (__bridge id)kSecAttrService: kLicenseService,
        (__bridge id)kSecAttrAccount: account
    };

    NSDictionary *attributes = @{
        (__bridge id)kSecValueData: data,
        (__bridge id)kSecAttrAccessible: (__bridge id)kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
    };

    OSStatus update = SecItemUpdate((__bridge CFDictionaryRef)query, (__bridge CFDictionaryRef)attributes);
    if (update == errSecSuccess) return YES;
    if (update != errSecItemNotFound) return NO;

    NSMutableDictionary *add = [query mutableCopy];
    [add addEntriesFromDictionary:attributes];
    return SecItemAdd((__bridge CFDictionaryRef)add, NULL) == errSecSuccess;
}

static NSString *ROBOInstallationID(void) {
    NSString *existing = ROBOKeychainRead(kInstallationAccount);
    if (existing.length > 0) return existing;

    NSString *newID = [NSUUID UUID].UUIDString;
    if (ROBOKeychainWrite(newID, kInstallationAccount)) {
        return newID;
    }

    // Last-resort stable identifier for the current installation session.
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString] ?: @"";
}

static void ROBOAddFallingStars(UIView *view) {
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    emitter.name = @"ROBOFallingStars";
    emitter.emitterShape = kCAEmitterLayerLine;
    emitter.emitterMode = kCAEmitterLayerSurface;
    emitter.emitterSize = CGSizeMake(view.bounds.size.width, 1.0);
    emitter.emitterPosition = CGPointMake(view.bounds.size.width / 2.0, -2.0);

    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    cell.birthRate = 8.0;
    cell.lifetime = 7.0;
    cell.velocity = 32.0;
    cell.velocityRange = 18.0;
    cell.emissionLongitude = (CGFloat)M_PI_2;
    cell.emissionRange = 0.16;
    cell.scale = 0.035;
    cell.scaleRange = 0.018;
    cell.alphaSpeed = -0.08;
    cell.contents = (__bridge id)[UIImage systemImageNamed:@"circle.fill"].CGImage;
    cell.color = (view.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark)
        ? UIColor.whiteColor.CGColor
        : UIColor.blackColor.CGColor;

    emitter.emitterCells = @[cell];
    [view.layer addSublayer:emitter];
}

@interface RoboIOS3105LicenseViewController : UIViewController <UITextFieldDelegate>
@property(nonatomic,strong) UITextField *keyField;
@property(nonatomic,strong) UIButton *verifyButton;
@property(nonatomic,strong) UIButton *channelButton;
@property(nonatomic,strong) UIActivityIndicatorView *spinner;
@property(nonatomic,strong) UILabel *messageLabel;
@property(nonatomic,strong) UILabel *statusLabel;
@property(nonatomic,assign) BOOL verifying;
@end

@implementation RoboIOS3105LicenseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor systemBackgroundColor];

    UILabel *title = [[UILabel alloc] init];
    title.translatesAutoresizingMaskIntoConstraints = NO;
    title.text = @"iOS ESIGNE";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = ROBOOrange();
    title.font = [UIFont systemFontOfSize:46 weight:UIFontWeightHeavy];

    UILabel *version = [[UILabel alloc] init];
    version.translatesAutoresizingMaskIntoConstraints = NO;
    version.text = @"3105";
    version.textAlignment = NSTextAlignmentCenter;
    version.textColor = ROBOOrange();
    version.font = [UIFont systemFontOfSize:19 weight:UIFontWeightBold];

    UILabel *notice = [[UILabel alloc] init];
    notice.translatesAutoresizingMaskIntoConstraints = NO;
    notice.text = @"This 3105 is made by Shafay, iOS ESIGNE";
    notice.textAlignment = NSTextAlignmentCenter;
    notice.numberOfLines = 0;
    notice.textColor = ROBOOrange();
    notice.font = [UIFont systemFontOfSize:15 weight:UIFontWeightSemibold];

    self.keyField = [[UITextField alloc] init];
    self.keyField.translatesAutoresizingMaskIntoConstraints = NO;
    self.keyField.placeholder = @"VIP-XXXX-XXXX-XXXX-XXXX";
    self.keyField.textColor = ROBOOrange();
    self.keyField.tintColor = ROBOOrange();
    self.keyField.backgroundColor = [UIColor secondarySystemBackgroundColor];
    self.keyField.layer.cornerRadius = 14.0;
    self.keyField.layer.borderWidth = 1.0;
    self.keyField.layer.borderColor = [ROBOOrange() colorWithAlphaComponent:0.35].CGColor;
    self.keyField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0,0,16,1)];
    self.keyField.leftViewMode = UITextFieldViewModeAlways;
    self.keyField.rightView = [[UIView alloc] initWithFrame:CGRectMake(0,0,16,1)];
    self.keyField.rightViewMode = UITextFieldViewModeAlways;
    self.keyField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
    self.keyField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.keyField.spellCheckingType = UITextSpellCheckingTypeNo;
    self.keyField.delegate = self;
    self.keyField.returnKeyType = UIReturnKeyDone;

    NSDictionary *placeholderAttributes = @{
        NSForegroundColorAttributeName: [ROBOOrange() colorWithAlphaComponent:0.55]
    };
    self.keyField.attributedPlaceholder =
        [[NSAttributedString alloc] initWithString:@"VIP-XXXX-XXXX-XXXX-XXXX"
                                         attributes:placeholderAttributes];

    self.verifyButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.verifyButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.verifyButton setTitle:@"ACTIVATE" forState:UIControlStateNormal];
    [self.verifyButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    self.verifyButton.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    self.verifyButton.backgroundColor = ROBOOrange();
    self.verifyButton.layer.cornerRadius = 14.0;
    [self.verifyButton addTarget:self action:@selector(verifyPressed) forControlEvents:UIControlEventTouchUpInside];

    self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    self.spinner.translatesAutoresizingMaskIntoConstraints = NO;
    self.spinner.hidden = YES;
    self.spinner.color = UIColor.whiteColor;

    self.messageLabel = [[UILabel alloc] init];
    self.messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.numberOfLines = 0;
    self.messageLabel.textColor = ROBOOrange();
    self.messageLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];

    self.statusLabel = [[UILabel alloc] init];
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.textColor = ROBOOrange();
    self.statusLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];

    self.channelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.channelButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.channelButton setTitle:@"Official Channel" forState:UIControlStateNormal];
    [self.channelButton setTitleColor:ROBOOrange() forState:UIControlStateNormal];
    self.channelButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold];
    self.channelButton.layer.cornerRadius = 12.0;
    self.channelButton.backgroundColor = [ROBOOrange() colorWithAlphaComponent:0.10];
    [self.channelButton addTarget:self action:@selector(openTelegram) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:title];
    [self.view addSubview:version];
    [self.view addSubview:notice];
    [self.view addSubview:self.keyField];
    [self.view addSubview:self.verifyButton];
    [self.view addSubview:self.spinner];
    [self.view addSubview:self.messageLabel];
    [self.view addSubview:self.statusLabel];
    UILabel *compatibility = [[UILabel alloc] init];
    compatibility.translatesAutoresizingMaskIntoConstraints = NO;
    compatibility.text = @"Works on all iOS — even iOS 27.2";
    compatibility.textAlignment = NSTextAlignmentCenter;
    compatibility.numberOfLines = 0;
    compatibility.textColor = ROBOOrange();
    compatibility.font = [UIFont systemFontOfSize:13 weight:UIFontWeightMedium];
    [self.view addSubview:self.channelButton];
    [self.view addSubview:compatibility];

    UILayoutGuide *safe = self.view.safeAreaLayoutGuide;

    [NSLayoutConstraint activateConstraints:@[
        [title.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [title.topAnchor constraintEqualToAnchor:safe.topAnchor constant:58],

        [version.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
        [version.topAnchor constraintEqualToAnchor:title.bottomAnchor constant:4],

        [notice.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:28],
        [notice.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-28],
        [notice.topAnchor constraintEqualToAnchor:version.bottomAnchor constant:18],

        [self.keyField.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:24],
        [self.keyField.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-24],
        [self.keyField.topAnchor constraintEqualToAnchor:notice.bottomAnchor constant:28],
        [self.keyField.heightAnchor constraintEqualToConstant:54],

        [self.verifyButton.leadingAnchor constraintEqualToAnchor:self.keyField.leadingAnchor],
        [self.verifyButton.trailingAnchor constraintEqualToAnchor:self.keyField.trailingAnchor],
        [self.verifyButton.topAnchor constraintEqualToAnchor:self.keyField.bottomAnchor constant:12],
        [self.verifyButton.heightAnchor constraintEqualToConstant:54],

        [self.spinner.centerXAnchor constraintEqualToAnchor:self.verifyButton.centerXAnchor],
        [self.spinner.centerYAnchor constraintEqualToAnchor:self.verifyButton.centerYAnchor],

        [self.messageLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:30],
        [self.messageLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-30],
        [self.messageLabel.topAnchor constraintEqualToAnchor:self.verifyButton.bottomAnchor constant:13],

        [self.statusLabel.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:30],
        [self.statusLabel.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-30],
        [self.statusLabel.topAnchor constraintEqualToAnchor:self.messageLabel.bottomAnchor constant:5],

        [compatibility.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:30],
        [compatibility.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-30],
        [compatibility.topAnchor constraintEqualToAnchor:self.statusLabel.bottomAnchor constant:8],

        [self.channelButton.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:24],
        [self.channelButton.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-24],
        [self.channelButton.topAnchor constraintEqualToAnchor:compatibility.bottomAnchor constant:14],
        [self.channelButton.heightAnchor constraintEqualToConstant:50]
    ]];

    [self.view layoutIfNeeded];
    ROBOAddFallingStars(self.view);

    NSString *savedKey = ROBOKeychainRead(kLicenseAccount);
    if (savedKey.length > 0) {
        self.keyField.text = savedKey;
        self.keyField.enabled = NO;
        self.keyField.alpha = 0.72;
        self.statusLabel.text = @"Loading saved license...";
        dispatch_async(dispatch_get_main_queue(), ^{
            [self verifyKey:savedKey automatic:YES];
        });
    } else {
        self.statusLabel.text = @"License verification required";
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self applyAppearance];

    // On a returning launch, the saved-key verification should stay in a
    // loading state instead of popping the keyboard over the license screen.
    if (!self.verifying && self.keyField.text.length == 0) {
        [self.keyField becomeFirstResponder];
    }
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    [super traitCollectionDidChange:previousTraitCollection];
    [self applyAppearance];
}

- (void)applyAppearance {
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.keyField.backgroundColor = [UIColor secondarySystemBackgroundColor];
    self.keyField.textColor = ROBOOrange();
    self.keyField.tintColor = ROBOOrange();
    self.keyField.layer.borderColor = [ROBOOrange() colorWithAlphaComponent:0.35].CGColor;
    self.channelButton.backgroundColor = [ROBOOrange() colorWithAlphaComponent:0.10];
}

- (void)verifyPressed {
    NSString *key = [self.keyField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (key.length == 0) {
        self.messageLabel.textColor = ROBOOrange();
        self.messageLabel.text = @"Please enter a license key.";
        return;
    }

    [self.keyField resignFirstResponder];
    [self verifyKey:key automatic:NO];
}

- (void)verifyKey:(NSString *)key automatic:(BOOL)automatic {
    if (self.verifying) return;

    self.verifying = YES;
    self.verifyButton.enabled = NO;
    self.channelButton.enabled = NO;
    self.keyField.enabled = NO;
    self.spinner.hidden = NO;
    [self.spinner startAnimating];

    // Keep the loading indicator directly on top of the activation button.
    [self.verifyButton setTitle:automatic ? @"LOADING..." : @"LOADING..." forState:UIControlStateNormal];
    self.verifyButton.alpha = 0.92;

    self.messageLabel.text = @"";
    self.statusLabel.text = automatic ? @"Loading saved license..." : @"Authorizing license...";

    NSString *deviceID = ROBOInstallationID();
    NSURL *url = [NSURL URLWithString:kVerifyURL];

    if (!url) {
        [self finishVerification:NO key:key message:@"Invalid verification endpoint."];
        return;
    }

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    request.timeoutInterval = 15.0;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

    NSDictionary *body = @{
        @"key": key,
        @"device_id": deviceID ?: @"",
        @"product_identifier": kProductIdentifier
    };

    NSError *serializationError = nil;
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:body options:0 error:&serializationError];
    if (serializationError || !request.HTTPBody) {
        [self finishVerification:NO key:key message:@"Could not prepare the verification request."];
        return;
    }

    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
        completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    [self finishVerification:NO key:key message:@"Unable to connect to the license server. Check your connection and try again."];
                    return;
                }

                NSHTTPURLResponse *http = [response isKindOfClass:[NSHTTPURLResponse class]]
                    ? (NSHTTPURLResponse *)response
                    : nil;

                NSDictionary *json = nil;
                if (data.length > 0) {
                    id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                    if ([object isKindOfClass:[NSDictionary class]]) {
                        json = (NSDictionary *)object;
                    }
                }

                BOOL success = [json[@"success"] boolValue] || [json[@"valid"] boolValue];
                NSDictionary *nested = [json[@"data"] isKindOfClass:[NSDictionary class]] ? json[@"data"] : nil;
                success = success || [nested[@"success"] boolValue] || [nested[@"valid"] boolValue];

                NSString *status = [json[@"status"] isKindOfClass:[NSString class]] ? [json[@"status"] lowercaseString] : @"";
                success = success || [status isEqualToString:@"success"] || [status isEqualToString:@"valid"];

                NSString *message = nil;
                NSArray *messageKeys = @[@"message", @"error", @"detail"];
                for (NSString *keyName in messageKeys) {
                    if ([json[keyName] isKindOfClass:[NSString class]] && [json[keyName] length] > 0) {
                        message = json[keyName];
                        break;
                    }
                }

                if (!success && nested) {
                    for (NSString *keyName in messageKeys) {
                        if ([nested[keyName] isKindOfClass:[NSString class]] && [nested[keyName] length] > 0) {
                            message = nested[keyName];
                            break;
                        }
                    }
                }

                if (!http || http.statusCode < 200 || http.statusCode > 299) {
                    success = NO;
                }

                if (success) {
                    BOOL saved = ROBOKeychainWrite(key, kLicenseAccount);
                    if (!saved) {
                        [self finishVerification:NO key:key message:@"License verified, but secure storage failed. Please try again."];
                        return;
                    }

                    [self finishVerification:YES key:key message:@"License verified. Opening app..."];
                } else {
                    [self finishVerification:NO key:key message:(message.length ? message : @"License is invalid or not authorized for this device.")];
                }
            });
        }];

    [task resume];
}

- (void)finishVerification:(BOOL)success key:(NSString *)key message:(NSString *)message {
    self.verifying = NO;
    self.verifyButton.enabled = YES;
    self.channelButton.enabled = YES;
    self.keyField.enabled = YES;
    self.keyField.alpha = 1.0;
    [self.spinner stopAnimating];
    self.spinner.hidden = YES;
    [self.verifyButton setTitle:@"ACTIVATE" forState:UIControlStateNormal];
    self.verifyButton.alpha = 1.0;
    self.messageLabel.textColor = ROBOOrange();
    self.messageLabel.text = message ?: @"";

    if (!success) {
        self.statusLabel.text = @"Verification required";
        return;
    }

    self.statusLabel.text = @"Activated";
    self.verifyButton.hidden = YES;
    self.keyField.hidden = YES;
    self.channelButton.hidden = YES;

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"RoboIOS3105LicenseDidVerify" object:nil];
    });
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self verifyPressed];
    return YES;
}

- (void)openTelegram {
    NSURL *url = [NSURL URLWithString:@"https://t.me/+MFbTlA2W7Vk4NmU1"];
    if (url) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://t.me/+MFbTlA2W7Vk4NmU1"] options:@{} completionHandler:nil];
    }
}

@end


static UIWindow *roboLicenseWindow = nil;
static UIWindow *roboBrandWindow = nil;

static void ROBOInstallBrandOverlay(UIWindowScene *windowScene) {
    if (!windowScene) return;

    dispatch_async(dispatch_get_main_queue(), ^{
        if (roboBrandWindow && roboBrandWindow.windowScene == windowScene) {
            roboBrandWindow.hidden = NO;
            [roboBrandWindow bringSubviewToFront:roboBrandWindow.rootViewController.view];
            return;
        }

        UIViewController *overlay = [UIViewController new];
        overlay.view.backgroundColor = UIColor.clearColor;
        overlay.view.userInteractionEnabled = NO;

        UIView *safeContainer = [UIView new];
        safeContainer.translatesAutoresizingMaskIntoConstraints = NO;
        safeContainer.backgroundColor = UIColor.clearColor;
        safeContainer.userInteractionEnabled = NO;
        [overlay.view addSubview:safeContainer];

        UIView *banner = [UIView new];
        banner.translatesAutoresizingMaskIntoConstraints = NO;
        banner.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.08];
        banner.layer.cornerRadius = 14.0;
        banner.layer.borderWidth = 1.0;
        banner.layer.borderColor = [UIColor colorWithWhite:0.55 alpha:0.35].CGColor;
        banner.userInteractionEnabled = NO;

        UILabel *label = [UILabel new];
        label.translatesAutoresizingMaskIntoConstraints = NO;
        label.text = @"Made by Shafay";
        label.textColor = ROBOOrange();
        label.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightBold];

        [banner addSubview:label];
        [safeContainer addSubview:banner];

        CAEmitterLayer *emitter = [CAEmitterLayer layer];
        emitter.name = @"ROBOBrandFallingStars";
        emitter.masksToBounds = YES;
        emitter.emitterShape = kCAEmitterLayerLine;
        emitter.emitterMode = kCAEmitterLayerSurface;

        CAEmitterCell *cell = [CAEmitterCell emitterCell];
        cell.birthRate = 10.0;
        cell.lifetime = 7.0;
        cell.velocity = 34.0;
        cell.velocityRange = 18.0;
        cell.emissionLongitude = (CGFloat)M_PI_2;
        cell.emissionRange = 0.12;
        cell.scale = 0.035;
        cell.scaleRange = 0.018;
        cell.alphaSpeed = -0.08;
        cell.contents = (__bridge id)[UIImage systemImageNamed:@"circle.fill"].CGImage;
        cell.color = (overlay.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark)
            ? UIColor.whiteColor.CGColor
            : UIColor.blackColor.CGColor;
        emitter.emitterCells = @[cell];
        [safeContainer.layer addSublayer:emitter];

        [NSLayoutConstraint activateConstraints:@[
            [safeContainer.leadingAnchor constraintEqualToAnchor:overlay.view.leadingAnchor],
            [safeContainer.trailingAnchor constraintEqualToAnchor:overlay.view.trailingAnchor],
            [safeContainer.topAnchor constraintEqualToAnchor:overlay.view.safeAreaLayoutGuide.topAnchor],
            [safeContainer.bottomAnchor constraintEqualToAnchor:overlay.view.safeAreaLayoutGuide.bottomAnchor],

            [banner.leadingAnchor constraintEqualToAnchor:safeContainer.leadingAnchor constant:16],
            [banner.trailingAnchor constraintEqualToAnchor:safeContainer.trailingAnchor constant:-16],
            [banner.topAnchor constraintEqualToAnchor:safeContainer.topAnchor constant:8],
            [banner.heightAnchor constraintEqualToConstant:46],

            [label.leadingAnchor constraintEqualToAnchor:banner.leadingAnchor constant:16],
            [label.centerYAnchor constraintEqualToAnchor:banner.centerYAnchor]
        ]];

        [overlay.view layoutIfNeeded];
        emitter.frame = safeContainer.bounds;
        emitter.emitterSize = CGSizeMake(safeContainer.bounds.size.width, 1.0);
        emitter.emitterPosition = CGPointMake(safeContainer.bounds.size.width / 2.0, -2.0);

        roboBrandWindow = [[UIWindow alloc] initWithWindowScene:windowScene];
        roboBrandWindow.windowLevel = UIWindowLevelNormal + 0.5;
        roboBrandWindow.backgroundColor = UIColor.clearColor;
        roboBrandWindow.rootViewController = overlay;
        roboBrandWindow.hidden = NO;
        [roboBrandWindow setUserInteractionEnabled:NO];
    });
}

@interface RoboIOS3105Loader : NSObject
@end

@implementation RoboIOS3105Loader

+ (void)load {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sceneDidActivate:)
                                                     name:UISceneDidActivateNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(licenseDidVerify:)
                                                     name:@"RoboIOS3105LicenseDidVerify"
                                                   object:nil];

        [self showLicenseIfNeeded];
    });
}

+ (void)sceneDidActivate:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showLicenseIfNeeded];
        if (roboLicenseWindow == nil) {
            UIWindowScene *windowScene = (UIWindowScene *)notification.object;
            if ([windowScene isKindOfClass:[UIWindowScene class]]) {
                ROBOInstallBrandOverlay(windowScene);
            }
        }
    });
}

+ (void)showLicenseIfNeeded {
    if (roboLicenseWindow != nil && !roboLicenseWindow.hidden) {
        return;
    }

    UIWindowScene *windowScene = nil;

    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if (![scene isKindOfClass:[UIWindowScene class]]) continue;
        UISceneActivationState state = scene.activationState;
        if (state == UISceneActivationStateForegroundActive || state == UISceneActivationStateForegroundInactive) {
            windowScene = (UIWindowScene *)scene;
            break;
        }
    }

    if (!windowScene) {
        return;
    }

    roboLicenseWindow = [[UIWindow alloc] initWithWindowScene:windowScene];
    roboLicenseWindow.windowLevel = UIWindowLevelAlert + 1.0;
    roboLicenseWindow.backgroundColor = [UIColor systemBackgroundColor];
    roboLicenseWindow.rootViewController = [RoboIOS3105LicenseViewController new];
    roboLicenseWindow.hidden = NO;
    [roboLicenseWindow makeKeyAndVisible];
}

+ (void)licenseDidVerify:(NSNotification *)notification {
    dispatch_async(dispatch_get_main_queue(), ^{
        [roboLicenseWindow resignKeyWindow];
        roboLicenseWindow.hidden = YES;
        roboLicenseWindow.rootViewController = nil;
        roboLicenseWindow = nil;

        for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
            if (![scene isKindOfClass:[UIWindowScene class]]) continue;

            UIWindowScene *sceneWindow = (UIWindowScene *)scene;
            for (UIWindow *window in sceneWindow.windows) {
                if (window != roboLicenseWindow && window.windowLevel == UIWindowLevelNormal) {
                    [window makeKeyAndVisible];
                    return;
                }
            }
        }

        UIWindowScene *activeScene = nil;
        for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
            if ([scene isKindOfClass:[UIWindowScene class]]) {
                UIWindowScene *candidate = (UIWindowScene *)scene;
                if (candidate.activationState == UISceneActivationStateForegroundActive ||
                    candidate.activationState == UISceneActivationStateForegroundInactive) {
                    activeScene = candidate;
                    break;
                }
            }
        }
        if (activeScene) {
            ROBOInstallBrandOverlay(activeScene);
        }
    });
}

@end
