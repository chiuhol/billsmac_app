import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:billsmac_app/Page/SplashPage.dart';
import 'package:billsmac_app/Page/HomeMainPage.dart';
import 'package:billsmac_app/Page/mine/MineMainPage.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Common/BaseCommon.dart';
import 'Common/local/LocalStorage.dart';
import 'Common/style/colors.dart';
import 'Common/util/ServiceLocator.dart';
import 'Page/LoginPage.dart';
import 'package:apifm/apifm.dart' as Apifm;
import 'package:device_info/device_info.dart';

///@Author:chiuhol
///2019-12-4

void main() => realRunApp();

void realRunApp() async {
  // 注册服务
  setupLocator();
  Apifm.init("72127a0f02f16488e7ccfa8cf76866be");
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _ImageUrl = "";

  @protected
  void loadData_dio_dioOfOptionsSetting(url) async {
    debugPrint(
        ' \n post请求 ======================= 开始请求 =======================\n');
    var headers = Map<String, String>();
    headers['loginSource'] = 'IOS';
    headers['useVersion'] = '3.1.0';
    headers['isEncoded'] = '1';
    headers['bundleId'] = 'com.nongfadai.iospro';
    headers['Content-Type'] = 'application/json';

    Dio dio = Dio();
    dio.options.baseUrl = url;
    dio.options.connectTimeout = 60000;
    dio.options.receiveTimeout = 60000;
    dio.options.headers.addAll(headers);
    dio.options.method = 'post';

    Options option = Options(method: 'post');
    // Response response = await dio.request(homeRegularListUrl,
    //     data: {"currentPage": "1"}, options: option);

    Response response = await dio.post(url,
        data: {"currentPage": "1"}, options: option);

    if (response.statusCode == HttpStatus.ok) {
      debugPrint('请求参数： ${response.request.queryParameters}');
      debugPrint(
          '-------------------请求成功,请求结果如下:-----------------\n \n===请求求url: ${response.request.uri.toString()} \n \n===请求 ���:   \n${response.headers} \n \n===请求结果: \n${response.data}\n');
      debugPrint('-------------------请求成功,请求结果打印完毕----------------');
      print(response.data["images"][0]["url"]);
      _ImageUrl = "https://cn.bing.com"+response.data["images"][0]["url"];
//      LocalStorage.save(BaseCommon.ImageUrl, _ImageUrl);
//      print(LocalStorage.get(BaseCommon.ImageUrl));
    } else {
      print('请求失败');
    }
  }

  @protected
  void getDeviceInfo() async{
    DeviceInfoPlugin deviceInfo = new DeviceInfoPlugin();
    if(Platform.isIOS){
      print('IOS设备：');
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print(iosInfo.name);
      print(iosInfo.identifierForVendor);
      LocalStorage.save("DeviceType", "ios");
      LocalStorage.save("DeviceName", iosInfo.name);
      LocalStorage.save("DeviceId", iosInfo.identifierForVendor);
    }else if(Platform.isAndroid){
      print('Android设备');
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print(androidInfo.id);
      print(androidInfo.device);
      LocalStorage.save("DeviceType", "android");
      LocalStorage.save("DeviceName", androidInfo.device);
      LocalStorage.save("DeviceId", androidInfo.id);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadData_dio_dioOfOptionsSetting("https://cn.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1");
    getDeviceInfo();//获取运行设备信息
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
        position: ToastPosition.bottom,
        backgroundColor: MyColors.button_bg_grey_deep,
      child: MaterialApp(
        title: 'Flutter Demo',
        routes: routes,
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: Splash(imageUrl: _ImageUrl),
      )
    );
  }
}

Map<String, WidgetBuilder> routes = {
  HomeMainPage.HOMEMAINPAGE: (context) => HomeMainPage(),
  MineMainPage.MINEMAINPAGE: (context) => MineMainPage(),
  LoginPage.LOGINPAGE: (context) => LoginPage(),
};
