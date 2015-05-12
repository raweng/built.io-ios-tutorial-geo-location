//
//  GeoPinAnnotation.m
//  GeoLocations
//

#import "GeoPinAnnotation.h"

@implementation GeoPinAnnotation
@synthesize bObject;
- (id)initWithObject:(BuiltObject *)builtObject {
    self = [super init];
    if (self) {
        bObject = builtObject;
        
        BuiltLocation *geoPoint = builtObject.location;
        [self setGeoPoint:geoPoint];
    }
    return self;
}

- (void)setGeoPoint:(BuiltLocation *)geoPoint {
    _coordinate = CLLocationCoordinate2DMake(geoPoint.latitude, geoPoint.longitude);
    
    NSDate *date = [self dateWithUTCDateString:[bObject objectForKey:@"created_at"] ];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:@"dd MMM, yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    _title = dateString;
    _subtitle = [NSString stringWithFormat:@"%.2f , %.2f",geoPoint.latitude,geoPoint.longitude];
    
}

-(NSDate*)dateWithUTCDateString:(NSString*)dateString{
	NSString* mydate = [dateString substringToIndex:[dateString length] - 1];
	mydate = [mydate stringByAppendingFormat:@"GMT%@",@"-00:00" ];
    // Convert string to date object
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc]
                                 initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormat setLocale:enUSPOSIXLocale];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    return [dateFormat dateFromString:mydate];
}

@end
