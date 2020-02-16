import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:flutter/gestures.dart';
import 'package:apifm/apifm.dart' as Apifm;
import 'package:flutter/services.dart';

import 'VerificationCodePage.dart';

///Author:chiuhol
///2020-2-2

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _photoController = TextEditingController();

  void getCode() async {
    if (!CommonUtil.isPhoneNo(_phoneController.text)) {
      CommonUtil.showMyToast("请输入正确的手机号码");
      return;
    }
    _photoController.text = '';
    var res = await Apifm.graphValidateCodeUrl();
    if (res != null) {
      _photoCheck(res["key"], res["imageUrl"]);
    }
  }

  @protected
  _photoCheck(String key, String url) async {
    await showDialog(
        context: context,
        barrierDismissible: true,
        child: new SimpleDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            backgroundColor: MyColors.orange_68,
            title: Container(
                margin: EdgeInsets.only(left: 80, bottom: 8),
                child: Text('进行图片验证',
                    style: TextStyle(
                        color: MyColors.white_fe, fontSize: MyFonts.f_14))),
            contentPadding: const EdgeInsets.all(10.0),
            children: <Widget>[
              Image.network(url, width: 100, height: 100, fit: BoxFit.fill),
              Container(
                  padding: EdgeInsets.only(left: 18, right: 18),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            width: 150,
                            child: TextField(
                                maxLines: 1,
                                controller: _photoController,
                                cursorColor: MyColors.white_fe,
                                style: TextStyle(
                                    color: MyColors.white_fe,
                                    fontSize: MyFonts.f_18),
                                decoration: InputDecoration(
                                    hintText: '请输入图片验证码',
                                    hintStyle: TextStyle(
                                      fontSize: MyFonts.f_16,
                                      color: MyColors.white_fe,
                                    ),
                                    border: InputBorder.none))),
                        GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () async {
                              if (_photoController.text == '') {
                                CommonUtil.showMyToast("请输入图片验证码");
                                return;
                              }
                              CommonUtil.closePage(context);
                              Apifm.smsValidateCode(_phoneController.text,key,_photoController.text)
                                  .then((res) {
                                if (res["code"] == 0) {
                                  CommonUtil.openPage(
                                      context,
                                      VerificationCodePage(
                                          _phoneController.text));
                                } else {
                                  CommonUtil.showMyToast(res["msg"]);
                                }
                              });
                            },
                            child: Text("确定",
                                style: TextStyle(
                                    color: MyColors.white_fe,
                                    fontSize: MyFonts.f_16,
                                    fontWeight: FontWeight.bold)))
                      ]))
            ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      new Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [MyColors.orange_76, MyColors.orange_62],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: SingleChildScrollView(
              physics: BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              child: Column(children: <Widget>[
                new Container(
                    padding: EdgeInsets.only(top: 100.0, bottom: 10.0),
                    alignment: Alignment.center,
                    child: new Text(
                      '欢迎加入每日记账',
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(color: MyColors.white_fe, fontSize: 30.0),
                    )),
                SizedBox(height: 12),
                new Container(
                    padding: EdgeInsets.only(
                        top: 16, left: 16, right: 16, bottom: 45),
                    margin: EdgeInsets.only(left: 16, right: 16),
                    decoration: BoxDecoration(
                        color: MyColors.white_fe,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(children: <Widget>[
                      new Container(
                          decoration: new BoxDecoration(
                              border: new Border(
                                  bottom: BorderSide(
                                      color: Color.fromARGB(255, 240, 240, 240),
                                      width: 1.0))),
                          child: new TextFormField(
                              controller: _phoneController,
                              cursorColor: MyColors.orange_68,
                              decoration: new InputDecoration(
                                  hintText: '请输入手机号',
                                  hintStyle: TextStyle(
                                      fontSize: 15.0, color: MyColors.grey_cb),
                                  border: InputBorder.none,
                                  suffixIcon: new IconButton(
                                      icon: GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            setState(() {
                                              _phoneController.text = '';
                                            });
                                          },
                                          child: Icon(
                                            Icons.close,
                                            color: MyColors.grey_cb,
                                          )))),
                              keyboardType: TextInputType.phone,
                              onFieldSubmitted: (value) {})),
                      new Container(
                          height: 45.0,
                          margin: EdgeInsets.only(top: 40.0),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(45)),
                              gradient: LinearGradient(
                                colors: [
                                  MyColors.orange_b8,
                                  MyColors.orange_ab
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              )),
                          child: new SizedBox.expand(
                              child: new RaisedButton(
                            onPressed: getCode,
                            color: Colors.transparent,
                            elevation: 0,
                            // 正常时阴影隐藏
                            highlightElevation: 0,
                            child: new Text('获取验证码',
                                style: TextStyle(
                                    fontSize: 14.0, color: MyColors.white_fe)),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(45.0)),
                          )))
                    ])),
                new Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 150),
                    child: Column(children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: 80,
                              height: 1,
                              color: MyColors.orange_96,
                            ),
                            Padding(
                                padding: EdgeInsets.only(left: 38, right: 38),
                                child: Text('其他注册方式',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: MyColors.white_fe,
                                        fontSize: MyFonts.f_14))),
                            Container(
                              width: 80,
                              height: 1,
                              color: MyColors.orange_96,
                            ),
                          ]),
                      Padding(
                          padding: EdgeInsets.only(top: 50),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(IconData(0xe6ea, fontFamily: 'MyIcons'),
                                    size: 30, color: MyColors.white_fe),
                                SizedBox(width: 50),
                                Icon(IconData(0xe50b, fontFamily: 'MyIcons'),
                                    size: 30, color: MyColors.white_fe)
                              ]))
                    ])),
                new Container(
                    padding: EdgeInsets.only(top: 30, bottom: 60),
                    alignment: Alignment.center,
                    child: RichText(
                        text: TextSpan(
                            text: '我已阅读并同意',
                            style: TextStyle(
                                color: MyColors.white_fe,
                                fontSize: MyFonts.f_12),
                            children: <TextSpan>[
                          TextSpan(
                              text: '服务协议',
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  print('点击了服务条款');
                                },
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  color: MyColors.white_fe,
                                  fontSize: MyFonts.f_12))
                        ])))
              ]))),
      Positioned(
        top: 38,
        left: 16,
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              CommonUtil.closePage(context);
            },
            child: Icon(
              Icons.keyboard_arrow_left,
              size: 30,
              color: MyColors.white_fe,
            )),
      )
    ]));
  }
}
