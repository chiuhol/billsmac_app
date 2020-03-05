import 'dart:io';

import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Common/local/LocalStorage.dart';
import 'package:billsmac_app/Widget/NumKeyBoard.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

///Author:chiuhol
///2020-3-3

class TallyDetailPage extends StatefulWidget {
  final Map detail;

  TallyDetailPage({this.detail});

  @override
  _TallyDetailPageState createState() => _TallyDetailPageState();
}

class _TallyDetailPageState extends State<TallyDetailPage> {
  TextEditingController _remarkController = TextEditingController();
  String _account = "";

  @protected
  _updateRecord(Map msg) async {
    print(msg);
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
      var response = await dio.patch(
          Address.updateChatContent(_chatroomId, widget.detail["id"]),
          data: msg);
      print(response.data.toString());
      if (response.data["status"] == 200) {
        CommonUtil.showMyToast("你的记录已修改");
        Navigator.of(context).pop("success");
      }
    } catch (err) {
      CommonUtil.showMyToast(err.toString());
    }
  }

  @protected
  _showTip() {
    return showCupertinoDialog(
        context: context,
        builder: (_) =>
            CupertinoAlertDialog(content: Text('确定删除这条记录？'), actions: <Widget>[
              CupertinoDialogAction(
                  child: Text(
                    '取消',
                    style: TextStyle(color: MyColors.red_34),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              CupertinoDialogAction(
                child: Text(
                  '确定',
                  style: TextStyle(color: MyColors.orange_68),
                ),
                onPressed: () {
                  CommonUtil.closePage(context);
                  _updateRecord({"status": false});
                },
              )
            ]));
  }

  @protected
  _showKeyBoard() {
    showModalBottomSheet(
        backgroundColor: MyColors.black_45,
        context: context,
        builder: (BuildContext context) {
          return BottomSheet(account: _account, type: widget.detail["typeStr"]);
        }).then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            if (value == '') {
              _account = "0.00";
            } else {
              _account = value;
            }
          });
        }
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _remarkController.text = widget.detail["remark"] ?? "";
    _account = widget.detail["amount"] ?? "";
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
            title: "详情",
            isBack: true,
            backIcon: Icon(Icons.keyboard_arrow_left,
                color: MyColors.black_32, size: 28),
            color: MyColors.grey_f6,
            backEvent: () {
              if (_remarkController.text != widget.detail["remark"] ||
                  _account != widget.detail["amount"]) {
                _updateRecord({
                  "rightcontent": {
                    "typeStr": widget.detail["typeStr"],
                    "amountType": widget.detail["amountType"],
                    "amount": _account,
                    "remark": _remarkController.text
                  }
                });
              } else {
                CommonUtil.closePage(context);
              }
            },
            rightEvent: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _showTip,
                child: Icon(Icons.delete, color: MyColors.grey_cb, size: 20))),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            color: MyColors.grey_f6,
            child: SingleChildScrollView(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: mainWidget())));
  }

  Widget mainWidget() {
    return Container(
        margin: EdgeInsets.only(left: 18, right: 18),
        padding: EdgeInsets.only(left: 12, right: 12),
        decoration: BoxDecoration(
            color: MyColors.white_fe,
            borderRadius: BorderRadius.all(Radius.circular(20.0))),
        child: Column(children: <Widget>[
          Padding(
              padding: EdgeInsets.only(top: 18, bottom: 18),
              child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: _showKeyBoard,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(widget.detail["typeStr"] ?? "",
                            style: TextStyle(
                                color: MyColors.black_1a,
                                fontSize: MyFonts.f_16)),
                        Row(children: <Widget>[
                          Text(_account,
                              style: TextStyle(
                                  color: MyColors.black_1a,
                                  fontSize: MyFonts.f_16)),
                          SizedBox(width: 8),
                          Icon(Icons.chevron_right,
                              size: 20, color: MyColors.grey_cb)
                        ])
                      ]))),
          SeparatorWidget(),
          Padding(
              padding: EdgeInsets.only(top: 18, bottom: 18),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("时间",
                        style: TextStyle(
                            color: MyColors.grey_cb, fontSize: MyFonts.f_16)),
                    Row(children: <Widget>[
                      Text(widget.detail["createAt"].substring(0, 10) ?? "",
                          style: TextStyle(
                              color: MyColors.black_1a,
                              fontSize: MyFonts.f_16)),
                      SizedBox(width: 8),
                      Icon(Icons.chevron_right,
                          size: 20, color: MyColors.grey_cb)
                    ])
                  ])),
          SeparatorWidget(),
          Padding(
              padding: EdgeInsets.only(top: 18, bottom: 18),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("备注",
                        style: TextStyle(
                            color: MyColors.grey_cb, fontSize: MyFonts.f_16)),
                    Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: TextField(
                            controller: _remarkController,
                            cursorColor: MyColors.orange_68,
                            maxLines: 2,
                            maxLength: 20,
                            decoration: InputDecoration(
                              counterStyle: TextStyle(
                                  fontSize: MyFonts.f_12,
                                  color: MyColors.grey_cb),
                              hintText: "",
                              hintStyle: TextStyle(
                                  fontSize: MyFonts.f_15,
                                  color: MyColors.grey_cb),
                              border: InputBorder.none,
                            )))
                  ]))
        ]));
  }
}

class BottomSheet extends StatefulWidget {
  final String account;
  final String type;

  BottomSheet({this.account, this.type});

  @override
  _BottomSheetState createState() => _BottomSheetState();
}

class _BottomSheetState extends State<BottomSheet> {
  TextEditingController controller;
  String _account = "";
  String _type = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _account = widget.account ?? "";
    _type = widget.type ?? "";
  }

  Widget build(BuildContext context) {
    return Container(
        height: 280,
        child: Column(children: <Widget>[
          Container(
              width: double.infinity,
              height: 45,
              color: MyColors.black_45,
              padding: EdgeInsets.only(left: 18, right: 18, top: 5, bottom: 5),
              child: Container(
                  decoration: BoxDecoration(
                      color: MyColors.white_f6,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Padding(
                      padding: EdgeInsets.only(left: 18, top: 6, right: 18),
                      child: Center(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                            Text(_type,
                                style: TextStyle(
                                    color: MyColors.black_32,
                                    fontSize: MyFonts.f_18)),
                            Text(
                                (_account == '' || _account == null)
                                    ? "0.00"
                                    : _account,
                                style: TextStyle(
                                    color: MyColors.red_5c,
                                    fontSize: MyFonts.f_22))
                          ]))))),
          Container(
              margin: EdgeInsets.only(left: 18, right: 18),
              color: MyColors.black_5f,
              height: 2),
          NumberKeyboardActionSheet(
              amount: _account,
              controller: controller,
              onClick: (value) {
                print(value);
                setState(() {
                  if (value.contains("确定")) {
                    _account = value.replaceAll("确定", "");
                    if (_account.contains("-")) {
                      CommonUtil.showMyToast("输入金额不能小于0");
                      return;
                    }
                    Navigator.of(context).pop(_account);
                  } else {
                    _account = value;
                  }
                });
              })
        ]));
  }
}
