import 'dart:convert';
import 'dart:io';

import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Common/local/LocalStorage.dart';
import 'package:billsmac_app/Widget/NumKeyBoard.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:apifm/apifm.dart' as Apifm;

import 'SearchPage.dart';
import 'TallyDetailPage.dart';
import 'calendar/CalendarMainPage.dart';
import 'chatroom/ObjectDetailPage.dart';
import 'more/MoreMainPage.dart';
import 'statistics/StatisticsMainPage.dart';

///Author:chiuhol
///2020-2-3

class TallyMainPage extends StatefulWidget {
  @override
  _TallyMainPageState createState() => _TallyMainPageState();
}

class _TallyMainPageState extends State<TallyMainPage>
    with SingleTickerProviderStateMixin {
  String _chatroomName = '聊天室名称';
  String _backgroundUrl = "";
  DateTime _now = DateTime.now();
  num _mouth;

  String _avatar = 'http://p2.qhimgs4.com/t014719903aa3245983.jpg';
  String _objectAvatar = "'https://b-ssl.duitang.com/uploads/item/201701/13/20170113101107_aP5Fn.thumb.700_0.jpeg'";

  int _pageIndex = 1;

  num _expendTotle = 0;//总支出
  num _incomeTotle = 0;//总收入

  List _categoryLst = [
    {"name": "热门"},
    {"name": "收"},
    {"name": "食"},
    {"name": "购"},
    {"name": "行"},
    {"name": "育"},
    {"name": "乐"},
    {"name": "情"},
    {"name": "住"},
    {"name": "医"},
    {"name": "投"},
    {"name": "其"},
  ];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    _getChatContent();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _pageIndex += 1;

    _refreshController.loadComplete();
  }

  TabController _tabController;

  List _chatContentLst = [];

  //从本地储存获取聊天室信息
  @protected
  _getLocalStorage()async{
    String _name = await LocalStorage.get("chatName").then((result) {
      return result;
    });
    String _background = await LocalStorage.get("background").then((result) {
      return result;
    });
    if(mounted){
      setState(() {
        _chatroomName = _name;
        _backgroundUrl = _background;
      });
    }
  }

  @protected
  _checkToken() async {
    String _token = await LocalStorage.get("Token").then((value) {
      return value;
    });
    var res = await Apifm.checkToken(_token);
    if (res["code"] == 0) {
      return;
    } else {
      CommonUtil.showMyToast("请重新登录");
    }
  }

  //获取当月的总收入与总支出
  @protected
  _getTotle() async {
    String _chatroomId = await LocalStorage.get("chatroomId").then((result) {
      return result;
    });
    try {
      BaseOptions options = BaseOptions(
          method: "get", queryParameters: {"year": _now.year, "month": _now.month});
      var dio = new Dio(options);
      var response = await dio.get(Address.staticByType(_chatroomId));
      print(response.data.toString());
      if (response.data["status"] == 200) {
        if (mounted) {
          setState(() {
            _expendTotle = response.data["data"]["expendTotle"] ?? 0;
            _incomeTotle = response.data["data"]["incomeTotle"] ?? 0;
          });
        }
      }
    } catch (err) {
      print(err.toString());
      CommonUtil.showMyToast("系统开小差了~");
    }
  }

  @protected
  _getChatroom() async {
    String _userId = await LocalStorage.get("_id").then((result) {
      return result;
    });
    String _token = await LocalStorage.get("token").then((result) {
      return result;
    });
    try {
      BaseOptions options = BaseOptions(
          method: "get",
          headers: {HttpHeaders.AUTHORIZATION: "Bearer $_token"});
      var dio = new Dio(options);
      var response = await dio.get(Address.getChatroom(_userId));
      print(response.data.toString());
      if (response.data["status"] == 200) {
        var _chatroom = response.data["data"]["chatroom"];
        if (mounted) {
          setState(() {
            LocalStorage.save("chatroomId", _chatroom["_id"]);
            LocalStorage.save("chatName", _chatroom["chatName"]);
            _chatroomName = _chatroom["chatName"];
            _backgroundUrl = _chatroom["background"];
            LocalStorage.save("background", _chatroom["background"]);
            _getChatContent();
          });
        }
      }
    } catch (err) {
      CommonUtil.showMyToast(err.toString());
    }
  }

  @protected
  _getChatContent() async {
    String _chatroomId = await LocalStorage.get("chatroomId").then((result) {
      return result;
    });
    String _token = await LocalStorage.get("token").then((result) {
      return result;
    });
    try {
      BaseOptions options = BaseOptions(
          method: "get",
          headers: {HttpHeaders.AUTHORIZATION: "Bearer $_token"});
      var dio = new Dio(options);
      var response = await dio.get(Address.getChatContent(_chatroomId));
      print(response.data.toString());
      if (response.data["status"] == 200) {
        if (mounted) {
          setState(() {
            _chatContentLst = response.data["data"]["chatContent"];
            _chatContentLst = _chatContentLst.reversed.toList();//倒置
          });
        }
      }
    } catch (err) {
      CommonUtil.showMyToast(err.toString());
    }
  }

  @protected
  _saveChatContent(String typeStr, String amount,String amountType) async {
    String _chatroomId = await LocalStorage.get("chatroomId").then((result) {
      return result;
    });
    String _token = await LocalStorage.get("token").then((result) {
      return result;
    });
    try {
      BaseOptions options = BaseOptions(
          method: "post",
          headers: {HttpHeaders.AUTHORIZATION: "Bearer $_token"});
      var dio = new Dio(options);
      var response =
          await dio.post(Address.saveChatContent(_chatroomId), data: {
        "chatroomId": _chatroomId,
        "rightcontent": {
          "typeStr": typeStr,
          "amountType": amountType,
          "amount": amount,
          "remark": ""
        }
      });
      print(response.data.toString());
      if (response.data["status"] == 200) {
        if (mounted) {
          setState(() {
            _chatContentLst.add(response.data["data"]["chatContent"]);
          });
        }
      }
    } catch (err) {
      CommonUtil.showMyToast(err.toString());
    }
  }

  @protected
  _getPersonalMsg()async{
    String _avatarUrl = await LocalStorage.get("avatar_url").then((result) {
      return result;
    });
    if(mounted){
      setState(() {
        _avatar = _avatarUrl;
      });
    }
  }

  @protected
  _getObject()async{
    String _userId = await LocalStorage.get("_id").then((result) {
      return result;
    });
    try {
      BaseOptions options =
      BaseOptions(method: "get");
      var dio = new Dio(options);
      var response = await dio.get(Address.getObject(_userId));
      print(response.data.toString());
      if (response.data["status"] == 200) {
        var res = response.data["data"]["objects"];
        if (mounted) {
          setState(() {
            if(res.length != 0){
              _objectAvatar = res[0]["avatar"];
            }
          });
        }
      }
    } catch (err) {
      CommonUtil.showMyToast("系统开小差了~");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getPersonalMsg();//获取用户信息
//    _checkToken();
    _getChatroom(); //获取聊天室信息
    _getObject();//获取对象头像
    _mouth = _now.month;
    _getTotle();
    _tabController = TabController(
      length: _categoryLst.length,
      vsync: this,
    );
  }

  @protected
  _tally() {
    showModalBottomSheet(
        backgroundColor: MyColors.black_45,
        context: context,
        builder: (BuildContext context) {
          return BottomSheet(_categoryLst, _tabController);
        }).then((value) {
      if (value != null) {
        _saveChatContent(value["type"], value["amount"],value["amountType"]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            child: AppBar(
                elevation: 0,
                title: appBarTitle(),
                backgroundColor: MyColors.white_fe,
                centerTitle: true,
                flexibleSpace: flexibleSpaceWidget(),
                actions: <Widget>[rightEvenWidget()]),
            preferredSize: Size.fromHeight(108)),
        body: Container(
          padding: EdgeInsets.only(bottom: 45),
            width: double.infinity,
            decoration: BoxDecoration(
                color: MyColors.white_fe,
                image: DecorationImage(
                    image: NetworkImage(_backgroundUrl), fit: BoxFit.cover)),
            child: SmartRefresher(
                controller: _refreshController,
                onRefresh: _onLoading,
                onLoading: _onRefresh,
                enablePullDown: true,
                enablePullUp: true,
                footer: WaterDropHeader(),
                header: CustomFooter(
                    builder: (BuildContext context, LoadStatus mode) {
                  Widget body;
                  if (mode == LoadStatus.idle) {
                    body = Text("上拉加载");
                  } else if (mode == LoadStatus.loading) {
                    body = CupertinoActivityIndicator();
                  } else if (mode == LoadStatus.failed) {
                    body = Text("加载失败!请再试试!");
                  } else {
                    body = Text("没有更多数据了");
                  }
                  return Container(height: 20, child: Center(child: body));
                }),
                child: _chatContentLst.length == 0
                    ? Center(
                        child: Text("快去记下你的第一笔帐吧~",
                            style: TextStyle(
                                color: MyColors.grey_cb,
                                fontSize: MyFonts.f_16)))
                    : ListView.builder(
                        itemBuilder: itemBuilderChat,
                        itemCount: _chatContentLst.length,
                        shrinkWrap: true,
                        physics: BouncingScrollPhysics()))),
        bottomSheet: bottomSheetWidget());
  }

  Widget appBarTitle() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(_chatroomName,
              style: TextStyle(
                  color: MyColors.black_32,
                  fontSize: MyFonts.f_18,
                  fontWeight: FontWeight.bold)),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Text(_mouth.toString() + '月',
                style:
                    TextStyle(color: MyColors.grey_aa, fontSize: MyFonts.f_14)),
            SizedBox(width: 5),
            Text('收' + _incomeTotle.toString() + ' / ' + '支' + _expendTotle.toString(),
                style:
                    TextStyle(color: MyColors.grey_aa, fontSize: MyFonts.f_14))
          ]),
          Padding(
              padding: EdgeInsets.only(left: 0, right: 0),
              child: Container(height: 1.0, color: MyColors.divider))
        ]);
  }

  Widget flexibleSpaceWidget() {
    return Container(
        padding: EdgeInsets.only(top: 90, left: 18, right: 18),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    CommonUtil.openPage(context, SearchPage());
                  },
                  child: Row(children: <Widget>[
                    Icon(IconData(0xe63a, fontFamily: 'MyIcons'),
                        size: 20, color: MyColors.orange_67),
                    SizedBox(width: 8),
                    Text('输入晚餐试试看',
                        style: TextStyle(
                            color: MyColors.grey_cb, fontSize: MyFonts.f_14))
                  ])),
              Row(children: <Widget>[
                GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      CommonUtil.openPage(context, CalendarMainPage());
                    },
                    child: Icon(IconData(0xe685, fontFamily: 'MyIcons'),
                        size: 26, color: MyColors.orange_67)),
                SizedBox(width: 24),
                GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      CommonUtil.openPage(context, StatisticsMainPage());
                    },
                    child: Icon(IconData(0xe64d, fontFamily: 'MyIcons'),
                        size: 26, color: MyColors.orange_67))
              ])
            ]));
  }

  Widget rightEvenWidget() {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Container(
            padding: EdgeInsets.only(right: 10),
            child: Icon(IconData(0xe637, fontFamily: 'MyIcons'),
                size: 28, color: MyColors.black_32)),
        onTap: () {
          CommonUtil.openPage(context, MoreMainPage()).then((value){
            _getLocalStorage();
          });
        });
  }

  Widget bottomSheetWidget() {
    return Container(
        width: double.infinity,
        height: 45,
        color: MyColors.orange_67,
        child: Padding(
            padding: EdgeInsets.only(left: 18, right: 18, top: 5, bottom: 5),
            child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: _tally,
                child: Container(
                    decoration: BoxDecoration(
                        color: MyColors.white_f6,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                        padding: EdgeInsets.only(left: 18, top: 6),
                        child: Text('点击开始记账',
                            style: TextStyle(
                                color: MyColors.grey_aa,
                                fontSize: MyFonts.f_14)))))));
  }

  Widget itemBuilderChat(BuildContext context, int index) {
    Map _chat = _chatContentLst[index];
    return Column(children: <Widget>[
      time(_chat["createdAt"]??""),
      rightObject(_chat),
      leftObject(_chat["leftcontent"]??"")
    ]);
  }

  Widget leftObject(String title) {
    if(title == ''){
      return Container();
    }
    return Container(
        padding: EdgeInsets.only(left: 12, top: 12),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                CommonUtil.openPage(context, ObjectDetailPage());
              },
              child: ClipOval(
                  child: Image.network(
                      _objectAvatar,
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover))),
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

  Widget rightObject(Map chatContent) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          CommonUtil.openPage(
              context,
              TallyDetailPage(detail: chatContent)).then((value) {
            if (value != null && value == "success") {
              _getChatContent();
            }
          });
        },
        child: Container(
            padding: EdgeInsets.only(right: 12, top: 12),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: <
                Widget>[
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
                          child: Text(
                              (chatContent["rightcontent"]["typeStr"] ??
                                  "") +
                                      "：" +
                                      chatContent["rightcontent"]["amount"] +
                                      (chatContent["rightcontent"]["remark"] !=
                                              ""
                                          ? "，${chatContent["rightcontent"]["remark"]}"
                                          : ""),
                              style: TextStyle(
                                  color: MyColors.white_fe,
                                  fontSize: MyFonts.f_14))))),
              SizedBox(width: 12),
              ClipOval(
                  child: Image.network(
                      "http://$_avatar",
                      width: 45,
                      height: 45,
                      fit: BoxFit.cover))
            ])));
  }

  Widget time(String date) {
    return Container(
        padding: EdgeInsets.only(top: 18),
        alignment: Alignment.center,
        child: Text(CommonUtil.getTimeDuration(date),
            style: TextStyle(color: MyColors.grey_aa, fontSize: MyFonts.f_12)));
  }
}

