import 'dart:io';

import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Common/local/LocalStorage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import '../../LoginPage.dart';

///Author:chiuhol
///2020-3-7

class UpdatePasswordPage extends StatefulWidget {
  @override
  _UpdatePasswordPageState createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  TextEditingController _oldPwdController = TextEditingController();
  TextEditingController _newPwdController = TextEditingController();
  TextEditingController _new2PwdController = TextEditingController();

  bool _submitStatus = false;

  @protected
  _updatePassword() async {
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
        "oldPwd": _oldPwdController.text,
        "newPwd": _new2PwdController.text
      });
      print(response.data.toString());
      if (response.data["status"] == 200) {
        CommonUtil.showMyToast("密码修改成功，请重新登录");
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
            title: "修改密码",
            isBack: true,
            backIcon: Icon(Icons.keyboard_arrow_left,
                color: MyColors.black_32, size: 28),
            color: MyColors.white_fe),
        body: SingleChildScrollView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Column(children: <Widget>[
              textWidget(_oldPwdController, "请输入原密码"),
              SeparatorWidget(),
              textWidget(_newPwdController, "请设置新密码"),
              SeparatorWidget(),
              textWidget(_new2PwdController, "请再次输入新密码"),
              submit()
            ])));
  }

  Widget submit() {
    return Padding(
        padding: EdgeInsets.only(top: 20, left: 18, right: 18),
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (_oldPwdController.text != '' &&
                  _newPwdController.text != '' &&
                  _new2PwdController.text != '') {
                if (_oldPwdController.text == _newPwdController.text) {
                  CommonUtil.showMyToast("新密码与旧密码相同");
                  return;
                }
                if (_newPwdController.text != _new2PwdController.text) {
                  CommonUtil.showMyToast("两次密码输入不一致");
                  return;
                }
                _updatePassword();
              }
            },
            child: Container(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    gradient: LinearGradient(
                      colors: _submitStatus == false
                          ? [MyColors.orange_ac, MyColors.orange_b6]
                          : [MyColors.orange_76, MyColors.orange_62],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    )),
                child: Center(
                    child: Text('确定',
                        style: TextStyle(
                            color: MyColors.white_fe,
                            fontSize: MyFonts.f_16))))));
  }

  Widget textWidget(TextEditingController controller, String text) {
    return Container(
        width: double.infinity,
        color: MyColors.white_fe,
        padding: EdgeInsets.only(left: 12, right: 12, bottom: 5, top: 5),
        child: Row(children: <Widget>[
          Expanded(
              child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(12) //限制长度
                  ],
                  cursorColor: MyColors.orange_68,
                  obscureText: true,
                  onChanged: (value) {
                    if (mounted) {
                      setState(() {
                        if (_oldPwdController.text != '' &&
                            _newPwdController.text != '' &&
                            _new2PwdController.text != '') {
                          _submitStatus = true;
                        } else {
                          _submitStatus = false;
                        }
                      });
                    }
                  },
                  decoration: InputDecoration(
                    hintText: text,
                    hintStyle: TextStyle(
                        fontSize: MyFonts.f_15, color: MyColors.grey_cb),
                    border: InputBorder.none,
                  ))),
          GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (mounted) {
                  setState(() {
                    controller.clear();
                  });
                }
              },
              child: Icon(Icons.clear, color: MyColors.grey_cb, size: 20))
        ]));
  }
}
