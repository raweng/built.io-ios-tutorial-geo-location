//
//  MapViewController.h
//  GeoLocations
//


#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController<MKMapViewDelegate>

@property (strong,nonatomic)MKMapView *builtMapView;
@property (strong,nonatomic)BuiltObject * currentBuiltObject;
@end
