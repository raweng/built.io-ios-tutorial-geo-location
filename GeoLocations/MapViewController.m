//
//  MapViewController.m
//  GeoLocations
//


#import "MapViewController.h"
#import "GeoPinAnnotation.h"

@interface MapViewController (){
    MKCoordinateSpan span;
}
@end

@implementation MapViewController
@synthesize builtMapView,currentBuiltObject;

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
    self.title = @"Map View";
    self.builtMapView = [[MKMapView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.builtMapView];
    [self.builtMapView setDelegate:self];

    if (self.currentBuiltObject.location) {
        BuiltLocation *currentLocation = self.currentBuiltObject.location;
        self.builtMapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(currentLocation.latitude, currentLocation.longitude), MKCoordinateSpanMake(0.01f, 0.01f));
        
        // add the annotation
        GeoPinAnnotation *annotation = [[GeoPinAnnotation alloc] initWithObject:self.currentBuiltObject];
        [self.builtMapView addAnnotation:annotation];
    }
}

#pragma mark
#pragma mark - MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    span.latitudeDelta = 0.004 ;
    span.longitudeDelta = 0.004 ;
    [self.builtMapView setUserTrackingMode:MKUserTrackingModeNone animated:YES];
    
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *GeoPointAnnotationIdentifier = @"RedPin";
    
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:GeoPointAnnotationIdentifier];
    
    if (!annotationView) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:GeoPointAnnotationIdentifier];
        annotationView.pinColor = MKPinAnnotationColorRed;
        annotationView.canShowCallout = YES;
        annotationView.draggable = YES;
        annotationView.animatesDrop = YES;
    }
    
    return annotationView;
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
