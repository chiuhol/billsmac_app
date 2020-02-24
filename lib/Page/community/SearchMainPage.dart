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

  List _historyLst = [];
  bool _isSearch = false;

  @protected
  _getData() {
    _historyLst.add({"id": 0, "content": "测试0测试0测试0测试0"});
    _historyLst.add({"id": 1, "content": "测试1测试1测试1测试1测试1测试1"});
    _historyLst.add({"id": 2, "content": "测试2测试2测试2测试2"});
    _historyLst.add({"id": 3, "content": "测试3测试3测试3测试3测试3测试3"});
    _historyLst.add({"id": 4, "content": "测试4测试4"});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getData();
  }

  @protected
  _search(String content) {
    print("搜索" + content);
    setState(() {
      _isSearch = true;
    });
  }

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
                          Expanded(child: searchWidget()),
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
            child: _isSearch == false
                ? Column(children: <Widget>[
                    _historyLst.length == 0 ? Container() : searchHistory(),
                    historyWidget()
                  ])
                : Container()));
  }

  Widget searchWidget() {
    return Container(
        padding: EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
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
                  onSubmitted: (value) {
                    if (value != '') {
                      _search(value);
                    }
                  },
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
        ]));
  }

  Widget searchHistory() {
    return Padding(
        padding: EdgeInsets.only(left: 12, right: 12, top: 20, bottom: 8),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('搜索历史',
                  style: TextStyle(
                      color: MyColors.black_1a, fontSize: MyFonts.f_16)),
              GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    setState(() {
                      _historyLst.removeRange(0, _historyLst.length);
                    });
                  },
                  child: Text('清空',
                      style: TextStyle(
                          color: MyColors.grey_aa, fontSize: MyFonts.f_14)))
            ]));
  }

  Widget historyWidget() {
    return ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: itemBuilder,
        itemCount: _historyLst.length,
        shrinkWrap: true);
  }

  Widget itemBuilder(BuildContext context, int index) {
    Map _history = _historyLst[index];
    return Column(children: <Widget>[
      GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            setState(() {
              _searchController.text = _history["content"];
            });
            _search(_history["content"]);
          },
          child: Padding(
              padding:
                  EdgeInsets.only(left: 12, right: 12, top: 16, bottom: 16),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(children: <Widget>[
                      Icon(Icons.access_time,
                          color: MyColors.grey_cb, size: 18),
                      SizedBox(width: 12),
                      Text(_history["content"] ?? "",
                          style: TextStyle(
                              color: MyColors.black_32, fontSize: MyFonts.f_14))
                    ]),
                    GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          setState(() {
                            _historyLst.removeAt(index);
                          });
                        },
                        child: Icon(Icons.clear,
                            color: MyColors.grey_cb, size: 18))
                  ]))),
      SeparatorWidget()
    ]);
  }
}
