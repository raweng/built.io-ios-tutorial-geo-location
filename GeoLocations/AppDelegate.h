//
//  AppDelegate.h
//  GeoLocations
//


#import <UIKit/UIKit.h>
#import <BuiltIO/BuiltIO.h>
#import <BuiltIO/BuiltUILoginController.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate,BuiltUILoginDelegate,BuiltUITwitterAppSettingDelegate,BuiltUIGoogleAppSettingDelegate,CLLocationManagerDelegate>
@property (strong, nonatomic) BuiltApplication *builtApplication;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController*navigationController;
@property (strong,nonatomic ) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation* location;


+(AppDelegate *)sharedAppDelegate;

@end
