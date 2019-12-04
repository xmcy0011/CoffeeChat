cp *.go ../server/src/api/cim/
rm -rf *.go

rm -rf Grpc*.dart
cp *.dart ../client/cc_flutter_app/lib/imsdk/proto
rm -rf *.dart