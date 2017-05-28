//
//  TestCppPbfVC.m
//  BLEProject
//
//  Created by innerpeacer on 2017/5/26.
//  Copyright © 2017年 innerpeacer. All rights reserved.
//

#import "TestCppPbfVC.h"

#import "t_y_raw_data_collection_pbf.pb.h"
#import "IPXPbfDBAdapter.hpp"
#import "IPXRawDataCollection.hpp"
@interface TestCppPbfVC ()

@end

@implementation TestCppPbfVC

using namespace innerpeacer::rawdata;
using namespace std;

- (void)testCppPbf
{
    BRTMethod
    
    NSString *dbPath = [[NSBundle mainBundle] pathForResource:@"MyCollection" ofType:@"db"];
    IPXPbfDBAdapter *db = new IPXPbfDBAdapter([dbPath UTF8String]);
    db->open();
    std::vector<IPXPbfDBRecord *> pbfVector = db->getRecords(IPX_PBF_RAW_DATA);
    cout << pbfVector.size() << " Records" << endl;
    
    TYRawDataCollectionPbf dataCollection;
    IPXPbfDBRecord *record = db->getRecord([self.dataID UTF8String]);
    dataCollection.ParseFromArray(record->data, record->dataLength);
    
    IPXRawDataCollection rd(dataCollection);
    cout << rd.toString() << endl;
    
    db->close();
    delete db;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self testCppPbf];
}

@end
