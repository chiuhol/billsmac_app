import 'dart:io';

import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Common/local/LocalStorage.dart';
import 'package:dio/dio.dart';
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

  bool _isDelete = false; //是否出现删除按钮

  @protected
  _updateName() async {
    String _chatroomId = await LocalStorage.get("chatroomId").then((result) {
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
      var response = await dio.patch(Address.updateChatroom(_chatroomId),
          data: {"chatName": _nameController.text});
      print(response.data.toString());
      if (response.data["status"] == 200) {
        LocalStorage.save("chatName", _nameController.text);
        CommonUtil.showMyToast("聊天室名称已修改");
        Navigator.of(context).pop(_nameController.text);
      }
    } catch (err) {
      CommonUtil.showMyToast(err.toString());
    }
  }

  @protected
  _getLocalStorage()async{
    String _name = await LocalStorage.get("chatName").then((result) {
      return result;
    });
    if(mounted){
      setState(() {
        _nameController.text = _name;
        _isDelete = true;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getLocalStorage();
  }

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
                if (_nameController.text == '') {
                  CommonUtil.showMyToast("群聊名称不能为空哦~");
                } else {
                  _updateName();
                }
              },
              child: Text("完成",
                  style: TextStyle(
                      color: MyColors.orange_67, fontSize: MyFonts.f_16))),
        ),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            color: MyColors.grey_f6,
            child: Column(children: <Widget>[
              Container(
                  color: MyColors.white_fe,
                  padding:
                      EdgeInsets.only(left: 18, right: 18, top: 8, bottom: 8),
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
                                  _updateName();
                                },
                                onChanged: (value) {
                                  if (mounted) {
                                    setState(() {
                                      if (value != '') {
                                        _isDelete = true;
                                      } else {
                                        _isDelete = false;
                                      }
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                  hintText: _chatName,
                                  hintStyle: TextStyle(
                                    fontSize: MyFonts.f_15,
                                    color: MyColors.grey_cb,
                                  ),
                                  border: InputBorder.none,
                                ))),
                        _isDelete == false
                            ? Container()
                            : GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  setState(() {
                                    _nameController.clear();
                                    _isDelete = false;
                                  });
                                },
                                child: Icon(
                                    IconData(0xe62f, fontFamily: 'MyIcons'),
                                    size: 24,
                                    color: MyColors.orange_67))
                      ]))
            ])));
  }
}
