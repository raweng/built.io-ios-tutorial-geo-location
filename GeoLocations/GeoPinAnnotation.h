//
//  GeoPinAnnotation.h
//  GeoLocations
//


#import <Foundation/Foundation.h>

@interface GeoPinAnnotation : NSObject <MKAnnotation>

- (id)initWithObject:(BuiltObject *)builtObject;
@property (nonatomic,strong) BuiltObject *bObject;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;

@end
