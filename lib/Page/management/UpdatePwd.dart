import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Common/local/LocalStorage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import '../LoginPage.dart';

///Author:chiuhol
///2020-5-4

class UpdatePwd extends StatefulWidget {
  @override
  _UpdatePwdState createState() => _UpdatePwdState();
}

class _UpdatePwdState extends State<UpdatePwd> {
  TextEditingController _newPwdController = TextEditingController();
  TextEditingController _new2PwdController = TextEditingController();
  bool _submitStatus = false;

  @protected
  _updatePassword() async {
    String _manageId = await LocalStorage.get("_id").then((result) {
      return result;
    });
    try {
      BaseOptions options = BaseOptions(method: "patch");
      var dio = new Dio(options);
      var response = await dio.patch(Address.updateManagers(_manageId),
          data: {"password": _new2PwdController.text});
      print(response.data.toString());
      if (response.data["status"] == 200) {
        CommonUtil.showMyToast("修改成功，请重新登录");
        CommonUtil.openPage(context, LoginPage());
      }
    } catch (err) {
      CommonUtil.showMyToast("系统开小差了~");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Column(children: <Widget>[
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
              if (_newPwdController.text != '' &&
                  _new2PwdController.text != '') {
                if (_newPwdController.text != _new2PwdController.text) {
                  CommonUtil.showMyToast("两次密码输入不一致");
                  return;
                }
                if (_new2PwdController.text.length < 6 ||
                    _new2PwdController.text.length > 12) {
                  CommonUtil.showMyToast("密码长度规定为6-12位");
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
                  keyboardType: TextInputType.visiblePassword,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(12) //限制长度
                  ],
                  cursorColor: MyColors.orange_68,
                  obscureText: true,
                  onChanged: (value) {
                    if (mounted) {
                      setState(() {
                        if (_newPwdController.text != '' &&
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
                    _submitStatus = false;
                    controller.clear();
                  });
                }
              },
              child: Icon(Icons.clear, color: MyColors.grey_cb, size: 20))
        ]));
  }
}
