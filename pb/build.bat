# c++
protoc --cpp_out=. CIM.Def.proto
protoc --cpp_out=. CIM.Group.proto
protoc --cpp_out=. CIM.List.proto
protoc --cpp_out=. CIM.Login.proto
protoc --cpp_out=. CIM.Message.proto
protoc --cpp_out=. CIM.Voip.proto

# sync
move CIM.Def.pb.h ../client/win/include/libchat/pb
move CIM.Def.pb.cc ../client/win/include/libchat/pb

move CIM.Group.pb.h ../client/win/include/libchat/pb
move CIM.Group.pb.cc ../client/win/include/libchat/pb

move CIM.List.pb.h ../client/win/include/libchat/pb
move CIM.List.pb.cc ../client/win/include/libchat/pb

move CIM.Login.pb.h ../client/win/include/libchat/pb
move CIM.Login.pb.cc ../client/win/include/libchat/pb

move CIM.Message.pb.h ../client/win/include/libchat/pb
move CIM.Message.pb.cc ../client/win/include/libchat/pb

move CIM.Voip.pb.h ../client/win/include/libchat/pb
move CIM.Voip.pb.cc ../client/win/include/libchat/pb