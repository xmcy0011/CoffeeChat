#!/bin/bash

GO_OUT=./go
DART_OUT=./dart
SWIFT_OUT=./swift
CPP_OUT=./cpp

mkdir ${GO_OUT}
mkdir ${DART_OUT}
mkdir ${SWIFT_OUT}
mkdir ${CPP_OUT}

# protoc: 使用mac brew 安装的
protoc --go_out=plugins=grpc:${GO_OUT} *.proto # golang
protoc --dart_out=${DART_OUT} *.proto # dart
protoc --swift_out=${SWIFT_OUT} *.proto # swift

# C++
# PS：对于C++而言，需要protoc和protobuf库版本一致，推荐通过vcpkg安装protobuf
# 请配置VCPKGROOT环境变量，指定vcpkg的路径
VCPKG_PROTOC_DIR=${VCPKGROOT}/installed/x64-osx/tools/protobuf/protoc
${VCPKG_PROTOC_DIR} --cpp_out=${CPP_OUT} *.proto