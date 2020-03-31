import 'dart:io';

import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Common/local/LocalStorage.dart';
import 'package:billsmac_app/Page/tally/chatroom/UpdateMsgPage.dart';
import 'package:dio/dio.dart';

import 'SetChatBackgroundPage.dart';

///Author:chiuhol
///2020-3-9

class AddObjectPage extends StatefulWidget {
  @override
  _AddObjectPageState createState() => _AddObjectPageState();
}

class _AddObjectPageState extends State<AddObjectPage> {
  String _avatar = '';

  String _name = '';
  String _calledHer = '';
  String _callMe = '';

  @protected
  _save()async{
    String _userId = await LocalStorage.get("_id").then((result) {
      return result;
    });
    String _token = await LocalStorage.get("token").then((result) {
      return result;
    });
    try {
      BaseOptions options = BaseOptions(
          method: "post",
          headers: {HttpHeaders.AUTHORIZATION: "Bearer $_token"});
      var dio = new Dio(options);
      var response =
      await dio.post(Address.saveObjects(_userId), data: {
        "userId": _userId,
        "nikeName":"",
        "calledMe":""
      });
      print(response.data.toString());
      if (response.data["status"] == 200) {

      }
    } catch (err) {
      CommonUtil.showMyToast(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          title: "增加群聊成员",
          isBack: true,
          backIcon: Icon(Icons.keyboard_arrow_left,
              color: MyColors.black_32, size: 28),
          color: MyColors.white_fe,
        ),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            color: MyColors.grey_e2,
            child: SingleChildScrollView(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: MyColors.white_fe, width: 3),
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(40.0))),
                              child: ClipOval(
                                  child: Image.network(_avatar,
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover)))),
                      Container(
                          margin: EdgeInsets.only(left: 18, right: 18),
                          decoration: BoxDecoration(
                              color: MyColors.white_fe,
                              borderRadius:
                              BorderRadius.all(Radius.circular(20))),
                          child: Column(children: <Widget>[
                            builder('她是我的', _name, () {
                              CommonUtil.openPage(
                                  context,
                                  UpdateMsgPage(
                                    title: '她是我的',
                                    content: _name,
                                  )).then((value) {
                                if (value != null) {
                                  setState(() {
                                    _name = value;
                                  });
                                }
                              });
                            }),
                            SeparatorWidget(),
                            builder('我叫她什么', _calledHer, () {
                              CommonUtil.openPage(
                                  context,
                                  UpdateMsgPage(
                                    title: '我叫她什么',
                                    content: _calledHer,
                                  )).then((value) {
                                if (value != null) {
                                  setState(() {
                                    _calledHer = value;
                                  });
                                }
                              });
                            }),
                            SeparatorWidget(),
                            builder('她叫我什么', _callMe, () {
                              CommonUtil.openPage(
                                  context,
                                  UpdateMsgPage(
                                    title: '她叫我什么',
                                    content: _callMe,
                                  )).then((value) {
                                if (value != null) {
                                  setState(() {
                                    _callMe = value;
                                  });
                                }
                              });
                            })
                          ])),
                      Padding(
                          padding: EdgeInsets.only(top: 18),
                          child: Container(
                              margin: EdgeInsets.only(left: 18, right: 18),
                              decoration: BoxDecoration(
                                  color: MyColors.white_fe,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                              child: Column(children: <Widget>[
                                builder('聊天背景', '', () {
                                  CommonUtil.openPage(context, SetChatBackgroundPage());
                                }),
                                SeparatorWidget(),
                                builder('展示在一起的天数', '展示中', () {})
                              ]))),
                      Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text('*开启后我的页面中将展示和对方在一起的天数',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: MyColors.grey_cb,
                                  fontSize: MyFonts.f_12))),
                      Padding(
                          padding: EdgeInsets.only(left: 18, right: 18),
                          child: Container(
                              height: 45.0,
                              margin: EdgeInsets.only(top: 10.0),
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                                  color: MyColors.white_fe),
                              child: new SizedBox.expand(
                                  child: new RaisedButton(
                                    onPressed: _save,
                                    color: Colors.transparent,
                                    elevation: 0,
                                    // 正常时阴影隐藏
                                    highlightElevation: 0,
                                    // 点击时阴影隐藏
                                    child: new Text('保存',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: MyColors.red_34)),
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                        new BorderRadius.circular(45.0)),
                                  ))))
                    ]))));
  }

  Widget builder(String _title, String _subTitle, Function _fun) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _fun,
        child: Padding(
            padding: EdgeInsets.only(left: 8, right: 8, top: 18, bottom: 18),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(_title,
                      style: TextStyle(
                          color: MyColors.black_32, fontSize: MyFonts.f_16)),
                  Row(children: <Widget>[
                    Text(_subTitle,
                        style: TextStyle(
                            color: MyColors.grey_cb, fontSize: MyFonts.f_16)),
                    SizedBox(width: 8),
                    Icon(Icons.chevron_right, color: MyColors.grey_cb, size: 24)
                  ])
                ])));
  }
}
