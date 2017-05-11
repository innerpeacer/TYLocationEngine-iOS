#import "AppDelegate.h"

#import <TYMapSDK/TYMapSDK.h>
#import "TYUserDefaults.h"

#define DEFAULT_MAP_ROOT @"Map"

#import "IPSyncBeaconDBAdapter.h"

#import "TYBeaconRegionDBAdapter.h"
#import <CoreLocation/CoreLocation.h>

#import "TYBLEEnvironment.h"
@interface AppDelegate()
{

}

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self initArcGISEnvironment];
    [self copyMapFilesIfNeeded];
    [self setDefaultPlaceIfNeeded];
    [self copyCollectionDatabaseIfNeeded];
    [self registerDefaultsFromSettingsBundle];
    
    return YES;
}

- (void)initArcGISEnvironment
{
    [TYMapEnvironment initMapEnvironment];
    [TYMapEnvironment setHostName:HOST_NAME];
    
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSLog(@"%@", documentDirectory);
    [TYMapEnvironment setRootDirectoryForMapFiles:[documentDirectory stringByAppendingPathComponent:DEFAULT_MAP_ROOT]];
    [TYBLEEnvironment setRootDirectoryForFiles:[TYMapEnvironment getRootDirectoryForMapFiles]];
}

- (void)setDefaultPlaceIfNeeded
{
    if ([TYUserDefaults getDefaultBuilding] == nil) {
//        [TYUserDefaults setDefaultCity:@"0021"];
//        [TYUserDefaults setDefaultBuilding:@"00210025"];
        
//        [TYUserDefaults setDefaultCity:@"0021"];
        [TYUserDefaults setDefaultBuilding:@"00210024"];
    }
}

- (void)copyCollectionDatabaseIfNeeded
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cdb = [[NSBundle mainBundle] pathForResource:@"MyCollection" ofType:@"db"];
    
    NSString *documentDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *destDB = [documentDirectory stringByAppendingPathComponent:@"MyCollection.db"];
    if (![fileManager fileExistsAtPath:destDB]) {
        [fileManager copyItemAtPath:cdb toPath:destDB error:nil];
    }
}

- (void)copyMapFilesIfNeeded
{
    BOOL overwritingFile = NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *targetRootDir = [TYMapEnvironment getRootDirectoryForMapFiles];
    NSString *sourceRootDir = [[NSBundle mainBundle] pathForResource:@"MapEncrypted" ofType:nil];
    
    NSDirectoryEnumerator *enumerator;
    enumerator = [fileManager enumeratorAtPath:sourceRootDir];
    NSString *name;
    while (name= [enumerator nextObject]) {
        NSString *sourcePath = [sourceRootDir stringByAppendingPathComponent:name];
        NSString *targetPath = [targetRootDir stringByAppendingPathComponent:name];
        NSString *pathExtension = sourcePath.pathExtension;
        
        if (!overwritingFile) {
            if ([fileManager fileExistsAtPath:targetPath]) {
                continue;
            }
        }
        
        if (pathExtension.length > 0) {
            [fileManager copyItemAtPath:sourcePath toPath:targetPath error:nil];
        } else {
            [fileManager createDirectoryAtPath:targetPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
    }
}

-(void)registerDefaultsFromSettingsBundle
{
    NSString *settingsBundle=[[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    if (!settingsBundle) {
        NSLog(@"Could not find Settings.bundle");
        return;
    }
    
    NSDictionary *settings=[NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferences=[settings objectForKey:@"PreferenceSpecifiers"];
    
    NSMutableDictionary *defaultsToRegister=[[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    for(NSDictionary *prefSpecification in preferences)
    {
        NSString *key=[prefSpecification objectForKey:@"Key"];
        if(key)
        {
            [defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
        }
    }
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
}

@end
