import 'dart:io';

import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Common/local/LocalStorage.dart';
import 'package:billsmac_app/Page/tally/chatroom/ObjectDetailPage.dart';
import 'package:dio/dio.dart';

import 'AddObjectPage.dart';
import 'RemoveObjectPage.dart';
import 'SetChatBackgroundPage.dart';
import 'UpDateChatNamePage.dart';

///Author:chiuhol
///2020-2-8

class MoreMainPage extends StatefulWidget {
  @override
  _MoreMainPageState createState() => _MoreMainPageState();
}

class _MoreMainPageState extends State<MoreMainPage> {
  String _chatName = "";

  List _objectLst = [];

  //获取用户的对象列表
  @protected
  _getObjects() async {
    String _userId = await LocalStorage.get("_id").then((result) {
      return result;
    });
    print(_userId);
    String _token = await LocalStorage.get("token").then((result) {
      return result;
    });
    try {
      BaseOptions options = BaseOptions(
          method: "get",
          headers: {HttpHeaders.AUTHORIZATION: "Bearer $_token"});
      var dio = new Dio(options);
      var response = await dio.get(Address.getObjects(_userId));
      print(response.data.toString());
      if (response.data["status"] == 200) {
        if (mounted) {
          setState(() {
            _objectLst.addAll(response.data["data"]["objects"]);
          });
        }
      }
    } catch (err) {
      CommonUtil.showMyToast(err.toString());
    }
  }

  @protected
  _getChatName() async {
    String _name = await LocalStorage.get("chatName").then((result) {
      return result;
    });
    String _userName = await LocalStorage.get("nikeName").then((result) {
      return result;
    });
    String _userAvatar = await LocalStorage.get("avatar_url").then((result) {
      return result;
    });
    if (mounted) {
      setState(() {
        _chatName = _name;
        _objectLst.add({"nikeName": _userName, "avatar": _userAvatar});
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getChatName();
    _getObjects();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          title: "聊天信息(${_objectLst.length})",
          isBack: true,
          backIcon: Icon(Icons.keyboard_arrow_left,
              color: MyColors.black_32, size: 28),
          color: MyColors.white_fe,
        ),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            color: MyColors.grey_f6,
            child: Column(children: <Widget>[
              Container(
                  color: MyColors.white_fe,
                  padding: EdgeInsets.only(left: 18, top: 18, bottom: 18),
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                            height: 100,
                            child: ListView.builder(
                                itemBuilder: itemBuilder,
                                itemCount: _objectLst.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal)),
                        Padding(
                            padding: EdgeInsets.only(left: 18, bottom: 35),
                            child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  CommonUtil.openPage(context, AddObjectPage());
                                },
                                child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        color: MyColors.grey_f6,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    child: Icon(Icons.add,
                                        color: MyColors.grey_cb, size: 30)))),
                        Padding(
                            padding: EdgeInsets.only(left: 18, bottom: 35),
                            child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  CommonUtil.openPage(
                                      context, RemoveObjectPage(objectLst: _objectLst));
                                },
                                child: Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                        color: MyColors.grey_f6,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30))),
                                    child: Icon(Icons.remove,
                                        color: MyColors.grey_cb, size: 30))))
                      ])),
              SizedBox(height: 12),
              builder("群聊名称", _chatName, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpDateChatNamePage()),
                ).then((result) {
                  print(result);
                  if (result != null) {
                    setState(() {
                      _chatName = result;
                    });
                  }
                });
              }),
              SeparatorWidget(),
              builder("设置当前聊天背景", "", () {
                CommonUtil.openPage(context, SetChatBackgroundPage());
              }),
              SizedBox(height: 12),
              builder("当前群聊可加好友上限", "5人", () {})
            ])));
  }

  Widget builder(String title, String subTitle, Function function) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          function();
        },
        child: Container(
            padding: EdgeInsets.only(left: 18, right: 18, top: 18, bottom: 18),
            color: MyColors.white_fe,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(title,
                      style: TextStyle(
                          color: MyColors.black_32, fontSize: MyFonts.f_15)),
                  Row(children: <Widget>[
                    Text(subTitle,
                        style: TextStyle(
                            color: MyColors.grey_e2, fontSize: MyFonts.f_15)),
                    Icon(
                      Icons.chevron_right,
                      size: 24,
                      color: MyColors.grey_e2,
                    )
                  ])
                ])));
  }

  Widget itemBuilder(BuildContext context, int index) {
    Map _objects = _objectLst[index];
    return Padding(
        padding: EdgeInsets.only(left: 18),
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              CommonUtil.openPage(context, ObjectDetailPage());
            },
            child: Column(children: <Widget>[
              _objects["avatar"] == null
                  ? Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30))),
                    )
                  : ClipOval(
                      child: Image.network(_objects["avatar"] ?? "",
                          width: 60, height: 60, fit: BoxFit.cover)),
              SizedBox(height: 8),
              Center(
                  child: Text(_objects["nikeName"] ?? "",
                      style: TextStyle(
                          color: MyColors.black_32, fontSize: MyFonts.f_15)))
            ])));
  }
}
