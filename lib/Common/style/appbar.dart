import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:billsmac_app/Common/CommonInsert.dart';

import 'colors.dart';

class MyDimens {
  ///标题栏高度
  static const double title_height = 50.0;

  ///标题字体大小
  static const double title_size = 18.0;

  ///标题左侧Icon大小
  static const double title_left_size = 25.0;

  ///一般线宽
  static const double line = 1.0;

  ///一般间距
  static const double margin = 15.0;

  ///一般列表item间距
  static const double item_margin = 10.0;

  ///输入框上下边距
  static const double input_text_margin = 5.0;

  ///列表item字体大小
  static const double list_font_size = 17.0;

  ///一般字体大小
  static const double font_size = 18.0;

  ///按钮字体大小
  static const double button_size = 20.0;

  ///item Padding间距
  static const double item_padding_margin = 15.0;
}

class TextStyles {
  static TextStyle titleRightStyle = TextStyle(
    fontSize: MyDimens.title_size,
    color: MyColors.black_33,
  );

  static TextStyle titleStyle = TextStyle(
      fontSize: MyDimens.title_size,
      color: MyColors.black_33,
      fontWeight: FontWeight.bold);

  static TextStyle titleStyleWhite = TextStyle(
      fontSize: MyDimens.title_size,
      color: MyColors.white,
      fontWeight: FontWeight.bold);
}

///无标题栏有状态栏样式
class MyEmptyAppBar extends StatelessWidget implements PreferredSizeWidget {
  MyEmptyAppBar({Key key, this.isDark: false}) : super(key: key);
  final bool isDark; //是否暗色调  暗色调标题和状态栏为白色

  @override
  Widget build(BuildContext context) {
    return new AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: new SafeArea(
        top: true,
        child: new Container(),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(0);
}

///标题栏样式
class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  MyAppBar({
    Key key,
    @required this.title,
    this.isBack: false,
    this.rightEvent: const SizedBox(),
    this.isTransparent: false,
    this.color: MyColors.green_8d,
    this.backIcon,
    this.backEvent,
    this.bottom,
    this.bottomHeight: MyDimens.title_height,
    this.isDark: false,
    this.btnList: null,
    this.backTitle
  })  : assert(title != null),
        super(key: key);
  final String title; //标题
  final bool isBack; //是否有返回箭头
  final Widget rightEvent; //右侧按钮
  final bool isTransparent; //标题栏是否透明
  final Color color; //标题背景色
  final Widget backIcon; //返回箭头Icon
  final Function backEvent; //可以定义返回事件，要返回值的时候定义
  final Widget bottom; //是否有下边框
  final double bottomHeight; //下边框高度，定义了bottom才有效
  final bool isDark; //是否暗色调  暗色调标题和状态了为白色
  final Widget btnList; //标题是否是按钮组
  final String backTitle;//返回标题

  @override
  State<StatefulWidget> createState() => new MyAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(bottom == null
      ? MyDimens.title_height
      : MyDimens.title_height + bottomHeight);
}

class MyAppBarState extends State<MyAppBar> {
  void _backNavigator() {
    if (widget.backEvent != null) {
      widget.backEvent();
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: widget.isDark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Container(
        color: widget.isTransparent ? MyColors.transparent : widget.color,
        child: new SafeArea(
          top: true,
          child: new Stack(
            children: <Widget>[
              Positioned(
                left: MyDimens.margin,
                height: MyDimens.title_height,
                child: widget.backTitle == null?Offstage(
                  offstage: !widget.isBack,
                  child: GestureDetector(
                    onTap: widget.isBack ? _backNavigator : () => {},
                    child: widget.backIcon == null
                        ? widget.isDark
                            ? Container(
                                width: 50,
                                color: MyColors.black_33,
                                alignment: Alignment.centerLeft,
                                child: Icon(Icons.keyboard_arrow_left,color: MyColors.white_ff,size: 14),
                              )
                            : Container(
                                width: 50,
                                color: widget.color,
                                alignment: Alignment.centerLeft,
                                child: Icon(Icons.keyboard_arrow_left,color: MyColors.white_ff,size: 14)
                              )
                        : widget.backIcon,
                  ),
                ):Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        CommonUtil.closePage(context);
                      },
                      child: Text(widget.backTitle,
                          style: TextStyle(
                              color: MyColors.black_32, fontSize: MyFonts.f_16))
                  )
                ),
              ),
              Positioned(
                  right: MyDimens.margin,
                  height: MyDimens.title_height,
                  child: Center(
                    child: widget.rightEvent,
                  )),
              widget.btnList == null? Positioned(
                height: MyDimens.title_height,
                left: 0,
                right: 0,
                child: Center(
                  child: Text(widget.title,
                      style: widget.isDark
                          ? TextStyles.titleStyleWhite
                          : TextStyle(
                          fontSize: MyDimens.title_size,
                          color: MyColors.black_33,
                          fontWeight: FontWeight.bold))//titleStyle
                ),
              ): Positioned(
                height: MyDimens.title_height,
                left: 0,
                right: 0,
                child: Center(
                   child: widget.btnList,
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: new Offstage(
                  offstage: widget.isTransparent,
                  child: widget.bottom == null
                      ? new Container(
                          width: double.maxFinite,
                          height: MyDimens.line,
                          color: MyColors.transparent,
                        )
                      : new Container(
                          width: double.maxFinite,
                          height: widget.bottomHeight,
                          child: Center(
                            child: widget.bottom,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
