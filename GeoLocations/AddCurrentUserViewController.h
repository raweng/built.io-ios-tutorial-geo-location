//
//  AddCurrentUserViewController.h
//  GeoLocations
//


#import <UIKit/UIKit.h>

@interface AddCurrentUserViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate,UITextFieldDelegate>{
    MKCoordinateSpan span;
}
@property (strong,nonatomic)MKMapView *currentUserMapView;
@property (strong,nonatomic ) CLLocationManager *locationManager;

@end
