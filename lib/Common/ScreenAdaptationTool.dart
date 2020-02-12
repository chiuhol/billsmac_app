import 'dart:ui';

import 'package:flutter/material.dart';

///@Author:chiuhol
///2019-12-4

///
/// 计算公式：实际尺寸 = UI尺寸 * 设备宽度/设计图宽度
/// 计算公式：实际尺寸 = UI尺寸 * 设备宽度/设计图宽度
///
class Adapt {
  static MediaQueryData _mediaQueryDate ;
  static double _width ; //获取屏幕宽度
  static double _height ; //获取屏幕高度
  static double _topBarHeight ; //获取状态栏高度
  static double _bottomBarHeight  ; //获取底部工具栏高度
  static double _pixelRatio ; //获取像素比
  static double _ratio ; ///适配比率，[375为设计稿宽度]

  ///初始化屏幕适配工具  [designWidth]为设计稿的宽度
  static init() {

    _mediaQueryDate = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    _width = _mediaQueryDate.size.width; //获取屏幕宽度
    _height = _mediaQueryDate.size.height; //获取屏幕高度
    _topBarHeight = _mediaQueryDate.padding.top; //获取状态栏高度
    _bottomBarHeight = _mediaQueryDate.padding.bottom; //获取底部工具栏高度
    _pixelRatio = _mediaQueryDate.devicePixelRatio; //获取像素比
    _ratio = _width / 375;

    print(WidgetsBinding.instance.window.devicePixelRatio);
    print("$_mediaQueryDate   $_width   $_height    $_topBarHeight    $_bottomBarHeight   $_pixelRatio    $_ratio");  }

  ///获取对应的尺寸  [uiSize]为UI的长度或宽度
  static dp(uiSize) {
    return uiSize * _ratio;
  }

  ///获取一个像素
  static onepx() {
    return 1 / _pixelRatio;
  }

  ///获取屏幕宽度
  static screenW() {
    return _width;
  }

  ///获取屏幕高度
  static screenH() {
    return _height;
  }

  ///获取屏幕顶部状态栏高度
  static topBarHeight() {
    return _topBarHeight;
  }

  ///获取屏幕底部工具类高度
  static bottomBarHeight() {
    return _bottomBarHeight;
  }
}
