# go
cp *.go ../server/src/api/cim/
rm -rf *.go

# flutter-client
rm -rf Grpc*.dart
mv *.dart ../client/cc_flutter_app/lib/imsdk/proto

# ios
rm -rf Grpc*.swift
mv *.swift ../client/ios/Coffchat/Coffchat/CIMSdk/pb/