class BottomSheet extends StatefulWidget {
  final List tabLst;
  final TabController tabController;

  BottomSheet(this.tabLst, this.tabController);

  @override
  _BottomSheetState createState() => _BottomSheetState();
}

typedef clickCallback = void Function(String value);

class _BottomSheetState extends State<BottomSheet> {
  String _type = "早餐";
  String _tallyType = "expend";//支出或收入
  String _account = "";
  bool _inputStatus = false;
  TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return tallyTypeWidget();
  }

  Widget tallyTypeWidget() {
    return Container(
        height: 300,
        child: Column(children: <Widget>[
          Container(
              width: double.infinity,
              height: 45,
              color: MyColors.black_45,
              child: Padding(
                  padding:
                      EdgeInsets.only(left: 18, right: 18, top: 5, bottom: 5),
                  child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {},
                      child: Container(
                          decoration: BoxDecoration(
                              color: MyColors.white_f6,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                          child: Padding(
                              padding:
                                  EdgeInsets.only(left: 18, top: 6, right: 18),
                              child: Center(
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                    GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () {
                                          setState(() {
                                            _inputStatus = false;
                                          });
                                        },
                                        child: Text(_type ?? "",
                                            style: TextStyle(
                                                color: MyColors.black_32,
                                                fontSize: MyFonts.f_18))),
                                    GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () {
                                          setState(() {
                                            _inputStatus = true;
                                            print(_inputStatus);
                                          });
                                        },
                                        child: Text(
                                            (_account == '' || _account == null)
                                                ? "0.00"
                                                : _account,
                                            style: TextStyle(
                                                color: MyColors.red_5c,
                                                fontSize: MyFonts.f_22)))
                                  ]))))))),
          Container(
              margin: EdgeInsets.only(left: 18, right: 18),
              color: MyColors.black_5f,
              height: 2),
          _inputStatus == false
              ? Container(
                  height: 252,
                  child: Column(children: <Widget>[
                    Expanded(
                        child: TabBarView(
                            controller: widget.tabController,
                            children: _buildPageList())),
                    Container(
                        height: 38,
                        width: double.infinity,
                        color: MyColors.black_5f,
                        child: TabBar(
                            indicator: const BoxDecoration(),
                            isScrollable: true,
                            controller: widget.tabController,
                            unselectedLabelColor: MyColors.white_fe,
                            unselectedLabelStyle: TextStyle(fontSize: 14),
                            labelStyle: new TextStyle(fontSize: 16),
                            labelColor: MyColors.orange_68,
                            tabs: widget.tabLst.map((item) {
                              return item["name"] == "热门"
                                  ? Tab(
                                      icon: Icon(
                                          IconData(0xe62b,
                                              fontFamily: 'MyIcons'),
                                          size: 18,
                                          color: MyColors.orange_67))
                                  : Tab(text: item["name"] ?? "");
                            }).toList()))
                  ]))
              : NumberKeyboardActionSheet(
                  amount: _account,
                  controller: controller,
                  onClick: (value) {
                    setState(() {
                      if (value.contains("确定")) {
                        _account = value.replaceAll("确定", "");
                        if (_account.contains("-")) {
                          CommonUtil.showMyToast("输入金额不能小于0");
                          return;
                        }
                        Navigator.of(context)
                            .pop({"type": _type, "amount": _account,"amountType":_tallyType});
                      } else {
                        _account = value;
                      }
                    });
                  })
        ]));
  }

  List<Widget> _buildPageList() {
    List<Widget> pages = List();
    Widget page;
    for (int i = 0; i < widget.tabLst.length; i++) {
      page = TallyTypeList(
        idx: i,
        onClick: (value) {
          setState(() {
            List _res = value.split(",");
            _type = _res[0];
            _tallyType = _res[1];
          });
        },
      );
      pages.add(page);
    }

    return pages;
  }
}

