//
//  AddCurrentUserViewController.m
//  GeoLocations
//

#import "AddNewLocationController.h"
#import "GeoListViewController.h"

@interface AddNewLocationController (){
    UITextField *nameTextField;
    UITextField *desTextField;
}

@end

@implementation AddNewLocationController
@synthesize currentUserMapView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Add Current User";
    [self initialiseView];
}

-(void)initialiseView{
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addUserLocation)];
    
    self.currentUserMapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 150, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:self.currentUserMapView];
    [self.currentUserMapView setShowsUserLocation:YES];
    [self.currentUserMapView setDelegate:self];
//    span.latitudeDelta = 0.004 ;
//    span.longitudeDelta = 0.004 ;
//    [self.currentUserMapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
    
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, 80, 50)];
    nameLabel.text = @"Name :";
    [nameLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
    nameLabel.numberOfLines = 1;
    nameLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    nameLabel.adjustsFontSizeToFitWidth = YES;
    nameLabel.minimumScaleFactor = 10.0f/12.0f;
    nameLabel.clipsToBounds = YES;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = [UIColor blackColor];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:nameLabel];
    
    nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(nameLabel.frame.origin.x + nameLabel.frame.size.width +20, 70, 200, 30)];
    nameTextField.borderStyle = UITextBorderStyleRoundedRect;
    nameTextField.font = [UIFont systemFontOfSize:15];
    nameTextField.placeholder = @"Name";
    nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    nameTextField.keyboardType = UIKeyboardTypeDefault;
    nameTextField.returnKeyType = UIReturnKeyNext;
    nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    nameTextField.delegate = self;
    [nameTextField setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:nameTextField];
    
    UILabel *desLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, nameLabel.frame.origin.y +nameLabel.frame.size.height - 10, 90, 50)];
    desLabel.text = @"Description :";
    [desLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
    desLabel.numberOfLines = 1;
    desLabel.baselineAdjustment = UIBaselineAdjustmentAlignBaselines;
    desLabel.adjustsFontSizeToFitWidth = YES;
    desLabel.minimumScaleFactor = 10.0f/12.0f;
    desLabel.clipsToBounds = YES;
    desLabel.backgroundColor = [UIColor clearColor];
    desLabel.textColor = [UIColor blackColor];
    desLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:desLabel];
    
    desTextField = [[UITextField alloc] initWithFrame:CGRectMake(desLabel.frame.origin.x + desLabel.frame.size.width +10, nameLabel.frame.origin.y +nameLabel.frame.size.height, 200, 30)];
    desTextField.borderStyle = UITextBorderStyleRoundedRect;
    desTextField.font = [UIFont systemFontOfSize:15];
    desTextField.placeholder = @"Description";
    desTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    desTextField.keyboardType = UIKeyboardTypeDefault;
    desTextField.returnKeyType = UIReturnKeyDone;
    desTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    desTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    desTextField.delegate = self;
    [desTextField setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:desTextField];
    
}

-(void)addUserLocation{
    // Add new Built object to with class UID and set Location
    CLLocation *currentlocation = [AppDelegate sharedAppDelegate].locationManager.location;
    CLLocationCoordinate2D coordinate = [currentlocation coordinate];

    if (nameTextField.text.length > 0 && desTextField.text.length > 0) {
        BuiltLocation *builtlocation = [BuiltLocation locationWithLongitude:coordinate.longitude andLatitude:coordinate.latitude];
        BuiltClass *builtClass = [[AppDelegate sharedAppDelegate].builtApplication classWithUID:@"places"];
        BuiltObject *newBuiltObject = [builtClass object];
        [newBuiltObject setObject:nameTextField.text forKey:@"place_name"];
        [newBuiltObject setObject:desTextField.text forKey:@"description"];
        [newBuiltObject setLocation:builtlocation];
        [newBuiltObject saveInBackgroundWithCompletion:^(ResponseType responseType, NSError *error) {
            if (!error) {
                UIAlertView *fbErrorAlert = [[UIAlertView alloc]initWithTitle:@"Built.io Backend Message" message:@"New Built object saved" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                [fbErrorAlert show];

            }
        }];
    }else{
        UIAlertView *textAlert = [[UIAlertView alloc]initWithTitle:@"Built.io Backend Message" message:@"Enter Name and Description" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    [textAlert show];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == nameTextField) {
        [desTextField becomeFirstResponder];
    }else if (textField == desTextField){
        [desTextField resignFirstResponder];
    }
    return YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
}

#pragma mark
#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    span.latitudeDelta = 0.004 ;
    span.longitudeDelta = 0.004 ;
    [self.currentUserMapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
