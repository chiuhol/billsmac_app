import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:event_bus/event_bus.dart';
import 'package:oktoast/oktoast.dart';
import 'package:billsmac_app/Common/style/colors.dart';
import 'package:billsmac_app/Common/style/fonts.dart';

import '../BaseCommon.dart';
//import 'package:flutter_statusbar_manager/flutter_statusbar_manager.dart';

class CommonUtil {
  static const DEBUG = true;

  static final EventBus eventBus = new EventBus();

  static const Local_Icon_Prefix = "asset/images/";

//  static String getImage(String image,{String type : ".png"}) {
//    return Local_Icon_prefix + image + type;
//  }

  static double statusBarHeight = 0.0;

//  static Future initStatusBarHeight() async {
//    statusBarHeight = await FlutterStatusbarManager.getHeight;
//  }

  static openPage(BuildContext context, Widget widget) {
    return Navigator.push(
        context, new MaterialPageRoute(builder: (context) => widget));
  }

  static closePage(BuildContext context) {
    Navigator.pop(context);
  }

  static bool statusDeviceIsAndroidTablet = false;

  static initStatusDeviceIsAndroidTablet(value) {
    statusDeviceIsAndroidTablet = value;
  }

  static isPhoneNo(String phone) {
    if (phone == null) return false;

    phone = phone.trim();

    RegExp exp = RegExp(r'^1[0-9]{10}$');
    return exp.hasMatch(phone);
  }

  static isEmailAddress(String address) {
    if (address == null) return false;

    address = address.trim();

    RegExp exp = RegExp(r'^[a-z,A-Z,0-9]+@[a-z,A-Z]+.[a-z,A-Z]+$');
    return exp.hasMatch(address);
  }

  static isPasswordValid(String password) {
    if (password == null) return false;

    password = password.trim();
    RegExp exp = new RegExp(r'^[0-9a-zA-Z_]{6,16}$');
    return exp.hasMatch(password);
  }

  static isChineseValid(String chinese) {
    if (chinese == null) return false;

    chinese = chinese.trim();
    RegExp exp = RegExp(r'^[\u4e00-\u9fa5]{1,10}$');
    return exp.hasMatch(chinese);
  }

  static isBankAccountValid(String account) {
    if (account == null) return false;

    account = account.trim();
    RegExp exp = RegExp(r'^([1-9]{1})(\d{14}|\d{18})$');
    return exp.hasMatch(account);
  }