class TallyTypeList extends StatefulWidget {
  TallyTypeList({Key key, this.onClick, this.idx}) : super(key: key);
  final int idx;
  final clickCallback onClick;

  @override
  _TallyTypeListState createState() => _TallyTypeListState();
}

class _TallyTypeListState extends State<TallyTypeList> {
  List _hotLst = [
    {"iconName": 0xe66d, "typeName": "早餐","type":"expend"},
    {"iconName": 0xe62c, "typeName": "午餐","type":"expend"},
    {"iconName": 0xe6ec, "typeName": "晚餐","type":"expend"}
  ]; //热门
  List _incomeLst = [
    {"iconName": 0xe651, "typeName": "工资","type":"income"},
    {"iconName": 0xe66d, "typeName": "收入","type":"income"},
    {"iconName": 0xe612, "typeName": "投资收入","type":"income"},
    {"iconName": 0xe8c6, "typeName": "兼职外快","type":"income"},
    {"iconName": 0xe678, "typeName": "生活费","type":"income"},
    {"iconName": 0xe65b, "typeName": "红包","type":"income"},
    {"iconName": 0xe51b, "typeName": "二手闲置","type":"income"},
    {"iconName": 0xe521, "typeName": "借入","type":"income"},
    {"iconName": 0xe602, "typeName": "报销","type":"income"},
  ]; //收
  List _eatLst = [
    {"iconName": 0xe66d, "typeName": "早餐","type":"expend"},
    {"iconName": 0xe62c, "typeName": "午餐","type":"expend"},
    {"iconName": 0xe6ec, "typeName": "晚餐","type":"expend"},
    {"iconName": 0xe622, "typeName": "零食","type":"expend"},
    {"iconName": 0xe60b, "typeName": "饮料","type":"expend"},
    {"iconName": 0xe638, "typeName": "买菜","type":"expend"},
    {"iconName": 0xe633, "typeName": "酒水","type":"expend"},
    {"iconName": 0xe615, "typeName": "水果","type":"expend"},
    {"iconName": 0xe6c7, "typeName": "香烟","type":"expend"},
  ]; //食
  List _buyLst = [
    {"iconName": 0xe679, "typeName": "购物","type":"expend"},
    {"iconName": 0xe610, "typeName": "生活用品","type":"expend"},
    {"iconName": 0xe60a, "typeName": "服饰","type":"expend"},
    {"iconName": 0xe68f, "typeName": "包包","type":"expend"},
    {"iconName": 0xe623, "typeName": "鞋子","type":"expend"},
    {"iconName": 0xe5a0, "typeName": "淘宝","type":"expend"},
    {"iconName": 0xe634, "typeName": "护肤彩妆","type":"expend"},
    {"iconName": 0xe606, "typeName": "饰品","type":"expend"},
    {"iconName": 0xe75d, "typeName": "美容美甲","type":"expend"},
  ]; //购
  List _walkLst = [
    {"iconName": 0xe67b, "typeName": "交通","type":"expend"},
    {"iconName": 0xe504, "typeName": "加油","type":"expend"},
    {"iconName": 0xe5b6, "typeName": "停车费","type":"expend"},
    {"iconName": 0xe501, "typeName": "打车","type":"expend"},
    {"iconName": 0xe686, "typeName": "地铁","type":"expend"},
    {"iconName": 0xe68b, "typeName": "火车","type":"expend"},
    {"iconName": 0xe60e, "typeName": "公交车","type":"expend"},
    {"iconName": 0xe631, "typeName": "机票","type":"expend"},
    {"iconName": 0xe51d, "typeName": "修车养车","type":"expend"},
  ]; //行
  List _babyLst = [
    {"iconName": 0xe691, "typeName": "教育","type":"expend"},
    {"iconName": 0xe509, "typeName": "学习","type":"expend"},
    {"iconName": 0xe63d, "typeName": "书籍","type":"expend"},
    {"iconName": 0xe647, "typeName": "文具","type":"expend"},
    {"iconName": 0xe665, "typeName": "学费","type":"expend"},
    {"iconName": 0xe732, "typeName": "考试","type":"expend"},
    {"iconName": 0xe506, "typeName": "培训","type":"expend"},
    {"iconName": 0xe62a, "typeName": "辅导班","type":"expend"},
    {"iconName": 0xe617, "typeName": "育儿","type":"expend"},
  ]; //育
  List _happyLst = [
    {"iconName": 0xe775, "typeName": "娱乐","type":"expend"},
    {"iconName": 0xe6ba, "typeName": "电影","type":"expend"},
    {"iconName": 0xe62c, "typeName": "游戏","type":"expend"},
    {"iconName": 0xe624, "typeName": "追星","type":"expend"},
    {"iconName": 0xe603, "typeName": "KTV","type":"expend"},
    {"iconName": 0xe605, "typeName": "酒吧","type":"expend"},
    {"iconName": 0xe68c, "typeName": "运动健身","type":"expend"},
    {"iconName": 0xe639, "typeName": "旅游","type":"expend"},
    {"iconName": 0xe662, "typeName": "洗浴","type":"expend"},
  ]; //乐
  List _emotionLst = [
    {"iconName": 0xe65b, "typeName": "红包","type":"expend"},
    {"iconName": 0xe502, "typeName": "礼物","type":"expend"},
    {"iconName": 0xe619, "typeName": "孝敬","type":"expend"},
    {"iconName": 0xe779, "typeName": "打赏","type":"expend"},
    {"iconName": 0xe610, "typeName": "借出","type":"expend"},
  ]; //情
  List _towardLst = [
    {"iconName": 0xe628, "typeName": "房租","type":"expend"},
    {"iconName": 0xe682, "typeName": "房贷","type":"expend"},
    {"iconName": 0xe640, "typeName": "水费","type":"expend"},
    {"iconName": 0xe518, "typeName": "电费","type":"expend"},
    {"iconName": 0xe63f, "typeName": "燃气费","type":"expend"},
    {"iconName": 0xe615, "typeName": "物业费","type":"expend"},
    {"iconName": 0xe657, "typeName": "网络费","type":"expend"},
    {"iconName": 0xe6eb, "typeName": "话费","type":"expend"},
    {"iconName": 0xe621, "typeName": "家居","type":"expend"},
  ]; //住
  List _medicineLst = [
    {"iconName": 0xe62d, "typeName": "药品","type":"expend"},
    {"iconName": 0xe6a7, "typeName": "医院","type":"expend"},
    {"iconName": 0xe609, "typeName": "养生保健","type":"expend"},
  ]; //医
  List _putintoLst = [
    {"iconName": 0xe653, "typeName": "网贷","type":"expend"},
    {"iconName": 0xe645, "typeName": "基金","type":"expend"},
    {"iconName": 0xe641, "typeName": "股票","type":"expend"},
    {"iconName": 0xe60b, "typeName": "银行理财","type":"expend"},
    {"iconName": 0xe62c, "typeName": "投资亏损","type":"expend"},
  ]; //投
  List _otherLst = [
    {"iconName": 0xe563, "typeName": "其他","type":"expend"},
    {"iconName": 0xe65f, "typeName": "意外损失","type":"expend"},
    {"iconName": 0xe675, "typeName": "手续费","type":"expend"},
  ]; //其

