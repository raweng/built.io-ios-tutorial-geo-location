//
//  SearchViewController.h
//  GeoLocations

#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController<MKMapViewDelegate>

@property (strong, nonatomic) MKMapView *searchMapView;
@property (strong, nonatomic) UISlider *radiusSlider;


@end
