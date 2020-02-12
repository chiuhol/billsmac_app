import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:flutter/services.dart';

///Author:chiuhol
///2020-2-2

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: double.infinity,
            height: double.infinity,
            color: MyColors.grey_f6,
            child: Column(children: <Widget>[
              Container(
                  padding: EdgeInsets.only(top: 45, bottom: 18),
                  color: MyColors.white_fe,
                  child: Row(
                      children: <Widget>[
                    GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          CommonUtil.closePage(context);
                        },
                        child: Icon(
                          Icons.keyboard_arrow_left,
                          size: 30,
                          color: MyColors.black_32,
                        )),
                        Padding(
                          padding: EdgeInsets.only(left: 150),
                          child: Text('重置密码',
                              style: TextStyle(
                                  color: MyColors.black_32, fontSize: MyFonts.f_15))
                        )
                  ])),
              Container(
                  width: double.infinity, height: 1, color: MyColors.divider),
              resetPassword(),
              Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                    top: 30,
                  ),
                  child: new Material(
                      child: new Ink(
                          decoration: new BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                MyColors.orange_b8,
                                MyColors.orange_ab
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          child: new InkWell(
                              borderRadius: new BorderRadius.circular(25.0),
                              onTap: () {},
                              child: Container(
                                  alignment: Alignment(0, 0),
                                  height: 45,
                                  width: 320,
                                  child: Text(
                                    '完成',
                                    style: TextStyle(
                                        color: MyColors.white_fe,
                                        fontSize: MyFonts.f_16),
                                  ))))))
            ])));
  }

  Widget resetPassword() {
    return Container(
        padding: EdgeInsets.only(left: 18),
        color: MyColors.white_fe,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: TextField(
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '请输入手机号码',
                    hintStyle: TextStyle(
                      fontSize: MyFonts.f_14,
                      color: MyColors.grey_cb,
                    ),
                    border: InputBorder.none,
                  ),
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  onChanged: (value) {
//                  this.setState(() {
//                    this._usingDegree = value;
//                  });
                  })),
          SeparatorWidget(),
          Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                        width: 200,
                        child: TextField(
                            maxLines: 1,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: '请输入验证码',
                              hintStyle: TextStyle(
                                fontSize: MyFonts.f_14,
                                color: MyColors.grey_cb,
                              ),
                              border: InputBorder.none,
                            ),
                            inputFormatters: [
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            onChanged: (value) {
//                  this.setState(() {
//                    this._usingDegree = value;
//                  });
                            })),
                    Container(
                      padding: EdgeInsets.only(right: 8),
                        child: new Material(
                            child: new Ink(
                                decoration: new BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      MyColors.orange_b8,
                                      MyColors.orange_ab
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                child: new InkWell(
                                    borderRadius:
                                        new BorderRadius.circular(25.0),
                                    onTap: () {},
                                    child: Container(
                                        alignment: Alignment(0, 0),
                                        height: 26,
                                        width: 80,
                                        child: Text(
                                          '获取验证码',
                                          style: TextStyle(
                                              color: MyColors.white_fe,
                                              fontSize: MyFonts.f_12),
                                        ))))))
                  ])),
          SeparatorWidget(),
          Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: TextField(
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '请设置新的密码',
                    hintStyle: TextStyle(
                      fontSize: MyFonts.f_14,
                      color: MyColors.grey_cb,
                    ),
                    border: InputBorder.none,
                  ),
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  onChanged: (value) {
//                  this.setState(() {
//                    this._usingDegree = value;
//                  });
                  })),
          SeparatorWidget(),
          Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8),
              child: TextField(
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '请再次输入密码',
                    hintStyle: TextStyle(
                      fontSize: MyFonts.f_14,
                      color: MyColors.grey_cb,
                    ),
                    border: InputBorder.none,
                  ),
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  onChanged: (value) {
//                  this.setState(() {
//                    this._usingDegree = value;
//                  });
                  })),
        ]));
  }
}
