#import "CreateMapJsonVC.h"
#import <ArcGIS/ArcGIS.h>

@interface CreateMapJsonVC ()
{
    NSString *fileName;
}

@property (weak, nonatomic) IBOutlet UITextField *fileNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *hintTextView;

- (IBAction)creatJson:(id)sender;
@end

@implementation CreateMapJsonVC


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)creatJson:(id)sender {
    
    if (self.fileNameTextField.isFirstResponder) {
        [self.fileNameTextField resignFirstResponder];
    }
    
    NSLog(@"creatJson");
    fileName = self.fileNameTextField.text;
    
    if (fileName == nil|| [fileName isEqualToString:@""]) {
        return;
    }
    
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSLog(@"File exist");
        [self readFile:path];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!" message:@"File not exist" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        return;
    }    
}

- (void)readFile:(NSString *)file
{
    NSError *error = nil;

    NSString *jsonString = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:&error];
    
    AGSSBJsonParser *parser = [[AGSSBJsonParser alloc] init];
    NSDictionary *dict = [parser objectWithString:jsonString];
    
    AGSFeatureSet *set = [[AGSFeatureSet alloc] initWithJSON:dict];
    NSArray *allGraphics = set.features;
    
    NSLog(@"%d graphics", (int) allGraphics.count);
    
    NSMutableDictionary *graphicsDict = [[NSMutableDictionary alloc] init];
    for (AGSGraphic *g in allGraphics) {
        NSNumber *floorID = (NSNumber *)[g attributeForKey:@"FloorID"];
        if (![graphicsDict.allKeys containsObject:floorID]) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [graphicsDict setObject:array forKey:floorID];
        }
        
        NSMutableArray *array = [graphicsDict objectForKey:floorID];
        [array addObject:g];
    }
    
    NSLog(@"%d floors", (int)graphicsDict.count);
    
    NSMutableString *hintString = [NSMutableString string];
    
    for (NSNumber *floor in graphicsDict) {
        NSMutableArray *array = [graphicsDict objectForKey:floor];
        AGSFeatureSet *set = [AGSFeatureSet featureSetWithFeatures:array];
        NSDictionary *dict = [set encodeToJSON];
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *fName = [NSString stringWithFormat:@"%@_%@.json", fileName, floor];
        
        NSString *documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
        
       BOOL success = [jsonData writeToFile:[documentDir stringByAppendingPathComponent:fName] atomically:YES];
        NSString *s = success ? [NSString stringWithFormat:@"生成文件%@\n", fName] : [NSString stringWithFormat:@"%@创建失败", fName];
        [hintString appendString:s];
        self.hintTextView.text = hintString;
        
    }
}
@end
