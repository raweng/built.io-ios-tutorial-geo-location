//
//  GeoListViewController.m
//  GeoLocations
//


#import "GeoListViewController.h"
#import "MapViewController.h"
#import "GeoLocationCell.h"
#import "AppDelegate.h"
#import "AddNewLocationController.h"
#import "SearchViewController.h"


@interface GeoListViewController (){
  
}

@end

@implementation GeoListViewController

-(id)initWithStyle:(UITableViewStyle)style{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"Geo Locations";
        self.enablePullToRefresh = YES;
        self.fetchLimit = 10;
        self.edgesForExtendedLayout=UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars=NO;
        self.automaticallyAdjustsScrollViewInsets=NO;
        
//        Returns a `BuiltLocation` object for the current longitude and latitude
        [BuiltLocation currentLocationOnSuccess:^(BuiltLocation *currentLocation) {
            [self.builtQuery nearLocation:currentLocation withRadius:3000.0f];
            
            //  Refresh the records by clearing all records from table-view
            [self refresh];
        } onError:^(NSError *error) {
        
        }];
      
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addUserLocation)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchNearByUsers)];
}


#pragma mark
#pragma mark - UITableViewdelegate methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath builtObject:(BuiltObject *)builtObject{
    static NSString *CellIdentifier = @"Cell";
    GeoLocationCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[GeoLocationCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    [cell loadData:builtObject];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MapViewController *mapViewController = [[MapViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:mapViewController animated:YES];
    mapViewController.currentBuiltObject = [self.objectCollection objectAtIndex:indexPath.row];
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


-(void)addUserLocation{
    AddNewLocationController *addUserVC = [[AddNewLocationController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:addUserVC animated:YES];
}

-(void)searchNearByUsers{
    SearchViewController *searchVC = [[SearchViewController alloc]initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:searchVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
