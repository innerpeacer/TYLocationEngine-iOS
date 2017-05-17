#import "BaseControllerTableVC.h"

@interface ControllerObject : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *storyboardID;
@end

@implementation ControllerObject
@end

@interface ControllerCollections : NSObject
+ (NSArray *)bleToolControllers;
+ (NSArray *)bleAlgorithmControllers;
+ (NSArray *)mapControllers;
@end

@implementation ControllerCollections

+ (NSArray *)bleToolControllers
{
    NSArray *viewControllers = @[
                                 @[@"当前地图", @"mapViewController"],
                                 @[@"添加BeaconRegion", @"AddBeaconRegionVC"],
                                 @[@"添加Beacon", @"addPrimitiveController"],
                                 @[@"配置Beacon", @"ConfigureBeaconsVC"],
                                 @[@"验证Beacon数据", @"CheckBeaconDatabaseVC"],
                                 @[@"上传定位数据", @"UploadLocatingDataVC"],
                                 @[@"下载定位数据", @"DownloadLocatingDataVC"],
                                 @[@"获取定位数据", @"FetchLocatingDataVC"],
                                 @[@"配置点位图", @"ConfigurePointPositionVC"],
                                 ];
    return [ControllerCollections getControllerArray:viewControllers];
}

+ (NSArray *)bleAlgorithmControllers
{
    NSArray *viewControllers = @[
                                 @[@"定位测试", @"CppEngineTestVC"],
                                 @[@"PDR测试", @"PDRTestVC"],
                                 @[@"原始数据收集", @"RawDataCollectionVC"],
                                 @[@"原始数据列表", @"RawDataTableVC"],
                                 @[@"融合PDR测试", @"FusionPDRSimulatorVC"],

                                 ];
    return [ControllerCollections getControllerArray:viewControllers];
}

+ (NSArray *)mapControllers
{
    NSArray *viewControllers = @[
                                 @[@"ArcGIS地图", @"cityListController"],
                                 ];
    return [ControllerCollections getControllerArray:viewControllers];
}


+ (NSArray *)getControllerArray:(NSArray *)array
{
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (int i = 0; i < array.count; ++i) {
        NSArray *obj = array[i];
        ControllerObject *controller = [[ControllerObject alloc] init];
        controller.name = [NSString stringWithFormat:@"%d. %@", i, obj[0]];
        controller.storyboardID = obj[1];
        [controllers addObject:controller];
    }
    return controllers;
}

@end

@interface BaseControllerTableVC()

@end

@implementation BLEAlgorithmTableVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"BLE算法";
    self.storyboardName = @"BLE-Algorithm";
    self.controllerObjects = [ControllerCollections bleAlgorithmControllers];
    
    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
}

@end

@implementation BLEToolTableVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"BLE工具";
    self.storyboardName = @"BLE-Tool";
    self.controllerObjects = [ControllerCollections bleToolControllers];
}

@end

@implementation MapTableVC

- (void)viewDidLoad
{
    self.title = @"地图";
    self.storyboardName = @"Map";
    self.controllerObjects = [ControllerCollections mapControllers];
}

@end


@implementation BaseControllerTableVC

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _controllerObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    ControllerObject *obj = _controllerObjects[indexPath.row];
    cell.textLabel.text = obj.name;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ControllerObject *obj = self.controllerObjects[indexPath.row];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:self.storyboardName bundle:nil];
    UIViewController *controller = [storyboard instantiateViewControllerWithIdentifier:obj.storyboardID];
    [self.navigationController pushViewController:controller animated:NO];
}

@end
