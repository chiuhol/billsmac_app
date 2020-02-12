import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';

///@author chiuhol

///预设图片选择工具，用于判断当前平台和当前手机屏幕密度获取适应的图片资源
class LocalImageSelecter {
  static double dpi = MediaQueryData.fromWindow(window).devicePixelRatio; //屏幕密度
  static int platform = Platform.isAndroid ? 1 : 2; //1、安卓 2、苹果
  static String basePath;
  static String postfix;

  static const Local_Icon_prefix = "asset/images/";

  static init() {
    print("当前的屏幕密度为:$dpi");
    if (platform == 1) {
      print("当前设备为Android");
      postfix = ".png";
      if (dpi < 1) {
        basePath = Local_Icon_prefix + "android/drawable-mdpi/";
      } else if (dpi < 1.5) {
        basePath = Local_Icon_prefix + "android/drawable-hdpi/";
      } else if (dpi < 2) {
        basePath = Local_Icon_prefix + "android/drawable-xhdpi/";
      } else if (dpi < 3) {
        basePath = Local_Icon_prefix + "android/drawable-xxhdpi/";
      } else {
        basePath = Local_Icon_prefix + "android/drawable-xxxhdpi/";
      }
//      basePath="assets/images/android/drawable-xxxhdpi/";

    } else {
      basePath = Local_Icon_prefix + "ios/";
      if (dpi < 1.5) {
        postfix = ".png";
      } else if (dpi < 2.5) {
        postfix = "@2x.png";
      } else {
        postfix = "@3x.png";
      }
//      postfix="@3x.png";
    }
    print(basePath);
  }

  static Image getImage(String imageName,
      {double imageWidth,
      double imageHeight,
      bool bFitFill = true,
      Color imageColor}) {
    return Image.asset(basePath + imageName + postfix,
        width: imageWidth,
        height: imageHeight,
        color: imageColor,
        fit: bFitFill ? BoxFit.fill : BoxFit.scaleDown);
  }

  static String imagePath(String imageName) {
    return basePath + imageName + postfix;
  }

  static getBackgroundImage(String imageName) {
    return AssetImage(basePath + imageName + postfix);
  }

  static Image getLaunchOrGuideImage(String imageName) {
    return Image.asset(Local_Icon_prefix + imageName +".png");
  }
}
