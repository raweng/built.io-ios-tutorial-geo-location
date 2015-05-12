//
//  AddCurrentUserViewController.h
//  GeoLocations
//


#import <UIKit/UIKit.h>

@interface AddNewLocationController : UIViewController<MKMapViewDelegate,UITextFieldDelegate>{
    MKCoordinateSpan span;
}

@property (strong,nonatomic)MKMapView *currentUserMapView;

@end
