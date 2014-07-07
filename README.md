# AppbotX

AppbotX is an iOS client library and sample application for the [AppbotX](http://appbot.co/appbotx) service. It is currently in [limited beta](https://appbot.co/appbotx).

## Requirements

The sample project includes a test key, but for you own application you will need an [Appbot](http://appbot.co) account and an API key.

## Installation

Appbotx will be available through [CocoaPods](http://cocoapods.org). To install it, simply add the following line to your Podfile and run pod install.

    pod "AppbotX", :git => "https://github.com/appbotx/appbotx.git"
    
Alternatively you can just [download the latest release](https://github.com/appbotx/appbotx/releases) and add it to your project.

Then initialize with your API key in your AppDelegate

	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
	{
    	[[ABXApiClient instance] setApiKey:@"API_KEY"];
    	return YES;
	}

And import ABX.h into your precompiled header. Alternatively you can just include it within the files you require.

	#ifdef __OBJC__
    	#import <UIKit/UIKit.h>
    	#import <Foundation/Foundation.h>

    	#import "ABX.h"
	#endif

## Usage

To run the example project; clone the repo, and open "Sample Project.xcodeproj" from the Example folder.

### FAQ

#### Default UI
To show the default UI simply call the showFromController helper method on ABXFAQsViewController.

	[ABXFAQsViewController showFromController:self hideContactButton:NO contactMetaData:nil initialSearch:nil];

* **controller** - required - the controller to be presented from.
* **hideContactButton** - YES/NO - if the contact button should be shown the the top right.
* **metaData** - optional - extra meta data you would like to attach if the contact is shown, only use types supported by NSJSONSerialization, e.g. NSString, NSNumber etc.
* **initialSearch** - optional - the initial search filter to apply to the results. 

#### Push On Your Own UINavigationController

	ABXFAQsViewController *controller = [[ABXFAQsViewController alloc] init];
	// Optinally set hideContactButton & contactMetaData
	[self.navigationController pushViewController:controller animated:YES];
	
#### Fetch Manually

	[ABXFaq fetch:^(NSArray *faqs, ABXResponseCode responseCode, NSInteger httpCode, NSError *error) {
        switch (responseCode) {
            case ABXResponseCodeSuccess: {
            	// Success, use faqs
            }
                break;
                
            default: {
            	// Failure       
            }
                break;
        }
    }];	

* **faqs** array of ABXFaq objects.
* **responseCode** - response code, ABXResponseCodeSuccess for success, see enum for errors.
* **httpCode** - the http code, 200 for success etc.
* **error** - the error, nil if success.

---

### Feedback

#### Default UI

To show the default UI simply call the showFromController helper method on ABXFeedbackViewController.

	[ABXFeedbackViewController showFromController:self placeholder:@"default hint" email:nil metaData:@{ @"Sample" : @YES } image:nil];

* **controller** - required - the controller to be presented from.
* **placeholder** - optional - the default hint text shown, nil to use the default.
* **email** - optional - the default email address to use, if you have this otherwise nil.
* **metaData** - optional - extra meta data you would like to attach, only use types supported by NSJSONSerialization, e.g. NSString, NSNumber etc.
* **image** - optional - an image, such as a screenshot to be attached by default.

#### Push On Your Own UINavigationController

	ABXFeedbackViewController *controller = [[ABXFeedbackViewController alloc] init];
	[self.navigationController pushViewController:controller animated:YES];
	
---	

### Versions

#### Default UI

Showing a list:

	[ABXVersionsViewController showFromController:self];
	
* **controller** - required - the controller to be presented from.
	
Showing new versions / update text:

    [ABXVersionNotificationView fetchAndShowInController:self foriTunesID:kiTunesID backgroundColor:[UIColor redColor] textColor:[UIColor blackColor] buttonColor:[UIColor whiteColor] complete:^(BOOL shown) {
    // Here you may want to chain fetching notifications
    // if it wasn't shown
    }];

* **controller** - required - the controller to be presented from.
* **foriTunesID** - required - your iTunes identifier.
* **backgroundColor** - required - the background color for the control.
* **textColor** - required - the text color for the control.
* **buttonColor** - required - the color for the buttons.
* **complete** - optional - a callback when the operation has completed.

#### Manually Fetching

Fetch the list of versions:

    [ABXVersion fetch:^(NSArray *versions, ABXResponseCode responseCode, NSInteger httpCode, NSError *error) {
        switch (responseCode) {
            case ABXResponseCodeSuccess: {
            }
                break;
                
            default: {
            }
                break;
        }
    }];
 
* **versions** array of ABXVersion objects.
* **responseCode** - response code, ABXResponseCodeSuccess for success, see enum for errors.
* **httpCode** - the http code, 200 for success etc.
* **error** - the error, nil if success.

Fetch the current version:

    [ABXVersion fetchCurrentVersion:^(ABXVersion *version, ABXVersion *currentVersion, ABXResponseCode responseCode, NSInteger httpCode, NSError *error) {
    }];
    
* **version** the version matching the current build version.
* **currentVersion** the latest version on the server.
* **responseCode** - response code, ABXResponseCodeSuccess for success, see enum for errors.
* **httpCode** - the http code, 200 for success etc.
* **error** - the error, nil if success.

---

### Notifications

Documentation coming soon, check the example.

## Localizing Strings

You can change any of the default strings by using localization. All strings used can be found in AppbotX.bundle, but it will prefer strings declared in your local strings bundle.

e.g.

	"How can we help?" = "How can we help you with Sample App?";
	
See the sample app for an example.

## Communication

* If you found a bug, [open an issue](https://github.com/appbotx/appbotx/issues).
* If you have a feature request, [open an issue](https://github.com/appbotx/appbotx/issues).
* If you want to contribute, [submit a pull request](https://github.com/appbotx/appbotx/pulls).	

## License

AppbotX is available under the MIT license. See the LICENSE file for more info.

