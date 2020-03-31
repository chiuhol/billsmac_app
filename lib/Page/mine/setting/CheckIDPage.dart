import 'dart:io';

import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Common/local/LocalStorage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import 'BindNewPhonePage.dart';

///Author:chiuhol
///2020-3-7

class CheckIDPage extends StatefulWidget {
  final String phone;

  CheckIDPage({this.phone});

  @override
  _CheckIDPageState createState() => _CheckIDPageState();
}

class _CheckIDPageState extends State<CheckIDPage> {
  TextEditingController _pwdController = TextEditingController();

  bool _nextStatus = false;

  @protected
  _checkPwd()async{
    String _userId = await LocalStorage.get("_id").then((result) {
      return result;
    });
    String _phone = await LocalStorage.get("phone").then((result) {
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
      var response = await dio.patch(Address.updatePwd(_userId), data: {
        "phone": _phone,
        "oldPwd": _pwdController.text
      });
      print(response.data.toString());
      if (response.data["status"] == 200) {
        CommonUtil.openPage(context, BindNewPhonePage());
      }else{
        CommonUtil.showMyToast("密码不正确，请重新输入");
      }
    } catch (err) {
      CommonUtil.showMyToast(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
            title: "验证身份",
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
                      Padding(
                          padding: EdgeInsets.only(top: 8, bottom: 18),
                          child: Text("更换手机前，先输入${CommonUtil.hidePhone(widget.phone)}的登录密码以验证身份",
                              style: TextStyle(
                                  color: MyColors.grey_cb,
                                  fontSize: MyFonts.f_12))),
                      Container(
                          width: double.infinity,
                          color: MyColors.white_fe,
                          padding: EdgeInsets.only(
                              left: 12, right: 12, bottom: 5, top: 5),
                          child: Row(children: <Widget>[
                            Expanded(
                                child: TextField(
                                    controller: _pwdController,
                                    inputFormatters: [
                                      LengthLimitingTextInputFormatter(12)
                                      //限制长度
                                    ],
                                    cursorColor: MyColors.orange_68,
                                    obscureText: true,
                                    onChanged: (value) {
                                      if (mounted) {
                                        setState(() {
                                          if (_pwdController.text != '') {
                                            _nextStatus = true;
                                          } else {
                                            _nextStatus = false;
                                          }
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: "请输入登录密码",
                                      hintStyle: TextStyle(
                                          fontSize: MyFonts.f_15,
                                          color: MyColors.grey_cb),
                                      border: InputBorder.none,
                                    ))),
                            GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  if (mounted) {
                                    setState(() {
                                      _nextStatus =false;
                                      _pwdController.clear();
                                    });
                                  }
                                },
                                child: Icon(Icons.clear,
                                    color: MyColors.grey_cb, size: 20))
                          ])),
                      Padding(
                          padding: EdgeInsets.only(top: 20, left: 18, right: 18),
                          child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                if(_pwdController.text != ''){
                                  _checkPwd();
                                }
                              },
                              child: Container(
                                  width: double.infinity,
                                  height: 45,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(20.0)),
                                      gradient: LinearGradient(
                                        colors: _nextStatus == false
                                            ? [MyColors.orange_ac, MyColors.orange_b6]
                                            : [MyColors.orange_76, MyColors.orange_62],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                      )),
                                  child: Center(
                                      child: Text('下一步',
                                          style: TextStyle(
                                              color: MyColors.white_fe,
                                              fontSize: MyFonts.f_16))))))
                    ]))));
  }
}
