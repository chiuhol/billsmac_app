import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:flutter/services.dart';

///Author:chiuhol
///2020-2-8

class UpDateChatNamePage extends StatefulWidget {
  @override
  _UpDateChatNamePageState createState() => _UpDateChatNamePageState();
}

class _UpDateChatNamePageState extends State<UpDateChatNamePage> {
  TextEditingController _nameController = TextEditingController();
  String _chatName = "设置群聊名称";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          title: "群聊名称",
          color: MyColors.white_fe,
          isBack: false,
          backTitle: "取消",
          rightEvent: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                Navigator.of(context).pop(_nameController.text);
              },
              child: Text("完成",
                  style: TextStyle(
                      color: MyColors.orange_67, fontSize: MyFonts.f_16))),
        ),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            color: MyColors.grey_f6,
            child: Column(
              children: <Widget>[
                Container(
                    color: MyColors.white_fe,
                    padding: EdgeInsets.only(left: 18, right: 18,top: 8,bottom: 8),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                              width: 100,
                              child: TextField(
                                  controller: _nameController,
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(7) //限制长度
                                  ],
                                  autofocus: true,
                                  cursorColor: MyColors.orange_68,
                                  onSubmitted: (text) {
                                    //内// 容提交(按回车)的回调
                                    Navigator.of(context).pop(_nameController.text);
                                  },
                                  decoration: InputDecoration(
                                    hintText: _chatName,
                                    hintStyle: TextStyle(
                                      fontSize: MyFonts.f_15,
                                      color: MyColors.grey_cb,
                                    ),
                                    border: InputBorder.none,
                                  ))),
                          GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                setState(() {
                                  _nameController.clear();
                                });
                              },
                              child: Icon(IconData(0xe62f, fontFamily: 'MyIcons'),
                                  size: 24, color: MyColors.orange_67))
                        ]))
              ]
            )));
  }
}
