//
//  GeoLocationCell.h
//  GeoLocations
//

#import <UIKit/UIKit.h>

@interface GeoLocationCell : UITableViewCell

@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *locationLabel;
@property (strong, nonatomic) UILabel *timeStampLabel;

-(void)loadData:(BuiltObject *)obj;

@end
