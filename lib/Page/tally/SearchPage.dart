import 'dart:io';

import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Common/local/LocalStorage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

import 'TallyDetailPage.dart';

///Author:chiuhol
///2020-2-9

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocusNode = FocusNode();

  List _chatContentLst = [];
  int _pageIndex = 1;

  bool _cleanIcon = false; //清除内容x是否显示
  bool _isSearch = false; //是否确定搜索

  double _acount = 0;
  String _amountType = "";

  //根据某个关键词搜索
  @protected
  _getChatContent(String q) async {
    String _chatroomId = await LocalStorage.get("chatroomId").then((result) {
      return result;
    });
    String _token = await LocalStorage.get("token").then((result) {
      return result;
    });
    try {
      BaseOptions options = BaseOptions(
          method: "get",
          headers: {HttpHeaders.AUTHORIZATION: "Bearer $_token"},
          queryParameters: {"q": q, "page": _pageIndex, "per_Page": 10});
      var dio = new Dio(options);
      var response = await dio.get(Address.getChatContent(_chatroomId));
      print(response.data.toString());
      if (response.data["status"] == 200) {
        if (mounted) {
          setState(() {
            _chatContentLst = response.data["data"]["chatContent"];
            if (_chatContentLst.length == 0) {
              if (mounted) {
                setState(() {
                  _isSearch = true;
                });
              }
            }else{
              for(int i=0;i<_chatContentLst.length;i++){
                _acount += double.parse(_chatContentLst[i]["rightcontent"]["amount"]);
                _amountType = _chatContentLst[i]["rightcontent"]["amountType"];
              }
            }
          });
        }
      }
    } catch (err) {
      CommonUtil.showMyToast(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: double.infinity,
            height: double.infinity,
            color: MyColors.white_fe,
            child: Column(children: <Widget>[
              titleWidget(),
              SeparatorWidget(),
              _chatContentLst.length == 0
                  ? _isSearch == false
                      ? Container()
                      : Center(
                          child: RichText(
                              text: TextSpan(
                                  text: "Oh!~找不到任何有关",
                                  style: TextStyle(
                                      color: MyColors.grey_cb,
                                      fontSize: MyFonts.f_16),
                                  children: <TextSpan>[
                              TextSpan(
                                  text: _searchController.text,
                                  style: TextStyle(
                                      color: MyColors.black_1a,
                                      fontSize: MyFonts.f_16)),
                              TextSpan(
                                  text: "的内容",
                                  style: TextStyle(
                                      color: MyColors.grey_cb,
                                      fontSize: MyFonts.f_16))
                            ])))
                  : resultWidget()
            ])));
  }

  //头部搜索框的widget
  Widget titleWidget() {
    return Container(
        width: double.infinity,
        height: 80,
        color: MyColors.white_fe,
        padding: EdgeInsets.only(left: 18, right: 18, top: 20),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                  child: Container(
                      height: 45,
                      padding: EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                          color: MyColors.grey_f6),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Row(children: <Widget>[
                              Icon(IconData(0xe63a, fontFamily: 'MyIcons'),
                                  size: 20, color: MyColors.orange_67),
                              SizedBox(width: 8),
                              Container(
                                  width: 100,
                                  child: TextField(
                                      controller: _searchController,
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(7)
                                        //限制长度
                                      ],
                                      autofocus: true,
                                      focusNode: _searchFocusNode,
                                      cursorColor: MyColors.orange_68,
                                      onChanged: (value) {
                                        if (mounted) {
                                          setState(() {
                                            if (value != '' && value != null) {
                                              _cleanIcon = true;
                                            } else {
                                              _cleanIcon = false;
                                            }
                                          });
                                        }
                                      },
                                      onSubmitted: (value) {
                                        if (value != '' && value != null) {
                                          _getChatContent(value);
                                        }
                                      },
                                      decoration: InputDecoration(
                                        hintText: "请输入内容",
                                        hintStyle: TextStyle(
                                          fontSize: MyFonts.f_15,
                                          color: MyColors.grey_cb,
                                        ),
                                        border: InputBorder.none,
                                      )))
                            ]),
                            _cleanIcon == true
                                ? GestureDetector(
                                    behavior: HitTestBehavior.translucent,
                                    onTap: () {
                                      if (mounted) {
                                        setState(() {
                                          _searchController.clear();
                                          _cleanIcon = false;
                                        });
                                      }
                                    },
                                    child: Padding(
                                        padding: EdgeInsets.only(right: 8),
                                        child: Icon(Icons.clear,
                                            color: MyColors.grey_cb, size: 20)))
                                : Container()
                          ]))),
              SizedBox(width: 8),
              GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    _searchFocusNode.unfocus();
                    CommonUtil.closePage(context);
                  },
                  child: Text("取消",
                      style: TextStyle(
                          color: MyColors.black_32, fontSize: MyFonts.f_15)))
            ]));
  }

  //搜索结果widget
  Widget resultWidget() {
    return Padding(
        padding: EdgeInsets.only(left: 18, right: 18),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 8),
                  child: Text("${_amountType=="expend"?"支出":"收入"}：${_acount.toString()??""}",
                      style: TextStyle(
                          color: MyColors.grey_cb, fontSize: MyFonts.f_16))),
              Container(
                  width: double.infinity,
                  color: MyColors.orange_68,
                  height: 0.5),
              ListView.builder(
                  itemBuilder: itemBuilder,
                  itemCount: _chatContentLst.length,
                  shrinkWrap: true)
            ]));
  }

  Widget itemBuilder(BuildContext context, int index) {
    Map _result = _chatContentLst[index];
    String _symbol = "";
    if (_result["rightcontent"]["amountType"] == "expend") {
      _symbol = "-";
    } else {
      _symbol = "+";
    }
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          CommonUtil.openPage(context, TallyDetailPage(detail: _result))
              .then((value) {
            if (value != null && value == "success") {
              _getChatContent(_searchController.text);
            }
          });
        },
        child: Container(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            decoration: BoxDecoration(
                color: MyColors.white_fe,
                border: Border(
                    bottom: BorderSide(width: 0.5, color: MyColors.orange_68))),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(_result["rightcontent"]["typeStr"] ?? "",
                      style: TextStyle(
                          color: MyColors.black_1a, fontSize: MyFonts.f_16)),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: <
                      Widget>[
                    Text(_symbol + _result["rightcontent"]["amount"] ?? "",
                        style: TextStyle(
                            color: MyColors.black_1a, fontSize: MyFonts.f_16)),
                    SizedBox(height: 8),
                    Text(_result["createdAt"].toString().substring(0, 10) ?? "",
                        style: TextStyle(
                            color: MyColors.grey_cb, fontSize: MyFonts.f_13))
                  ])
                ])));
  }
}
