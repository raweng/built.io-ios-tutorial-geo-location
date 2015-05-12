//
//  SearchViewController.m
//  GeoLocations
//


#import "SearchViewController.h"
#import "GeoPinAnnotation.h"
#import "GeoQueryAnnotation.h"
#import "CircleOverlay.h"

enum PinAnnotationTypeTag {
    PinAnnotationTypeTagGeoPoint = 0,
    PinAnnotationTypeTagGeoQuery = 1
};

@interface SearchViewController (){
    BuiltUser *currentBuiltUser;
    UILabel *radiusLabel;
}
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, assign) CLLocationDistance radius;
@property (nonatomic, strong) CircleOverlay *targetOverlay;

@end

@implementation SearchViewController
@synthesize searchMapView,radiusSlider;

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
    self.title = @"Search Nearby Places";
    // Initilise Map view with current location
    self.searchMapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height -50)];
    [self.view addSubview:self.searchMapView];
    [self.searchMapView setDelegate:self];
   
    [self initiliseSlider];
    
    // Get current Built User
    currentBuiltUser = [[AppDelegate sharedAppDelegate].builtApplication currentUser];
    [BuiltLocation currentLocationOnCompletion:^(BuiltLocation *currentLocation, NSError *error) {
        if (!error) {
            [currentBuiltUser setLocation:currentLocation];
            [currentBuiltUser updateUserInBackgroundWithAuthData:nil completion:^(ResponseType responseType, NSError *error) {
                if (!error) {
                    [self configureOverlay];
                }
            }];
        }
    }];
   
}

-(void)initiliseSlider{
    
    radiusLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height - 35, 98, 20)];
    [radiusLabel setText:@"Radius (200 m)"];
    [radiusLabel setBackgroundColor:[UIColor clearColor]];
    [radiusLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
    [self.view addSubview:radiusLabel];
    
    CGFloat radHeight;
    
    if ([[UIScreen mainScreen] bounds].size.height == 480) {
        radHeight = 445;
    }else{
        radHeight = 540;
    }
    
    CGRect frame = CGRectMake(radiusLabel.frame.origin.x+radiusLabel.frame.size.width+3,radHeight , 200.0, 25.0);
    UISlider *slider = [[UISlider alloc] initWithFrame:frame];
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [slider setBackgroundColor:[UIColor clearColor]];
    slider.minimumValue = 20.0;
    slider.maximumValue = 10000.0;
    slider.continuous = YES;
    slider.value = 200;
    [self.view addSubview:slider];
}

#pragma mark
#pragma mark - MKMapViewDelegate methods

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *GeoQueryAnnotationIdentifier = @"PurplePinAnnotation";
    
    if ([annotation isKindOfClass:[GeoQueryAnnotation class]]) {
        MKPinAnnotationView *annotationView =
        (MKPinAnnotationView *)[mapView
                                dequeueReusableAnnotationViewWithIdentifier:GeoQueryAnnotationIdentifier];
        
        if (!annotationView) {
            annotationView = [[MKPinAnnotationView alloc]
                              initWithAnnotation:annotation
                              reuseIdentifier:GeoQueryAnnotationIdentifier];
            annotationView.tag = PinAnnotationTypeTagGeoQuery;
            annotationView.canShowCallout = YES;
            annotationView.pinColor = MKPinAnnotationColorGreen;
            annotationView.animatesDrop = NO;
            annotationView.draggable = YES;
        }
        
        return annotationView;
    }
    return nil;
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    static NSString *CircleOverlayIdentifier = @"Circle";
    
    if ([overlay isKindOfClass:[CircleOverlay class]]) {
        CircleOverlay *circleOverlay = (CircleOverlay *)overlay;
        
        MKCircleView *annotationView =
        (MKCircleView *)[mapView dequeueReusableAnnotationViewWithIdentifier:CircleOverlayIdentifier];
        
        if (!annotationView) {
            MKCircle *circle = [MKCircle
                                circleWithCenterCoordinate:circleOverlay.coordinate
                                radius:circleOverlay.radius];
            annotationView = [[MKCircleView alloc] initWithCircle:circle];
        }
        
        if (overlay == self.targetOverlay) {
            annotationView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.1];
            annotationView.strokeColor = [UIColor redColor];
            annotationView.lineWidth = 1.0f;
        } else {
            annotationView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.1];
            annotationView.strokeColor = [UIColor purpleColor];
            annotationView.lineWidth = 2.0f;
        }
        
        return annotationView;
    }
    
    return nil;
}

- (void)configureOverlay {
    if (currentBuiltUser.location) {
        [self.searchMapView removeAnnotations:self.searchMapView.annotations];
        [self.searchMapView removeOverlays:self.searchMapView.overlays];
        
        CircleOverlay *overlay = [[CircleOverlay alloc] initWithCoordinate:CLLocationCoordinate2DMake(currentBuiltUser.location.latitude, currentBuiltUser.location.longitude) radius:self.radius];
        [self.searchMapView addOverlay:overlay];
        
        GeoQueryAnnotation *annotation = [[GeoQueryAnnotation alloc] initWithCoordinate:CLLocationCoordinate2DMake(currentBuiltUser.location.latitude, currentBuiltUser.location.longitude) radius:self.radius];
        [self.searchMapView addAnnotation:annotation];
        
        [self updateLocations];
    }
}

- (void)sliderValueChanged:(UISlider *)aSlider {
    self.radius = aSlider.value;
    [radiusLabel setText:[NSString stringWithFormat:@"Radius (%d m)",(int)self.radius]];
    if (self.targetOverlay) {
        [self.searchMapView removeOverlay:self.targetOverlay];
    }
    
    self.targetOverlay = [[CircleOverlay alloc] initWithCoordinate:CLLocationCoordinate2DMake(currentBuiltUser.location.latitude, currentBuiltUser.location.longitude) radius:self.radius];
    [self.searchMapView addOverlay:self.targetOverlay];
    [self configureOverlay];
}

- (void)updateLocations {
    
    // BuiltQuery is used to query for BuiltObjects for respective class UID
    BuiltClass *builtClass = [[AppDelegate sharedAppDelegate].builtApplication classWithUID:@"places"];
    BuiltQuery *query = [builtClass query];
    self.searchMapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(currentBuiltUser.location.latitude, currentBuiltUser.location.longitude), MKCoordinateSpanMake(0.05f, 0.05f));
    
    if (!self.radius) {
        [query nearLocation:currentBuiltUser.location withRadius:100];
    }else{
        [query nearLocation:currentBuiltUser.location withRadius:self.radius];
    }
    
    //Executes a single or a chained query and callbacks the `QueryResult` with `ResponseType`.
    [query execInBackground:^(ResponseType type, QueryResult *result, NSError *error) {
        if (!error) {
            for (BuiltObject *object in [result getResult]) {
                
                if (object.location != currentBuiltUser.location) {
                    GeoPinAnnotation *geoPinAnnotation = [[GeoPinAnnotation alloc]initWithObject:object];
                    [self.searchMapView addAnnotation:geoPinAnnotation];
                }
                
            }
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
