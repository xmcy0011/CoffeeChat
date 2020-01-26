import 'dart:async';

import 'package:cc_flutter_app/page_lanuch.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

void collectLog(String line) {
  //收集日志
}

void reportErrorAndLog(FlutterErrorDetails details) {
  //上报错误和日志逻辑
  //Toast.show(msg, context)
}

FlutterErrorDetails makeDetails(Object obj, StackTrace stack) {
  var info = new FlutterErrorDetails(stack: stack);
  return info;
}

void main() {
   runApp(MyApp());

  // 捕获crash
//  bool isInDebugMode = true;
//  FlutterError.onError = (FlutterErrorDetails details) {
//    if (isInDebugMode) {
//      // In development mode simply print to console.
//      FlutterError.dumpErrorToConsole(details);
//    } else {
//      reportErrorAndLog(details);
//    }
//  };
//  runZoned(
//    () => runApp(MyApp()),
//    zoneSpecification: ZoneSpecification(
//      print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
//        collectLog(line); // 收集日志
//      },
//    ),
//    onError: (Object obj, StackTrace stack) {
//      var details = makeDetails(obj, stack);
//      reportErrorAndLog(details);
//    },
//  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "CoffeeChat",
      home: PageLaunchStatefulWidget(),
      theme: ThemeData(primaryColor: Colors.white),
    );
  }
}
