import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:pin_input_text_field/pin_input_text_field.dart';
import 'package:apifm/apifm.dart' as Apifm;

import 'HomeMainPage.dart';

///Author:chiuhol
///2020-2-2

class VerificationCodePage extends StatefulWidget {
  final String phoneNum;

  VerificationCodePage(this.phoneNum);

  @override
  _VerificationCodePageState createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  GlobalKey<FormState> loginKey = new GlobalKey<FormState>();

  TextEditingController _pinEditingController = TextEditingController();
  TextEditingController _photoController = TextEditingController();

  @protected
  again() async {
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
                              Apifm.smsValidateCode(widget.phoneNum, key,
                                      _photoController.text)
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
                    padding: EdgeInsets.only(top: 100.0),
                    alignment: Alignment.center,
                    child: new Text(
                      '输入4位验证码',
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
                      Padding(
                          padding: EdgeInsets.only(top: 6, bottom: 12),
                          child: Text("验证码已发送到${widget.phoneNum}的手机上",
                              style: TextStyle(
                                  color: MyColors.grey_cb,
                                  fontSize: MyFonts.f_14))),
                      Padding(
                          padding: EdgeInsets.only(left: 60, right: 60),
                          child: PinInputTextField(
                            pinLength: 4,
                            decoration: UnderlineDecoration(
                                lineHeight: 1.0,
                                color: MyColors.orange_68,
                                gapSpace: 18.0,
                                textStyle: TextStyle(
                                    fontSize: MyFonts.f_22,
                                    color: MyColors.black_32,
                                    fontWeight: FontWeight.bold)),
                            controller: _pinEditingController,
                            autoFocus: true,
                            textInputAction: TextInputAction.go,
                            onSubmit: (pin) async {
                              var res = await Apifm.smsValidateCodeCheck(
                                  widget.phoneNum, pin);
                              if (res["code"] == 0) {
                                var res2 = await Apifm.register_mobile({
                                  "code": pin,
                                  'mobile': widget.phoneNum,
                                  'pwd': '123456'
                                });
                                if (res2["code"] == 0) {
                                  CommonUtil.showMyToast("注册成功");
                                  CommonUtil.openPage(context, HomeMainPage());
                                } else {
                                  CommonUtil.showMyToast(res2["msg"]);
                                }
                              } else {
                                CommonUtil.showMyToast(res["msg"]);
                              }
                            },
                          )),
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
                            onPressed: again,
                            color: Colors.transparent,
                            elevation: 0,
                            // 正常时阴影隐藏
                            highlightElevation: 0,
                            child: new Text('重发验证码',
                                style: TextStyle(
                                    fontSize: 14.0, color: MyColors.white_fe)),
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
