import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Widget/community/FocusWidget.dart';
import 'package:billsmac_app/Widget/community/RecommendWidget.dart';
import 'package:billsmac_app/Widget/community/TopSearchWidget.dart';

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
  String _hotSearch = '开窗通风会传播病毒吗';

  List _topicLst = [
    {"type": "全站", "isSelected": false},
    {"type": "科学", "isSelected": false},
    {"type": "数码", "isSelected": false},
    {"type": "理财", "isSelected": false},
    {"type": "体育", "isSelected": false},
    {"type": "时尚", "isSelected": false}
  ];

  List _focusLst = [];
  List _recommendLst = [];
  List _topSearchLst = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return DefaultTabController(
        length: tabs.length,
        child: Scaffold(
            appBar: PreferredSize(
                child: AppBar(
                    elevation: 0,
                    title: Padding(
                        padding: EdgeInsets.only(left: 50, right: 50),
                        child: GestureDetector(
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
                                          size: 26,
                                          color: MyColors.grey_cb),
                                      SizedBox(width: 12),
                                      Text(_hotSearch,
                                          style: TextStyle(
                                              color: MyColors.grey_cb,
                                              fontSize: MyFonts.f_16))
                                    ])))),
                    backgroundColor: MyColors.white_fe,
                    centerTitle: true,
                    flexibleSpace: Container(
                        padding: EdgeInsets.only(top: 75, left: 18, right: 18),
                        child: Column(children: <Widget>[
                          tabBar(),
                          SeparatorWidget(),
                          Container(
                              width: double.infinity,
                              height: 45,
                              padding: EdgeInsets.only(top: 18),
                              child: topicListView())
                        ]))),
                preferredSize: Size.fromHeight(158)),
            body: TabBarView(children: <Widget>[
              FocusWidget(focusLst: _focusLst),
              RecommendWidget(recommendLst: _recommendLst),
              TopSearchWidget(topSearchLst: _topSearchLst)
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

  Widget topicListView() {
    return ListView.builder(
        itemBuilder: itemBuilder,
        itemCount: _topicLst.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal);
  }

  Widget itemBuilder(BuildContext context, int index) {
    Map _topic = _topicLst[index];
    return Padding(
        padding: EdgeInsets.only(left: 12),
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (!_topic["isSelected"]) {
                setState(() {
                  _topicLst.forEach((item) {
                    item["isSelected"] = false;
                  });
                  _topic["isSelected"] = true;
                });
              }
            },
            child: Container(
                padding: EdgeInsets.only(left: 12, right: 12),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    border: Border.all(
                        color: _topic["isSelected"] == true
                            ? MyColors.blue_f6
                            : MyColors.grey_99),
                    color: MyColors.grey_fe),
                child: Center(
                    child: Text(_topic["type"],
                        style: TextStyle(
                            color: _topic["isSelected"] == true
                                ? MyColors.blue_f6
                                : MyColors.grey_99,
                            fontSize: MyFonts.f_14))))));
  }
}
