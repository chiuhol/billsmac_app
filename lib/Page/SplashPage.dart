import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:billsmac_app/Common/CommonInsert.dart';
import 'dart:async';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'LoginPage.dart';

///@Author:chiuhol
///2019-12-4

class Splash extends StatefulWidget {
  final String imageUrl;

  Splash({this.imageUrl});

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  var _version;
  bool _pageState;
  SharedPreferences _sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return new Material(
        child: new Scaffold(
            body: new Stack(children: <Widget>[
      Image.network(
          "https://cn.bing.com/th?id=OHR.ArgaosRidge_ZH-CN1737206146_1920x1080.jpg&rf=LaDigue_1920x1080.jpg&pid=hp",
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover),
      new Container(
          alignment: Alignment.topRight,
          padding: const EdgeInsets.fromLTRB(0.0, 45.0, 10.0, 0.0),
          child: OutlineButton(
              child: new Text(
                "跳过",
                textAlign: TextAlign.center,
                style: new TextStyle(color: Colors.green),
              ),
              // StadiumBorder椭圆的形状
              shape: new StadiumBorder(),
              onPressed: () {
                go2HomePage();
              }))
    ])));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    countDown();
  }

  // 倒计时
  void countDown() {
    var _duration = new Duration(seconds: 5);
    new Future.delayed(_duration, go2HomePage);
  }

  void go2HomePage() {
    Navigator.pushReplacementNamed(context, '/Login_Page');
//    Navigator.pushReplacementNamed(context, '/HomeMain_Page');
  }

  ///
  ///     判断是否展示过引导页
  ///
  Future<dynamic> _checkState() async {
    //获取当前App的版本信息
    PackageInfo info = await PackageInfo.fromPlatform();
    _version = info.version;

    //获取SharedPreferences
    _sharedPreferences = await SharedPreferences.getInstance();

    print("app版本：${_version}");
    print("展示过引导页：${_sharedPreferences.get(_version)}");

    if (_sharedPreferences == null || _version == null) {
      return null;
    }
    //查询当前版本是否展示过引导页，展示过返回true，否则返回false
    if (_sharedPreferences.get(_version) == null) {
      _sharedPreferences.setBool(_version, false);
      return false;
    }

    if (_sharedPreferences.get(_version) == false) {
      return false;
    }

    return true;
  }

  ///
  ///     展示页面
  ///
  Future<Widget> _showPage() async {
    _pageState = await _checkState();
//    _isHA = LocalStorage.get('HA');

    //未收到检查结果继续展示启动页
    if (_pageState == null) {
      return Splash();
    }

//    if (_pageState == false && _isHA == 'Yes') {
//      return GuidePage(list, _changeState, _hangAround);
//    }

    //已展示过引导页直接进入主页
    if (_pageState) {
      return LoginPage();
    } else {
//      return GuidePage(list, _changeState, _hangAround);
    }
  }

  ///
  ///     回调函数用于点击进入应用后改变状态
  ///
  void _changeState() {
    print("立即启动");
    _sharedPreferences.setBool(_version, true);

    print(_sharedPreferences.get(_version));
  }
}
