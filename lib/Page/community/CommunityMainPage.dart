import 'dart:convert';

import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Widget/community/FocusWidget.dart';
import 'package:billsmac_app/Widget/community/RecommendWidget.dart';
import 'package:billsmac_app/Widget/community/TopSearchWidget.dart';
import 'package:http/http.dart' as http;

import 'ArticleMainPage.dart';
import 'SearchMainPage.dart';

///Author:chiuhol
///2020-2-2

class CommunityMainPage extends StatefulWidget {
  @override
  _CommunityMainPageState createState() => _CommunityMainPageState();
}

class _CommunityMainPageState extends State<CommunityMainPage> {
  final List<Tab> tabs = <Tab>[
    new Tab(text: '关注'),
    new Tab(text: '推荐'),
    new Tab(text: '热搜')
  ];
  String _hotSearch = '请输入您要搜索的内容';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 2,
        length: tabs.length,
        child: Scaffold(
            appBar: PreferredSize(
                child: AppBar(
                    elevation: 0,
                    title: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          CommonUtil.openPage(context, SearchMainPage());
                        },
                        child: Container(
                            padding: EdgeInsets.only(top: 8, bottom: 8),
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                                color: MyColors.grey_f0),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                      IconData(0xe63a,
                                          fontFamily: 'MyIcons'),
                                      size: 18,
                                      color: MyColors.grey_cb),
                                  SizedBox(width: 12),
                                  Text(_hotSearch,
                                      style: TextStyle(
                                          color: MyColors.grey_cb,
                                          fontSize: MyFonts.f_16))
                                ]))),
                    backgroundColor: MyColors.white_fe,
                    centerTitle: true,
                    flexibleSpace: Container(
                        padding: EdgeInsets.only(top: 75, left: 18, right: 18),
                        child: Column(children: <Widget>[
                          tabBar(),
                          SeparatorWidget()
                        ]))),
                preferredSize: Size.fromHeight(105)),
            body: TabBarView(children: <Widget>[
              FocusWidget(),
              RecommendWidget(),
              TopSearchWidget()
            ])));
  }

  Widget tabBar() {
    return TabBar(
        tabs: tabs,
        isScrollable: true,
        indicatorColor: MyColors.black_1a,
        indicatorWeight: 3.0,
        indicatorSize: TabBarIndicatorSize.label,
        labelColor: MyColors.black_1a,
        unselectedLabelColor: MyColors.black_1a,
        unselectedLabelStyle: TextStyle(fontSize: 14),
        labelStyle: new TextStyle(fontSize: 16, fontWeight: FontWeight.bold));
  }
}
