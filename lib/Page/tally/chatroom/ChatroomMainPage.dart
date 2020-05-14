import 'dart:convert';

import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Common/local/LocalStorage.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

///Author:chiuhol
///2020-2-22

class ChatroomMainPage extends StatefulWidget {
  final Map object;
  ChatroomMainPage({this.object});
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

  _getMine()async{
    String _avatar_url = await LocalStorage.get("avatar_url").then((result) {
      return result;
    });
    if(mounted){
      setState(() {
        _myAvatar = _avatar_url;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _nikeName = widget.object["nikeName"]??"";
    _objectAvatar = widget.object["avatar"]??'https://ss0.bdstatic.com/70cFuHSh_Q1YnxGkpoWK1HF6hhy/it/u=1379686624,47059782&fm=26&gp=0.jpg';
    _getMine();
  }

  @protected
  _send() async {
    if (_contentController.text == '') {
      CommonUtil.showMyToast('消息内容不能为空');
      return;
    }
    String _content = _contentController.text;
    setState(() {
      _contentController.text = '';
      _contentLst.add({"content": _content, "isMyContent": true});
    });
    http.Response res = await http.get(url + _content);
    if (jsonDecode(res.body)["result"] == 0) {
      setState(() {
        _contentLst.add(
            {"content": jsonDecode(res.body)["content"], "isMyContent": false});
      });
    } else {
      CommonUtil.showMyToast("连接服务器错误");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: _nikeName,
        isBack: true,
        backIcon:
            Icon(Icons.keyboard_arrow_left, color: MyColors.black_32, size: 28),
        color: MyColors.white_fe,
      ),
      body: Container(
          width: double.infinity,
          height: double.infinity,
          color: MyColors.grey_e2,
          child: Column(children: <Widget>[
            Expanded(
                child: ListView.builder(
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                    itemBuilder: itemBuilder,
                    itemCount: _contentLst.length,
                    shrinkWrap: true)),
            Container(
                width: double.infinity,
                height: 55,
                color: MyColors.grey_e4,
                child: Padding(
                    padding:
                        EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 8),
                    child: Row(children: <Widget>[
                      Expanded(
                          child: Container(
                              padding: EdgeInsets.only(left: 18, top: 16),
                              decoration: BoxDecoration(
                                  color: MyColors.white_f6,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: TextField(
                                  controller: _contentController,
                                  keyboardType: TextInputType.text,
                                  onSubmitted: (value) {
                                    if (value != '') {
                                      _send();
                                    }
                                  },
                                  autofocus: false,
                                  cursorColor: MyColors.orange_68,
                                  decoration: InputDecoration(
                                    hintText: "请输入消息",
                                    hintStyle: TextStyle(
                                      fontSize: MyFonts.f_18,
                                      color: MyColors.grey_cb,
                                    ),
                                    border: InputBorder.none,
                                  )))),
                      SizedBox(width: 18),
                      GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: _send,
                          child: Icon(Icons.send,
                              size: 26, color: MyColors.blue_e9))
                    ])))
          ])),
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    Map _content = _contentLst[index];
    if (_content["isMyContent"]) {
      return Column(children: <Widget>[
        index == 0 ? SizedBox(height: 18) : SizedBox(),
        rightObject(_content["content"])
      ]);
    } else if (!_content["isMyContent"]) {
      return leftObject(_content["content"]);
    } else {
      return Container();
    }
  }

  Widget leftObject(String title) {
    return Container(
        padding: EdgeInsets.only(left: 12, bottom: 12,right: 12),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          ClipOval(
              child: Image.network(_objectAvatar,
                  width: 45, height: 45, fit: BoxFit.cover)),
          SizedBox(width: 12),
          Flexible(
              child: Container(
                  decoration: BoxDecoration(
                      color: MyColors.grey_f9,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                      padding: EdgeInsets.only(
                          left: 18, right: 18, top: 12, bottom: 12),
                      child: Text(title,
                          style: TextStyle(
                              color: MyColors.black_62,
                              fontSize: MyFonts.f_14)))))
        ]));
  }

  Widget rightObject(String content) {
    return Container(
        padding: EdgeInsets.only(right: 12, bottom: 12,left: 12),
        child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          Flexible(
              child: Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [MyColors.orange_b8, MyColors.orange_ab],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                      padding: EdgeInsets.only(
                          left: 18, right: 18, top: 12, bottom: 12),
                      child: Text(content,
                          style: TextStyle(
                              color: MyColors.white_fe,
                              fontSize: MyFonts.f_14))))),
          SizedBox(width: 12),
          ClipOval(
              child: Image.network("http://$_myAvatar",
                  width: 45, height: 45, fit: BoxFit.cover))
        ]));
  }
}
