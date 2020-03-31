import 'dart:io';

import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Common/local/LocalStorage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:apifm/apifm.dart' as Apifm;

import '../../LoginPage.dart';

///Author:chiuhol
///2020-3-7

class BindNewPhonePage extends StatefulWidget {
  @override
  _BindNewPhonePageState createState() => _BindNewPhonePageState();
}

class _BindNewPhonePageState extends State<BindNewPhonePage> {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  TextEditingController _photoController = TextEditingController();

  bool _updateStatus = false;
  bool _isSendCode = false;

  void getCode() async {
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
                              Apifm.smsValidateCode(_phoneController.text, key,
                                      _photoController.text)
                                  .then((res) {
                                if (res["code"] == 0) {
                                  if (mounted) {
                                    setState(() {
                                      _isSendCode = true;
                                    });
                                  }
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

  @protected
  _update() async {
    var res = await Apifm.smsValidateCodeCheck(
        _phoneController.text, _codeController.text);
    if (res["code"] == 0) {
      _updatePhone();
    } else {
      CommonUtil.showMyToast(res["msg"]);
    }
  }

  @protected
  _updatePhone() async {
    String _userId = await LocalStorage.get("_id").then((result) {
      return result;
    });
    String _token = await LocalStorage.get("token").then((result) {
      return result;
    });
    try {
      BaseOptions options = BaseOptions(
          method: "patch",
          headers: {HttpHeaders.AUTHORIZATION: "Bearer $_token"});
      var dio = new Dio(options);
      var response = await dio.patch(Address.updatePersonalMsg(_userId),
          data: {"phone": _phoneController.text});
      print(response.data.toString());
      if (response.data["status"] == 200) {
        LocalStorage.save("phone", _phoneController.text);
        CommonUtil.showMyToast("你的资料已修改，请重新登录");
        CommonUtil.openPage(context, LoginPage());
      }
    } catch (err) {
      CommonUtil.showMyToast(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
            title: "绑定新的手机号码",
            isBack: true,
            backIcon: Icon(Icons.keyboard_arrow_left,
                color: MyColors.black_32, size: 28),
            color: MyColors.white_fe),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            color: MyColors.grey_f6,
            child: SingleChildScrollView(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      phoneWidget(),
                      codeWidget(),
                      buttonWidget()
                    ]))));
  }

  Widget phoneWidget() {
    return Container(
        width: double.infinity,
        color: MyColors.white_fe,
        padding: EdgeInsets.only(left: 12, right: 12, bottom: 5, top: 5),
        child: Row(children: <Widget>[
          Expanded(
              child: TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(12) //限制长度
                  ],
                  cursorColor: MyColors.orange_68,
                  onChanged: (value) {
                    if (mounted) {
                      setState(() {
                        if (_phoneController.text != '' &&
                            _codeController.text != '') {
                          _updateStatus = true;
                        } else {
                          _updateStatus = false;
                        }
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "输入新的手机号码",
                    hintStyle: TextStyle(
                        fontSize: MyFonts.f_15, color: MyColors.grey_cb),
                    border: InputBorder.none,
                  ))),
          GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (mounted) {
                  setState(() {
                    _updateStatus = false;
                    _phoneController.clear();
                  });
                }
              },
              child: Icon(Icons.clear, color: MyColors.grey_cb, size: 20))
        ]));
  }

  Widget codeWidget() {
    return Container(
        width: double.infinity,
        color: MyColors.white_fe,
        padding: EdgeInsets.only(left: 12, right: 12, bottom: 5, top: 5),
        child: Row(children: <Widget>[
          Expanded(
              child: TextField(
                  controller: _codeController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(4) //限制长度
                  ],
                  cursorColor: MyColors.orange_68,
                  onChanged: (value) {
                    if (mounted) {
                      setState(() {
                        if (_phoneController.text != '' &&
                            _codeController.text != '') {
                          _updateStatus = true;
                        } else {
                          _updateStatus = false;
                        }
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "请输入验证码",
                    hintStyle: TextStyle(
                        fontSize: MyFonts.f_15, color: MyColors.grey_cb),
                    border: InputBorder.none,
                  ))),
          GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (!CommonUtil.isPhoneNo(_phoneController.text)) {
                  CommonUtil.showMyToast("请输入正确的手机号");
                  return;
                }
                if (!_isSendCode) {
                  getCode();
                }
              },
              child: Container(
                  width: 80,
                  height: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                      gradient: LinearGradient(
                        colors: [MyColors.orange_76, MyColors.orange_62],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )),
                  child: Center(
                      child: Text(_isSendCode == false ? '获取验证码' : "已发送",
                          style: TextStyle(
                              color: MyColors.white_fe,
                              fontSize: MyFonts.f_12)))))
        ]));
  }

  Widget buttonWidget() {
    return Padding(
        padding: EdgeInsets.only(top: 20, left: 18, right: 18),
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: _update,
            child: Container(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    gradient: LinearGradient(
                      colors: _updateStatus == false
                          ? [MyColors.orange_ac, MyColors.orange_b6]
                          : [MyColors.orange_76, MyColors.orange_62],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )),
                child: Center(
                    child: Text('更改',
                        style: TextStyle(
                            color: MyColors.white_fe,
                            fontSize: MyFonts.f_16))))));
  }
}
