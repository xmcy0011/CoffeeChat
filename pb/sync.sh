#!/bin/sh

GO_OUT=./go
DART_OUT=./dart
SWIFT_OUT=./swift
CPP_OUT=./cpp

GO_PB_DIR=../server/src/api/cim/
FLUTTER_PB_DIR=../client/flutter/lib/imsdk/proto
IOS_PB_DIR=../client/ios/Coffchat/Coffchat/CIMSdk/pb/
# 客户端代码在另外一个Github仓库，这里默认和CoffeeChat同级
CPP_PB_DIR=../../CoffeeChat-Desktop/mac/chatkit/cim/pb

# go
function move_go(){
    cp ${GO_OUT}/*.go ${GO_PB_DIR}
    rm -rf ${GO_OUT}
}

# dart
function move_flutter(){
    rm -rf ${SWIFT_OUT}/Grpc*.dart
    mv ${DART_OUT}/*.dart ${FLUTTER_PB_DIR}
    rm -rf ${DART_OUT}
}

# swift
function move_ios(){
    rm -rf ${SWIFT_OUT}/Grpc*.swift
    mv ${SWIFT_OUT}/*.swift ${IOS_PB_DIR}
    rm -rf ${SWIFT_OUT}
}

# c++
function move_qt(){
    rm -rf ${CPP_OUT}/Grpc*.cc
    mv ${CPP_OUT}/*.h ${CPP_PB_DIR}
    mv ${CPP_OUT}/*.cc ${CPP_PB_DIR}
    rm -rf ${CPP_OUT}
}

move_go
#move_flutter
move_ios
move_qt
