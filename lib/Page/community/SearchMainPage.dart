import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Common/local/LocalStorage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DetailPage.dart';

///Author:chiuhol
///2020-2-24

class SearchMainPage extends StatefulWidget {
  @override
  _SearchMainPageState createState() => _SearchMainPageState();
}

class _SearchMainPageState extends State<SearchMainPage> {
  TextEditingController _searchController = TextEditingController();
  FocusNode _searchFocusNode = FocusNode();

  List _articleLst = [];
  List _historyLst = [];
  bool _isSearch = false;

  @protected
  _search(String content) async {
    try {
      BaseOptions options =
          BaseOptions(method: "get", queryParameters: {"q": content});
      var dio = new Dio(options);
      var response = await dio.get(Address.getActicles());
      print(response.data.toString());
      if (response.data["status"] == 200) {
        if (mounted) {
          setState(() {
            _articleLst = response.data["data"]["acticle"];
            _isSearch = true;
          });
        }
        _saveHistory(content);
      }
    } catch (err) {
      CommonUtil.showMyToast(err.toString());
    }
  }

  @protected
  _saveHistory(String content)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> _allSearchLst = prefs.getStringList("SearchHistoryLst");//先查
    _allSearchLst.insert(0, content);//合并
    prefs.setStringList("SearchHistoryLst", _allSearchLst);//再存
    _getHistory();
  }

  @protected
  _getHistory()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(mounted){
      setState(() {
        List _lst = prefs.getStringList("SearchHistoryLst");
        if(_lst.length <= 9){
          _historyLst = _lst;
        }else{
          _historyLst = _lst.sublist(0,10);
        }
      });
    }
  }

  @protected
  _removeHistory(int idx,bool isAll)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> _allSearchLst = prefs.getStringList("SearchHistoryLst");//先查
    if(isAll){
      prefs.setStringList("SearchHistoryLst", []);//再存
    }else{
      _allSearchLst.removeAt(idx);//清除某项
      prefs.setStringList("SearchHistoryLst", _allSearchLst);//再存
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getHistory();
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
                                _searchFocusNode.unfocus();
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
                ? SingleChildScrollView(
              child: Column(children: <Widget>[
                _historyLst.length == 0 ? Container() : searchHistory(),
                historyWidget()
              ])
            )
                : _articleLst.length == 0
                    ? Container(
                        alignment: Alignment.center,
                        child: Text('暂无你要搜索的内容~',
                            style: TextStyle(
                                color: MyColors.grey_cb,
                                fontSize: MyFonts.f_16)))
                    : ListView.builder(
                        itemBuilder: searchItemBuilder,
                        itemCount: _articleLst.length,
                        shrinkWrap: true)));
  }

  Widget searchItemBuilder(BuildContext context, int index) {
    Map _article = _articleLst[index];
    return Padding(
        padding: EdgeInsets.only(left: 12),
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (_article["_id"] != null && _article["_id"] != '') {
                CommonUtil.openPage(
                    context, DetailPage(articleId: _article["_id"]));
              } else {
                CommonUtil.showMyToast("请刷新页面");
              }
            },
            child: Column(children: <Widget>[
              index == 0 ? SizedBox(height: 18) : SizedBox(),
              Container(
                  color: MyColors.white_fe,
                  padding: EdgeInsets.only(top: 18, bottom: 18),
                  child: Row(children: <Widget>[
                    Expanded(
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(left: 8, right: 5),
                              child: Text((index + 1).toString(),
                                  style: TextStyle(
                                      color: MyColors.grey_99,
                                      fontSize: MyFonts.f_18,
                                      fontWeight: FontWeight.bold))),
                          SizedBox(width: 8),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(_article["title"] ?? "",
                                    style: TextStyle(
                                        color: MyColors.black_1a,
                                        fontSize: MyFonts.f_16,
                                        fontWeight: (index == 0 ||
                                                index == 1 ||
                                                index == 2)
                                            ? FontWeight.bold
                                            : FontWeight.normal)),
                                SizedBox(height: 5),
                                _article["subTitle"] != null
                                    ? Text(_article["subTitle"],
                                        style: TextStyle(
                                            color: MyColors.grey_99,
                                            fontSize: MyFonts.f_15))
                                    : Text(''),
                                SizedBox(height: 5),
                                Text(_article["UnitTen"].toString() + "热度",
                                    style: TextStyle(
                                        color: MyColors.grey_99,
                                        fontSize: MyFonts.f_15))
                              ])
                        ])),
                    (_article["thumbnail"] != null &&
                            _article["thumbnail"] != '')
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                                "http://116.62.141.151" +
                                    _article["thumbnail"]
                                        .toString()
                                        .substring(21),
                                width: 80,
                                height: 60))
                        : Container()
                  ])),
              SeparatorWidget()
            ])));
  }

  Widget searchWidget() {
    return Container(
        padding: EdgeInsets.only(left: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            color: MyColors.grey_f0),
        child: Row(children: <Widget>[
          Icon(IconData(0xe63a, fontFamily: 'MyIcons'),
              size: 18, color: MyColors.grey_99),
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
                  onChanged: (value){
                    if(mounted){
                      setState(() {
                        if(value == ''){
                          _isSearch = false;
                        }else{
                          _search(value);
                        }
                      });
                    }
                  },
                  focusNode: _searchFocusNode,
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
                    if (mounted) {
                      setState(() {
                        _historyLst.removeRange(0, _historyLst.length);
                        _removeHistory(0, true);
                      });
                    }
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
    return Column(children: <Widget>[
      GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            if (mounted) {
              setState(() {
                _searchController.text = _historyLst[index];
                _search(_historyLst[index]);
              });
            }
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
                      Text(_historyLst[index] ?? "",
                          style: TextStyle(
                              color: MyColors.black_32, fontSize: MyFonts.f_14))
                    ]),
                    GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          if (mounted) {
                            setState(() {
                              _historyLst.removeAt(index);
                              _removeHistory(index,false);
                            });
                          }
                        },
                        child: Icon(Icons.clear,
                            color: MyColors.grey_cb, size: 18))
                  ]))),
      SeparatorWidget()
    ]);
  }
}
