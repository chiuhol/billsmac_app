import 'dart:convert';

import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Common/local/LocalStorage.dart';
import 'package:billsmac_app/Common/util/PageRoute.dart';
import 'package:billsmac_app/Page/mine/RemindPage.dart';
import 'package:billsmac_app/Page/mine/setting/SettingMainPage.dart';
import 'package:billsmac_app/Widget/SubprojectWidget.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import 'PersonalInfoPage.dart';
import 'TeachMePage.dart';
import 'messageCenter/messageCenterMainPage.dart';

///@Author:chiuhol
///2019-12-4

class MineMainPage extends StatefulWidget {
  static final String MINEMAINPAGE = '/MineMain_Page';

  @override
  _MineMainPageState createState() => _MineMainPageState();
}

class _MineMainPageState extends State<MineMainPage> {
  String _nikeName = '';
  int _day = 0;
  String _assistantName = '';
  String _avatar = "";
  var object = [];
  String _remindTime = "";
  String _remindPeriod = "";

//  @protected
//  _getPersonalMsg()async{
//    String _name = await LocalStorage.get("nikeName").then((result) {
//      return result;
//    });
//    String _avatarUrl = await LocalStorage.get("avatar_url").then((result) {
//      return result;
//    });
//    String _time = await LocalStorage.get("remindTime").then((result) {
//      return result;
//    });
//    String _period = await LocalStorage.get("remindPeriod").then((result) {
//      return result;
//    });
//    if(mounted){
//      setState(() {
//        _nikeName = _name;
//        _avatar = _avatarUrl;
//        _remindTime = _time;
//        _remindPeriod = _period;
//      });
//    }
//  }

  @protected
  _getPersonalMsg()async{
    String _userId = await LocalStorage.get("_id").then((result) {
      return result;
    });
    try {
      BaseOptions options = BaseOptions(method: "get");
      var dio = new Dio(options);
      var response = await dio.get(Address.getUser(_userId));
      print(response.data.toString());
      if (response.data["status"] == 200) {
        var user = response.data["data"]["user"];
        object = response.data["data"]["objects"];
        if (mounted) {
          setState(() {
            _nikeName = user["nikeName"];
            _avatar = user["avatar_url"];
            _remindTime = user["remindTime"];
            DateTime now = DateTime.now();
            DateTime createdAt = DateTime.parse(user["createdAt"]);
            var hours = now.difference(createdAt).inDays;
            _day = hours;
            if(object.length != 0){
              _assistantName = object[0]["nikeName"];
            }
          });
        }
      }
    } catch (err) {
      CommonUtil.showMyToast("系统开小差了~");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getPersonalMsg();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          width: double.infinity,
            height: double.infinity,
            color: MyColors.white_fe,
            child: SingleChildScrollView(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
//                      Container(
//                          padding: EdgeInsets.only(top: 50, right: 18),
//                          child: GestureDetector(
//                              behavior: HitTestBehavior.translucent,
//                              onTap: () {
//                                CommonUtil.openPage(
//                                    context, MessageCenterMainPage());
//                              },
//                              child: Icon(
//                                  IconData(0xe604, fontFamily: 'MyIcons'),
//                                  size: 24,
//                                  color: MyColors.orange_56))),
                    SizedBox(height: 50),
                      GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            CommonUtil.openPage(context, PersonalInfoPage()).then((value){
                              if(value == "success"){
                                _getPersonalMsg();
                              }
                            });
                          },
                          child: Container(
                              margin:
                                  EdgeInsets.only(left: 18, right: 18, top: 18),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                        child: Row(children: <Widget>[
                                      ClipOval(
                                          child: Image.network(
                                              "http://$_avatar",
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover)),
                                      SizedBox(width: 8),
                                      Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Text(_nikeName,
                                                style: TextStyle(
                                                    color: MyColors.black_33,
                                                    fontSize: MyFonts.f_16,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            SizedBox(height: 8),
                                            RichText(
                                                text: TextSpan(
                                                    text: object.length == 0?"":('和' +
                                                        _assistantName +
                                                        '在一起的第'),
                                                    style: TextStyle(
                                                        color: MyColors.grey_cb,
                                                        fontSize: MyFonts.f_14),
                                                    children: <TextSpan>[
                                                  TextSpan(
                                                    text: object.length == 0?"":_day.toString(),
                                                    style: TextStyle(
                                                        color:
                                                            MyColors.orange_67,
                                                        fontSize: MyFonts.f_22,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  TextSpan(
                                                    text: object.length == 0?"":'天',
                                                    style: TextStyle(
                                                        color: MyColors.grey_cb,
                                                        fontSize: MyFonts.f_14),
                                                  )
                                                ]))
                                          ])
                                    ])),
                                    Icon(
                                      Icons.chevron_right,
                                      color: MyColors.grey_e2,
                                      size: 30,
                                    )
                                  ]))),
                      Padding(
                          padding: EdgeInsets.only(top: 50, bottom: 128),
                          child: Column(children: <Widget>[
                            SubprojectWidget(
                                title: '调教我吧', icon: 0xe642, subTitle: '让我更懂你',function: (){
                              CommonUtil.openPage(context, TeachMePage());
                            }),
                            SeparatorWidget(),
                            SubprojectWidget(
                                title: '记账提醒',
                                icon: 0xe62e,
                                subTitle: _remindTime+_remindPeriod,
                                function: (){
                                  CommonUtil.openPage(context, RemindPage()).then((value){
                                    if(value == "success"){
                                      _getPersonalMsg();
                                    }
                                  });
                                }),
                            SeparatorWidget(),
                            SubprojectWidget(
                                title: '设置',
                                icon: 0xe61e,
                                rout: SettingMainPage()),
                            SeparatorWidget(),
                            SubprojectWidget(title: '分享给好友', icon: 0xe86c,function: (){
                              CommonUtil.showMyToast("暂未开放");
                            }),
                            SeparatorWidget(),
                            SubprojectWidget(title: '个性化开屏', icon: 0xe6ac,function: (){
                              CommonUtil.showMyToast("暂未开放");
                            })
                          ]))
                    ]))));
  }
}
