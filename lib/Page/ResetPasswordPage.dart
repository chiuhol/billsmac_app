import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:flutter/services.dart';
import 'package:apifm/apifm.dart' as Apifm;

///Author:chiuhol
///2020-2-2

class ResetPasswordPage extends StatefulWidget {
  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _codeController = TextEditingController();
  TextEditingController _newPwdController = TextEditingController();
  TextEditingController _againPwdController = TextEditingController();
  TextEditingController _photoController = TextEditingController();

  @protected
  _getCode()async{
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
                              Apifm.smsValidateCode(_phoneController.text,key,_photoController.text)
                                  .then((res) {
                                if (res["code"] == 0) {
                                  CommonUtil.closePage(context);
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
  _submit() async {
    if (!CommonUtil.isPhoneNo(_phoneController.text)) {
      CommonUtil.showMyToast("请输入正确的手机号码");
      return;
    }
    if(_codeController.text == ''){
      CommonUtil.showMyToast("验证码不能为空");
      return;
    }
    if(_newPwdController.text == ''){
      CommonUtil.showMyToast("请输入新密码");
      return;
    }
    if (!CommonUtil.isPasswordValid(_newPwdController.text)) {
      CommonUtil.showMyToast("密码仅由数字与字母组成");
      return;
    }
    if(_newPwdController.text != _againPwdController.text){
      CommonUtil.showMyToast("两次密码输入不一致");
      return;
    }
    var res = await Apifm.resetPwd(_phoneController.text, _againPwdController.text, _codeController.text);
    if(res["code"] == 0){
      CommonUtil.showMyToast("修改密码成功");
      CommonUtil.closePage(context);
    }else{
      CommonUtil.showMyToast(res["msg"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: double.infinity,
            height: double.infinity,
            color: MyColors.grey_f6,
            child: SingleChildScrollView(
              child: Column(children: <Widget>[
                Container(
                    padding: EdgeInsets.only(top: 45, bottom: 18),
                    color: MyColors.white_fe,
                    child: Row(children: <Widget>[
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
                                  color: MyColors.black_32,
                                  fontSize: MyFonts.f_15)))
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
                                colors: [MyColors.orange_b8, MyColors.orange_ab],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius:
                              BorderRadius.all(Radius.circular(20.0)),
                            ),
                            child: new InkWell(
                                borderRadius: new BorderRadius.circular(25.0),
                                onTap: _submit,
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
              ])
            )));
  }

  Widget resetPassword() {
    return Container(
        padding: EdgeInsets.only(left: 18),
        color: MyColors.white_fe,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: TextField(
                      maxLines: 1,
                      keyboardType: TextInputType.number,
                      cursorColor: MyColors.orange_68,
                      controller: _phoneController,
                      decoration: InputDecoration(
                          hintText: '请输入手机号码',
                          hintStyle: TextStyle(
                            fontSize: MyFonts.f_14,
                            color: MyColors.grey_cb,
                          ),
                          border: InputBorder.none),
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly
                      ])),
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
                                cursorColor: MyColors.orange_68,
                                controller: _codeController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    hintText: '请输入验证码',
                                    hintStyle: TextStyle(
                                        fontSize: MyFonts.f_14,
                                        color: MyColors.grey_cb),
                                    border: InputBorder.none),
                                inputFormatters: [
                                  WhitelistingTextInputFormatter.digitsOnly
                                ])),
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
                                            end: Alignment.bottomCenter),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0))),
                                    child: new InkWell(
                                        borderRadius:
                                            new BorderRadius.circular(25.0),
                                        onTap: _getCode,
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
                      cursorColor: MyColors.orange_68,
                      keyboardType: TextInputType.visiblePassword,
                      controller: _newPwdController,
                      decoration: InputDecoration(
                          hintText: '请设置新的密码',
                          hintStyle: TextStyle(
                              fontSize: MyFonts.f_14, color: MyColors.grey_cb),
                          border: InputBorder.none))),
              SeparatorWidget(),
              Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: TextField(
                      maxLines: 1,
                      cursorColor: MyColors.orange_68,
                      keyboardType: TextInputType.visiblePassword,
                      controller: _againPwdController,
                      decoration: InputDecoration(
                          hintText: '请再次输入密码',
                          hintStyle: TextStyle(
                              fontSize: MyFonts.f_14, color: MyColors.grey_cb),
                          border: InputBorder.none))),
            ]));
  }
}