  static Future<Null> showLoadingDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return new Material(
              color: Colors.transparent,
              child: WillPopScope(
                  onWillPop: () => new Future.value(false),
                  child: Center(
                    child: new CupertinoActivityIndicator(),
                  )));
        });
  }

  static String removeDecimalZeroFormat(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 1);
  }

  static String getChatTime(int timeStamp, {bool deal: true}) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeStamp);
    if (BaseCommon.easeNowTime != null) {
      if ((timeStamp - BaseCommon.easeNowTime).abs() < 120000) {
        return null;
      }
    }
    if (deal) {
      BaseCommon.easeNowTime = timeStamp;
    }
    String timeHead = "";
    if (dateTime.day == DateTime.now().day) {
      if (dateTime.hour < 12) {
        timeHead = "上午";
      } else if (dateTime.hour < 18) {
        timeHead = "下午";
      } else {
        timeHead = "晚上";
      }
    } else if (dateTime.day == DateTime.now().subtract(Duration(days: 1)).day) {
      timeHead = "昨天";
    } else if (dateTime.year == DateTime.now().year) {
      timeHead = (dateTime.month.toString().padLeft(2, "0")) +
          "-" +
          (dateTime.day.toString().padLeft(2, "0"));
    } else {
      timeHead = (dateTime.month.toString().padLeft(2, "0")) +
          "-" +
          (dateTime.day.toString().padLeft(2, "0"));
      timeHead = dateTime.year.toString() + "-" + timeHead;
    }
    return timeHead +
        " " +
        (dateTime.hour.toString().padLeft(2, "0")) +
        ":" +
        (dateTime.minute.toString().padLeft(2, "0"));
  }

  static String getTimeDuration(String comTime) {
    var nowTime = DateTime.now();
    var compareTime = DateTime.parse(comTime);
    if (nowTime.isAfter(compareTime)) {
      if (nowTime.year == compareTime.year) {
        if (nowTime.month == compareTime.month) {
          if (nowTime.day == compareTime.day) {
            if (nowTime.hour == compareTime.hour) {
              if (nowTime.minute == compareTime.minute) {
                return '片刻之间';
              }
              return (nowTime.minute - compareTime.minute).toString() + '分钟前';
            }
            return (nowTime.hour - compareTime.hour).toString() + '小时前';
          }
          return (nowTime.day - compareTime.day).toString() + '天前';
        }
        return (nowTime.month - compareTime.month).toString() + '月前';
      }
      return (nowTime.year - compareTime.year).toString() + '年前';
    } else {
      return '片刻之间';
    }
  }

  //比较两个时间返回相差天数
  static int getDuration(String comTime) {
    var nowTime = DateTime.now();
    var compareTime = DateTime.parse(comTime);
    var difference = nowTime.difference(compareTime);
    return difference.inDays;
  }

  //金额格式化
  static String formatNum(num) {
    var point = 2;
    if (num != null) {
      String str = double.parse(num.toString()).toString();
      // 分开截取
      List<String> sub = str.split('.');
      // 处理值
      List val = List.from(sub[0].split(''));
      // 处理点
      List<String> points = List.from(sub[1].split(''));
      //处理分割符
      for (int index = 0, i = val.length - 1; i >= 0; index++, i--) {
        // 除以三没有余数、不等于零并且不等于1 就加个逗号
        if (index % 3 == 0 && index != 0 && i != 1) val[i] = val[i] + ',';
      }
      // 处理小数点
      for (int i = 0; i <= point - points.length; i++) {
        points.add('0');
      }
      //如果大于长度就截取
      if (points.length > point) {
        // 截取数组
        points = points.sublist(0, point);
      }
      // 判断是否有长度
      if (points.length > 0) {
        return '${val.join('')}.${points.join('')}';
      } else {
        return val.join('');
      }
    } else {
      return "0.0";
    }
  }

  static String hidePhone(String value) {
    if (value != '') {
      value = value.substring(0, value.length - (value.substring(3)).length) +
          "****" +
          value.substring(7);
    }

    return value;
  }

  static showMyToast(String msg,
      {ToastPosition myPosition = ToastPosition.center,
      Color myColor = MyColors.orange_68}) {
    showToast(msg, position: myPosition, backgroundColor: myColor);
  }

  static showLoginDialog(context, title) {
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
                content: Text('登陆之后才能' + title + '，你是否要先登陆？',
                    style: TextStyle(
                        fontSize: MyFonts.f_14, color: MyColors.black_33)),
                actions: <Widget>[
                  CupertinoDialogAction(
                      child: Text('取消',
                          style: TextStyle(
                              fontSize: MyFonts.f_14,
                              color: MyColors.black_33)),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  CupertinoDialogAction(
                      child: Text('确定',
                          style: TextStyle(
                              fontSize: MyFonts.f_14, color: MyColors.red_43)),
                      onPressed: () {
                        Navigator.pushNamed(context, '/Login_Page');
                      })
                ]));
  }

  static String getPlatForm() {
    String _platForm = '';

    if (Platform.isAndroid) {
      _platForm = 'Android';
    } else if (Platform.isIOS) {
      _platForm = 'IOS';
    }

    return _platForm;
  }

  static String getDate(String date) {
    if (date != '') {
      if (DateTime.now().year != int.parse(date.substring(0, 4))) {
        return date.substring(0, 10);
      } else {
        return date.substring(5, 10);
      }
    } else
      return '';
  }

  //取小数点后几位
  static formatNumber(double num,int postion){
    if((num.toString().length-num.toString().lastIndexOf(".")-1)<postion){
      //小数点后有几位小数
      return num.toStringAsFixed(postion).substring(0,num.toString().lastIndexOf(".")+postion+1).toString();
    }else{
      return  num.toString().substring(0,num.toString().lastIndexOf(".")+postion+1).toString();
    }
  }

  //随机颜色
  static Color slRandomColor({int r = 200, int g = 200, int b = 200, a = 200}) {
    if (r == 0 || g == 0 || b == 0) return Colors.black;
    if (a == 0) return Colors.white;
    return Color.fromARGB(
      a,
      r != 200 ? r : Random.secure().nextInt(r),
      g != 200 ? g : Random.secure().nextInt(g),
      b != 200 ? b : Random.secure().nextInt(b),
    );
  }
}
