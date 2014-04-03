//
//  GeoLocationCell.m
//  GeoLocations
//

#import "GeoLocationCell.h"

@implementation GeoLocationCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    }
    return _titleLabel;
}

-(UILabel *)locationLabel{
    if (!_locationLabel) {
        _locationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_locationLabel setBackgroundColor:[UIColor clearColor]];
        [_locationLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
    }
    return _locationLabel;
}

-(UILabel *)timeStampLabel{
    if (!_timeStampLabel) {
        _timeStampLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timeStampLabel setBackgroundColor:[UIColor clearColor]];
        [_timeStampLabel setFont:[UIFont fontWithName:@"Helvetica" size:18]];
    }
    return _timeStampLabel;
}

-(void)loadData:(BuiltObject *)obj{
    self.titleLabel.text = [obj objectForKey:@"place_name"];
    BuiltLocation *loc = obj.getLocation;
    self.locationLabel.text = [NSString stringWithFormat:@"%.2f , %.2f",loc.latitude,loc.longitude];
    
    NSDate *date = [self dateWithUTCDateString:[obj objectForKey:@"created_at"] ];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [dateFormatter setDateFormat:@"dd MMM, yyyy"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    [self.timeStampLabel setText:dateString];
}

-(void)prepareForReuse {
    [super prepareForReuse];
    _timeStampLabel.text = nil;
    _titleLabel.text = nil;
    _locationLabel.text = nil;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat xPos = 10;
    CGFloat yPos = 10;
    
    [self.titleLabel setFrame:CGRectMake(xPos, yPos, 300, 20)];
    
    yPos = CGRectGetMaxY(self.titleLabel.frame);
    
    [self.locationLabel setFrame:CGRectMake(xPos, yPos + 5, 120, 20)];
    
    xPos = CGRectGetMaxX(self.locationLabel.frame);
    [self.timeStampLabel setFrame:CGRectMake(xPos +15, yPos+ 5, 140, 20)];
    
    [self addSubview:self.titleLabel];
    [self addSubview:self.locationLabel];
    [self addSubview:self.timeStampLabel];
    
}

-(NSDate*)dateWithUTCDateString:(NSString*)dateString{
	NSString* mydate = [dateString substringToIndex:[dateString length] - 1];
	mydate = [mydate stringByAppendingFormat:@"GMT%@",@"-00:00" ];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [[NSLocale alloc]
                                 initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormat setLocale:enUSPOSIXLocale];
    [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    return [dateFormat dateFromString:mydate];
}

@end
