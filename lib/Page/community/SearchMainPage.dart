import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:flutter/services.dart';

///Author:chiuhol
///2020-2-24

class SearchMainPage extends StatefulWidget {
  @override
  _SearchMainPageState createState() => _SearchMainPageState();
}

class _SearchMainPageState extends State<SearchMainPage> {
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            child: AppBar(
                elevation: 0,
                leading: Text(''),
                flexibleSpace: Container(
                    width: double.infinity,
                    height: 80,
                    color: MyColors.white_fe,
                    padding: EdgeInsets.only(left: 18, right: 18, top: 30),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Expanded(
                              child: Container(
                                  padding: EdgeInsets.only(left: 8),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                      color: MyColors.grey_f0),
                                  child: Row(children: <Widget>[
                                    Icon(IconData(0xe63a, fontFamily: 'MyIcons'),
                                        size: 24, color: MyColors.grey_99),
                                    SizedBox(width: 8),
                                    Container(
                                        width: 200,
                                        child: TextField(
                                            controller: _searchController,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(20)
                                              //限制长度
                                            ],
                                            autofocus: true,
                                            cursorColor: MyColors.orange_68,
                                            decoration: InputDecoration(
                                              hintText: "搜索全站内容",
                                              hintStyle: TextStyle(
                                                fontSize: MyFonts.f_15,
                                                color: MyColors.grey_99,
                                              ),
                                              border: InputBorder.none,
                                            )))
                                  ]))
                          ),
                          SizedBox(width: 12),
                          GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                CommonUtil.closePage(context);
                              },
                              child: Text("取消",
                                  style: TextStyle(
                                      color: MyColors.blue_f5,
                                      fontSize: MyFonts.f_15)))
                        ]))),
            preferredSize: Size.fromHeight(55)),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            color: MyColors.white_fe,
            child: Column(children: <Widget>[

            ])));
  }
}
