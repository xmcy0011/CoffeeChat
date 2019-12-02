import 'package:cc_flutter_app/imsdk/core/dao/session_db_provider.dart';
import 'package:cc_flutter_app/imsdk/core/dao/sql_manager.dart';

/// DAO类使用例子

init() {
  SQLManager.init();
}

insert() async {
  SessionDbProvider provider = new SessionDbProvider();
//  UserModel userModel = UserModel();
//  userModel.id = 1143824942687547394;
//  userModel.mobile = "15801071158";
//  userModel.headImage = "http://www.img";
//  provider.insert(userModel);
}

update() async {
  SessionDbProvider provider = new SessionDbProvider();
//  UserModel userModel = await provider.getPersonInfo(1143824942687547394);
//  userModel.mobile = "15801071157";
//  userModel.headImage = "http://www.img1";
//  provider.update(userModel);
}

unInit() {
  SQLManager.close();
}
