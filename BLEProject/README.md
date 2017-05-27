定位轨迹的pbf命令：
    cd /Users/innerpeacer/Desktop/TY-iOS/TYBLE/BLEProject/BLEProject/protobuf/proto
    protoc --objc_out=../objc t_y_trace_pbf.proto

原始数据的pbf命令：
    cd /Users/innerpeacer/Desktop/TY-iOS/TYBLE/BLEProject/BLEProject/protobuf/proto
    protoc --objc_out=../objc t_y_raw_data_collection_pbf.proto

C++版本：
    cd /Users/innerpeacer/Desktop/TY-iOS/TYBLE/BLEProject/BLEProject/protobuf/proto
    protoc --cpp_out=../cpp/proto t_y_raw_data_collection_pbf.proto
    protoc --cpp_out=../cpp/proto t_y_trace_pbf.proto 
