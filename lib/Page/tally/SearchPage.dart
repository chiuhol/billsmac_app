import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:flutter/services.dart';

///Author:chiuhol
///2020-2-9

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: double.infinity,
            height: double.infinity,
            color: MyColors.grey_f9,
            child: Column(children: <Widget>[
              Container(
                  width: double.infinity,
                  height: 80,
                  color: MyColors.white_fe,
                  padding: EdgeInsets.only(left: 18, right: 18, top: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                            width: 320,
                            padding: EdgeInsets.only(left: 8),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                color: MyColors.grey_f6),
                            child: Row(children: <Widget>[
                              Icon(IconData(0xe63a, fontFamily: 'MyIcons'),
                                  size: 24, color: MyColors.orange_67),
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
                                      cursorColor: MyColors.orange_68,
                                      decoration: InputDecoration(
                                        hintText: "请输入内容",
                                        hintStyle: TextStyle(
                                          fontSize: MyFonts.f_15,
                                          color: MyColors.grey_cb,
                                        ),
                                        border: InputBorder.none,
                                      )))
                            ])),
                        SizedBox(width: 8),
                        GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              CommonUtil.closePage(context);
                            },
                            child: Text("取消",
                                style: TextStyle(
                                    color: MyColors.black_32,
                                    fontSize: MyFonts.f_15)))
                      ])),
              SeparatorWidget()
            ])));
  }
}
