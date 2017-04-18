#import "BaseControllerTableVC.h"
#import "ControllerObject.h"

@interface BaseControllerTableVC()
{
}

@end

@implementation BLEAlgorithmTableVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"BLE算法";
    self.storyboardName = @"BLE-Algorithm";
    self.controllerObjects = [ControllerCollections bleAlgorithmControllers];
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
    [self.navigationController pushViewController:controller animated:YES];
}

@end
