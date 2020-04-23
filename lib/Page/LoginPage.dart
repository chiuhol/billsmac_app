import 'dart:convert';

import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Common/local/LocalStorage.dart';
import 'package:billsmac_app/Page/RegisterPage.dart';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;

import 'ResetPasswordPage.dart';
import 'package:apifm/apifm.dart' as Apifm;

///Author:chiuhol
///2020-2-2

class LoginPage extends StatefulWidget {
  static final String LOGINPAGE = '/Login_Page';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  GlobalKey<FormState> loginKey = new GlobalKey<FormState>();
  String userName;
  String password;
  bool isShowPassWord = false;

  TextEditingController _phoneController = TextEditingController();

  void login() async {
    //读取当前的Form状态
    var loginForm = loginKey.currentState;
    //验证Form表单
    if (loginForm.validate()) {
      loginForm.save();
      if (userName == '') {
        CommonUtil.showMyToast("请输入手机号");
        return;
      }
      if (password == '') {
        CommonUtil.showMyToast("请输入密码");
        return;
      }
//      String _deviceId = await LocalStorage.get("DeviceId").then((result) {
//        return result;
//      });
//      String _deviceName = await LocalStorage.get("DeviceName").then((result) {
//        return result;
//      });
      try {
        http.Response res = await http.post(Address.login(),
            body: {"phone": userName, "password": password});
        print(jsonDecode(res.body));
        if (jsonDecode(res.body)["status"] == 200) {
          LocalStorage.save("token", jsonDecode(res.body)["data"]["token"]);
          var _user = jsonDecode(res.body)["data"]["user"];
          LocalStorage.save("nikeName", _user["nikeName"]??"");
          LocalStorage.save("gender", _user["gender"]??"");
          LocalStorage.save("_id", _user["_id"]??"");
          LocalStorage.save("identity", _user["identity"]??"");
          LocalStorage.save("birth", _user["birth"]??"");
          LocalStorage.save("locations", _user["locations"]??"");
          if(_user["avatar_url"] != null && _user["avatar_url"] != ''){
            LocalStorage.save(
                "avatar_url", _user["avatar_url"].toString().substring(21));
          }
          LocalStorage.save("remindTime", _user["remindTime"]??"");
          LocalStorage.save("phone", _user["phone"]??"");
          if(_user["isManager"]){
            Navigator.pushReplacementNamed(context, '/ManagerMain_Page');
          }else{
            Navigator.pushReplacementNamed(context, '/HomeMain_Page');
          }
        } else {
          print(jsonDecode(res.body)["message"]);
          CommonUtil.showMyToast(jsonDecode(res.body)["message"]);
        }
      } catch (err) {
        CommonUtil.showMyToast("系统开小差了~");
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
        body: new Container(
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
                        'Hi，欢迎你回来',
                        textAlign: TextAlign.left,
                        style:
                            TextStyle(color: MyColors.white_fe, fontSize: 30.0),
                      )),
                  SizedBox(height: 12),
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
                                            color: Color.fromARGB(
                                                255, 240, 240, 240),
                                            width: 1.0))),
                                child: new TextFormField(
                                    controller: _phoneController,
                                    cursorColor: MyColors.orange_68,
                                    decoration: new InputDecoration(
                                      hintText: '请输入手机号',
                                      hintStyle: TextStyle(
                                          fontSize: 15.0,
                                          color: MyColors.grey_cb),
                                      border: InputBorder.none,
                                      prefixIcon: Icon(
                                          IconData(0xe620,
                                              fontFamily: 'MyIcons'),
                                          size: 15,
                                          color: MyColors.grey_cb),
                                      suffixIcon: new IconButton(
                                        icon: new Icon(Icons.close,
                                            color: Color.fromARGB(
                                                255, 126, 126, 126)),
                                        onPressed: () {
                                          setState(() {
                                            WidgetsBinding.instance
                                                .addPostFrameCallback((_) =>
                                                    _phoneController.clear());
                                          });
                                        },
                                      ),
                                    ),
                                    keyboardType: TextInputType.phone,
                                    onSaved: (value) {
                                      userName = value;
                                    })),
                            new Container(
                                decoration: new BoxDecoration(
                                    border: new Border(
                                        bottom: BorderSide(
                                            color: Color.fromARGB(
                                                255, 240, 240, 240),
                                            width: 1.0))),
                                child: new TextFormField(
                                    cursorColor: MyColors.orange_68,
                                    decoration: new InputDecoration(
                                        hintText: '请输入密码',
                                        hintStyle: TextStyle(
                                            fontSize: 15.0,
                                            color: MyColors.grey_cb),
                                        border: InputBorder.none,
                                        prefixIcon: Icon(
                                            IconData(0xe626,
                                                fontFamily: 'MyIcons'),
                                            size: 15,
                                            color: MyColors.grey_cb),
                                        suffixIcon: new IconButton(
                                          icon: new Icon(
                                            isShowPassWord
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Color.fromARGB(
                                                255, 126, 126, 126),
                                          ),
                                          onPressed: showPassWord,
                                        )),
                                    obscureText: !isShowPassWord,
                                    onSaved: (value) {
                                      password = value;
                                    })),
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
                                  // 点击时阴影隐藏
                                  child: new Text('登录',
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          color: MyColors.white_ee)),
                                  shape: new RoundedRectangleBorder(
                                      borderRadius:
                                          new BorderRadius.circular(45.0)),
                                ))),
                            new Container(
                                margin: EdgeInsets.only(top: 30.0),
                                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                                child: new Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            CommonUtil.openPage(
                                                context, ResetPasswordPage());
                                          },
                                          child: Text('忘记密码',
                                              style: TextStyle(
                                                  fontSize: 13.0,
                                                  color: MyColors.black_32))),
                                      GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            CommonUtil.openPage(
                                                context, RegisterPage());
                                          },
                                          child: Text('没有账号？去注册',
                                              style: TextStyle(
                                                  fontSize: 13.0,
                                                  color: MyColors.black_32)))
                                    ]))
                          ]))),
                  new Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(top: 60),
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
                                  child: Text('其他登录方式',
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
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: (){
                                      CommonUtil.showMyToast("功能暂未开放~");
                                    },
                                    child: Icon(IconData(0xe6ea, fontFamily: 'MyIcons'),
                                        size: 30, color: MyColors.white_fe)
                                  ),
                                  SizedBox(width: 50),
                                  GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: (){
                                      CommonUtil.showMyToast("功能暂未开放~");
                                    },
                                    child: Icon(IconData(0xe50b, fontFamily: 'MyIcons'),
                                        size: 30, color: MyColors.white_fe)
                                  )
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
                ]))));
  }
}
