//
//  AppDelegate.m
//  GeoLocations
//


#import "AppDelegate.h"
#import "GeoListViewController.h"

@implementation AppDelegate
@synthesize navigationController,location;


// ****************************************************************************
// GeoLocations app gives nearby location objects.
// Objects nearby user's current loaction varies w.r.t radius using `BuiltLocation` class
// ****************************************************************************

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // ****************************************************************************
    // Fill in with your Built credentials.
    // Sets the api key of your application
    // ****************************************************************************

    self.builtApplication = [Built applicationWithAPIKey:@"blt9f2f3c1d77c907e0"];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    BuiltUser *user = [self.builtApplication currentUser];

    //Configuring the delivery of location by intilising CLLocationManager and heading related events to our application
    [self initialiseLocationManager];
        
    //Check for User logged in
    if (user) {
        [user setAsCurrentUser];
        [self loadGeoLocations];
    }else{
        [self loginWithUser];
    }
    
    CLLocation *loc = self.locationManager.location;
    
    //Get current Built user
    BuiltUser *defaultUser = [self.builtApplication currentUser];
    BuiltLocation *builtLoc = [BuiltLocation locationWithLongitude:loc.coordinate.longitude andLatitude:loc.coordinate.latitude];
    
    //Set Location of user and Update data of user
    [defaultUser setLocation:builtLoc];
    [defaultUser updateUserInBackgroundWithAuthData:nil completion:^(ResponseType responseType, NSError *error) {
        
    }];
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)loadGeoLocations{
    
    // ****************************************************************************
    // `BuiltUITableViewController` Sub-class of UITableViewController with support of BuiltIO SDK
    // Initializes a table-view controller to manage a table view of a given style and binds with Built Class of a given classUID.
    // ****************************************************************************
    BuiltClass *builtClass = [self.builtApplication classWithUID:@"places"];
    GeoListViewController *geoViewController = [[GeoListViewController alloc]initWithStyle:UITableViewStylePlain withBuiltClass:builtClass];//@"places"
    self.navigationController = [[UINavigationController alloc]initWithRootViewController:geoViewController];
    self.window.rootViewController = self.navigationController;
}

-(void)loginWithUser{
    // ****************************************************************************
    // Initiate BuiltUILoginController to Login with Buil.io ,Google and Twitter account
    // ****************************************************************************
    
    BuiltUILoginController *loginView = [[BuiltUILoginController alloc]initWithNibName:nil bundle:nil];
    loginView.delegate = self;
    loginView.builtApplication = self.builtApplication;
    
    // Set delegates  for twitter and google sign in
    [loginView setTwitterAppSettingDelegate:self];
    [loginView setGoogleAppSettingDelegate:self];
    
    // Selection of UI feilds needs to be displayed on Login view
    loginView.fields = BuiltLoginFieldTwitter| BuiltLoginFieldSignUp|BuiltLoginFieldUsernameAndPassword|BuiltLoginFieldLogin|BuiltLoginFieldGoogle|BuiltLoginFieldDismiss;
    self.navigationController = [[UINavigationController alloc]initWithRootViewController:loginView];
    [loginView.dismissButton addTarget:loginView.dismissButton action:@selector(cancelTapped) forControlEvents:UIControlEventTouchDown];
    
    loginView.shouldHandleLoadingHUD = YES;
    [self.window setRootViewController:self.navigationController];

}

+(AppDelegate *)sharedAppDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

//Invoked when Login is successful.
- (void)loginSuccessWithUser:(BuiltUser *)user{
    //Save user on disk and get user info
    [user setAsCurrentUser];
    [self loadGeoLocations];
}

//Invoked when Login is failed.
-(void)loginFailedWithError:(NSError *)error{
    
}

#pragma mark
#pragma mark GoogleAppSettingDelegate

//For Google App Client ID to authenticate from Google
-(NSString *)googleAppClientID{
    //Put client_id here
    return @"568588508670.apps.googleusercontent.com";
}

//For Google App Client Secret to authenticate from Google
-(NSString *)googleAppClientSecret{
    //Put secret here
    return @"YNASO2MDS17U58rT7Hm12l7Z";
}

#pragma mark
#pragma mark TwitterAppSettingDelegate

-(NSString *)consumerKey{
    //Put twitter consumer_key here
    return @"twitter consumer key";
}

-(NSString *)consumerSecret{
    //Put twitter consumer_secret here
    return @"consumer_secret here";
}

-(void)cancelTapped{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)initialiseLocationManager{
    if (self.locationManager == nil) {
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        self.locationManager.distanceFilter = 100;
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
        
    }else if (self.locationManager != nil){
        [self destoryLocationManager];
    }
}

-(void)destoryLocationManager {
    if (self.locationManager != nil) {
        [self.locationManager stopUpdatingLocation];
        self.locationManager.delegate = nil;
        self.locationManager = nil;
    }
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    self.locationManager = manager;
}

@end
