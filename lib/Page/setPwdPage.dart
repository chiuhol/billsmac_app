import 'dart:convert';

import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:apifm/apifm.dart' as Apifm;
import 'package:billsmac_app/Common/local/LocalStorage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'HomeMainPage.dart';

///Author:chiuhol
///2020-2-2

class setPwdPage extends StatefulWidget {
  final String phoneNum;
  final String code;

  setPwdPage({this.phoneNum, this.code});

  @override
  _setPwdPageState createState() => _setPwdPageState();
}

class _setPwdPageState extends State<setPwdPage> {
  TextEditingController _pwdController = TextEditingController();
  TextEditingController _againPwdController = TextEditingController();

  void login() async {
    try {
      http.Response res = await http.post(Address.login(),
          body: {"phone": widget.phoneNum, "password": _againPwdController.text});
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
        Navigator.pushReplacementNamed(context, '/HomeMain_Page');
      } else {
        print(jsonDecode(res.body)["message"]);
        CommonUtil.showMyToast(jsonDecode(res.body)["message"]);
      }
    } catch (err) {
      CommonUtil.showMyToast("系统开小差了~");
    }
  }

  @protected
  _submit() async {
    if (_pwdController.text == '') {
      CommonUtil.showMyToast("请输入密码");
      return;
    }
    if(_pwdController.text.length > 12 || _pwdController.text.length < 6){
      CommonUtil.showMyToast("密码长度规定为6-12位");
      return;
    }
    if (_pwdController.text != _againPwdController.text) {
      CommonUtil.showMyToast("两次密码输入不一致");
      return;
    }
    var res2 = await Apifm.register_mobile({
      "code": widget.code,
      'mobile': widget.phoneNum,
      'pwd': _againPwdController.text
    });
    if (res2["code"] == 0) {
      try {
        BaseOptions options = BaseOptions(method: "post");
        var dio = new Dio(options);
        var response = await dio.post(Address.createUser(), data: {
          "phone": widget.phoneNum,
          "password": _againPwdController.text
        });
        print(response.data.toString());
        if (response.data["status"] == 200) {
          CommonUtil.showMyToast("注册成功");
          login();
        }
      } catch (err) {
        print(err.toString());
        CommonUtil.showMyToast("系统开小差了~");
      }
    } else {
      CommonUtil.showMyToast(res2["msg"]);
    }
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
                      '设置你的密码',
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
                              controller: _pwdController,
                              cursorColor: MyColors.orange_68,
                              keyboardType: TextInputType.visiblePassword,
                              decoration: new InputDecoration(
                                  hintText: '请输入密码',
                                  hintStyle: TextStyle(
                                      fontSize: 15.0, color: MyColors.grey_cb),
                                  border: InputBorder.none,
                                  suffixIcon: new IconButton(
                                      icon: GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            setState(() {
                                              _pwdController.text = '';
                                            });
                                          },
                                          child: Icon(
                                            Icons.close,
                                            color: MyColors.grey_cb,
                                          )))),
                              onFieldSubmitted: (value) {})),
                      SizedBox(height: 12),
                      new Container(
                          decoration: new BoxDecoration(
                              border: new Border(
                                  bottom: BorderSide(
                                      color: Color.fromARGB(255, 240, 240, 240),
                                      width: 1.0))),
                          child: new TextFormField(
                              controller: _againPwdController,
                              keyboardType: TextInputType.visiblePassword,
                              cursorColor: MyColors.orange_68,
                              decoration: new InputDecoration(
                                  hintText: '请再次输入密码',
                                  hintStyle: TextStyle(
                                      fontSize: 15.0, color: MyColors.grey_cb),
                                  border: InputBorder.none,
                                  suffixIcon: new IconButton(
                                      icon: GestureDetector(
                                          behavior: HitTestBehavior.translucent,
                                          onTap: () {
                                            setState(() {
                                              _againPwdController.text = '';
                                            });
                                          },
                                          child: Icon(
                                            Icons.close,
                                            color: MyColors.grey_cb,
                                          )))),
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
                            onPressed: _submit,
                            color: Colors.transparent,
                            elevation: 0,
                            // 正常时阴影隐藏
                            highlightElevation: 0,
                            // 点击时阴影隐藏
                            child: new Text('完成',
                                style: TextStyle(
                                    fontSize: 14.0, color: MyColors.white_ee)),
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(45.0)),
                          )))
                    ]))
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