  @override
  Widget build(BuildContext context) {
    List _lst = [];
    if (widget.idx == 0) {
      _lst = _hotLst;
    } else if (widget.idx == 1) {
      _lst = _incomeLst;
    } else if (widget.idx == 2) {
      _lst = _eatLst;
    } else if (widget.idx == 3) {
      _lst = _buyLst;
    } else if (widget.idx == 4) {
      _lst = _walkLst;
    } else if (widget.idx == 5) {
      _lst = _babyLst;
    } else if (widget.idx == 6) {
      _lst = _happyLst;
    } else if (widget.idx == 7) {
      _lst = _emotionLst;
    } else if (widget.idx == 8) {
      _lst = _towardLst;
    } else if (widget.idx == 9) {
      _lst = _medicineLst;
    } else if (widget.idx == 10) {
      _lst = _putintoLst;
    } else if (widget.idx == 11) {
      _lst = _otherLst;
    }
    return builder(_lst);
  }

  builder(List lst) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 7,
            crossAxisSpacing: 8,
            crossAxisCount: 5,
            childAspectRatio: 1),
        itemBuilder: (BuildContext context, int index) {
          Map _lst = lst[index];
          return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                setState(() {
                  widget.onClick(_lst["typeName"]+","+_lst["type"]);
                });
              },
              child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(IconData(_lst["iconName"], fontFamily: 'MyIcons'),
                            size: 28, color: MyColors.orange_56),
                        Padding(
                            padding: EdgeInsets.only(top: 5),
                            child: Text(_lst["typeName"] ?? "",
                                style: TextStyle(color: MyColors.grey_a0)))
                      ])));
        },
        itemCount: lst.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics());
  }
}
