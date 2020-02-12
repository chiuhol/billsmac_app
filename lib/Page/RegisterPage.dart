import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:flutter/gestures.dart';

///Author:chiuhol
///2020-2-2

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> loginKey = new GlobalKey<FormState>();
  String userName;
  String password;
  bool isShowPassWord = false;

  void login() {
    //读取当前的Form状态
    var loginForm = loginKey.currentState;
    //验证Form表单
    if (loginForm.validate()) {
      loginForm.save();
      print('userName: ' + userName + ' password: ' + password);
      if (userName == '18312108986' && password == '123456') {
        Navigator.pushReplacementNamed(context, '/HomeMain_Page');
      } else {
        CommonUtil.showMyToast('账户名或密码错误');
      }
    }
  }

  void showPassWord() {
    setState(() {
      isShowPassWord = !isShowPassWord;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      new Container(
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
                new Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: EdgeInsets.only(left: 16, right: 16),
                    decoration: BoxDecoration(
                        color: MyColors.white_fe,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Form(
                        key: loginKey,
                        autovalidate: true,
                        child: new Column(children: <Widget>[
                          new Container(
                            decoration: new BoxDecoration(
                                border: new Border(
                                    bottom: BorderSide(
                                        color:
                                            Color.fromARGB(255, 240, 240, 240),
                                        width: 1.0))),
                            child: new TextFormField(
                              decoration: new InputDecoration(
                                hintText: '请输入手机号',
                                hintStyle: TextStyle(
                                    fontSize: 15.0, color: MyColors.grey_cb),
                                border: InputBorder.none,
                                suffixIcon: new IconButton(
                                  icon: new Icon(
                                    Icons.close,
                                    color: MyColors.grey_cb,
                                  ),
                                  onPressed: () {
                                    setState(() {});
                                  },
                                ),
                              ),
                              keyboardType: TextInputType.phone,
                              onSaved: (value) {
                                userName = value;
                              },
                              onFieldSubmitted: (value) {},
                            ),
                          ),
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
                                onPressed: login,
                                color: Colors.transparent,
                                elevation: 0,
                                // 正常时阴影隐藏
                                highlightElevation: 0,
                                child: new Text('获取验证码',
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        color: MyColors.white_fe)),
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(45.0)),
                              )))
                        ]))),
                new Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 180),
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
