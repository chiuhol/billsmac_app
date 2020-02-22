import 'dart:convert';

import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

///Author:chiuhol
///2020-2-22

class ChatroomMainPage extends StatefulWidget {
  @override
  _ChatroomMainPageState createState() => _ChatroomMainPageState();
}

class _ChatroomMainPageState extends State<ChatroomMainPage> {
  TextEditingController _contentController = TextEditingController();
  String _nikeName = '';
  String _myAvatar = '';
  String _objectAvatar = '';

  final String url = "http://api.qingyunke.com/api.php?key=free&appid=0&msg=";

  List _contentLst = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _nikeName = '小不点';
    _objectAvatar =
        'https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=1908196590,4061628990&fm=11&gp=0.jpg';
    _myAvatar =
        'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1379686624,47059782&fm=26&gp=0.jpg';
  }

  @protected
  _send() async {
    if (_contentController.text == '') {
      CommonUtil.showMyToast('消息内容不能为空');
      return;
    }
    setState(() {
      _contentLst
          .add({"content": _contentController.text, "isMyContent": true});
    });
    http.Response res = await http.get(url+_contentController.text);
    if(jsonDecode(res.body)["result"] == 0){
      setState(() {
        _contentLst
            .add({"content": jsonDecode(res.body)["content"], "isMyContent": false});
      });
    }else{
      CommonUtil.showMyToast("连接服务器错误");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          title: _nikeName,
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
                child: Column(children: <Widget>[
                  ListView.builder(
                      itemBuilder: itemBuilder,
                      itemCount: _contentLst.length,
                      shrinkWrap: true)
                ]))),
        bottomSheet: Container(
            width: double.infinity,
            height: 45,
            color: MyColors.grey_e4,
            child: Padding(
                padding:
                    EdgeInsets.only(left: 18, right: 18, top: 5, bottom: 5),
                child: Row(children: <Widget>[
                  GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {},
                      child: Container(
                          padding: EdgeInsets.only(left: 18, top: 16),
                          decoration: BoxDecoration(
                              color: MyColors.white_f6,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Container(
                              width: 300,
                              child: TextField(
                                  controller: _contentController,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(7)
                                  ],
                                  autofocus: false,
                                  cursorColor: MyColors.orange_68,
                                  decoration: InputDecoration(
                                    hintText: "请输入消息",
                                    hintStyle: TextStyle(
                                      fontSize: MyFonts.f_15,
                                      color: MyColors.grey_cb,
                                    ),
                                    border: InputBorder.none,
                                  ))))),
                  SizedBox(width: 18),
                  GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: _send,
                      child: Text('发送',
                          style: TextStyle(
                              color: MyColors.black_32,
                              fontSize: MyFonts.f_16,
                              fontWeight: FontWeight.bold)))
                ]))));
  }

  Widget itemBuilder(BuildContext context, int index) {
    Map _content = _contentLst[index];
    if (_content["isMyContent"]) {
      return rightObject(_content["content"]);
    } else if (!_content["isMyContent"]) {
      return leftObject(_content["content"]);
    } else {
      return Container();
    }
  }

  Widget leftObject(String title) {
    return Container(
        padding: EdgeInsets.only(left: 18, top: 18),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          ClipOval(
              child: Image.network(_objectAvatar,
                  width: 45, height: 45, fit: BoxFit.cover)),
          SizedBox(width: 18),
          Container(
              decoration: BoxDecoration(
                  color: MyColors.grey_f9,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Padding(
                  padding:
                      EdgeInsets.only(left: 18, right: 18, top: 12, bottom: 12),
                  child: Text(title,
                      style: TextStyle(
                          color: MyColors.black_62, fontSize: MyFonts.f_14))))
        ]));
  }

  Widget rightObject(String content) {
    return Container(
        padding: EdgeInsets.only(right: 18, top: 18),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [MyColors.orange_b8, MyColors.orange_ab],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Padding(
                  padding:
                      EdgeInsets.only(left: 18, right: 18, top: 12, bottom: 12),
                  child: Text(content,
                      style: TextStyle(
                          color: MyColors.white_fe, fontSize: MyFonts.f_14)))),
          SizedBox(width: 18),
          ClipOval(
              child: Image.network(_myAvatar,
                  width: 45, height: 45, fit: BoxFit.cover))
        ]));
  }
}
