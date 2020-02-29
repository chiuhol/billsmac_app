import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Page/community/DetailPage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///Author:chiuhol
///2020-2-24

class TopSearchWidget extends StatefulWidget {
  final List topicLst;

  TopSearchWidget({this.topicLst});

  @override
  _TopSearchWidgetState createState() => _TopSearchWidgetState();
}

class _TopSearchWidgetState extends State<TopSearchWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List _articleLst = [];
  
  int _pageIndex = 1;

  List _topicLst = [
    {"type": "全站", "isSelected": false},
    {"type": "科学", "isSelected": false},
    {"type": "数码", "isSelected": false},
    {"type": "理财", "isSelected": false},
    {"type": "体育", "isSelected": false},
    {"type": "时尚", "isSelected": false},
    {"type": "美食", "isSelected": false}
  ];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    _pageIndex = 1;
    _articleLst = [];
    _search();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _pageIndex++;
    _search();
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _search();
  }

  @protected
  _search() async {
    try {
      BaseOptions options = BaseOptions(method: "get", queryParameters: {"page":_pageIndex,"per_Page":10});
      var dio = new Dio(options);
      var response = await dio.get(Address.getActicles());
      print(response.data.toString());
      if (response.data["status"] == 200) {
        if (mounted) {
          setState(() {
            _articleLst.addAll(response.data["data"]["acticle"]);
          });
        }
      }
    } catch (err) {
      CommonUtil.showMyToast(err.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        color: MyColors.white_fe,
        child: AnimationLimiter(
            child: Column(children: <Widget>[
          Container(width: double.infinity, height: 30, child: topicListView()),
          Expanded(
              child: SmartRefresher(
                  controller: _refreshController,
                  onRefresh: _onRefresh,
                  onLoading: _onLoading,
                  enablePullDown: true,
                  enablePullUp: true,
                  header: WaterDropHeader(),
                  footer: CustomFooter(
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
                    return Container(height: 55, child: Center(child: body));
                  }),
                  child: _topicLst.length == 0
                      ? Center(
                          child: Text('暂时还没有热搜的文章',
                              style: TextStyle(
                                  color: MyColors.grey_cb,
                                  fontSize: MyFonts.f_16)))
                      : topSearchListView()))
        ])));
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
                if (mounted) {
                  setState(() {
                    widget.topicLst.forEach((item) {
                      item["isSelected"] = false;
                    });
                    _topic["isSelected"] = true;
                  });
                }
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

  Widget topSearchListView() {
    return ListView.builder(
        itemBuilder: topSearchItemBuilder,
        itemCount: _articleLst.length,
        shrinkWrap: true);
  }

  Widget topSearchItemBuilder(BuildContext context, int index) {
    Map _topSearch = _articleLst[index];
    return Padding(
        padding: EdgeInsets.only(left: 12),
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (_topSearch["_id"] != null && _topSearch["_id"] != '') {
                CommonUtil.openPage(
                    context, DetailPage(articleId: _topSearch["_id"]));
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
                          icon(index),
                          SizedBox(width: 8),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(_topSearch["title"] ?? "",
                                    style: TextStyle(
                                        color: MyColors.black_1a,
                                        fontSize: MyFonts.f_16,
                                        fontWeight: (index == 0 ||
                                                index == 1 ||
                                                index == 2)
                                            ? FontWeight.bold
                                            : FontWeight.normal)),
                                SizedBox(height: 5),
                                _topSearch["subTitle"] != null
                                    ? Text(_topSearch["subTitle"],
                                        style: TextStyle(
                                            color: MyColors.grey_99,
                                            fontSize: MyFonts.f_15))
                                    : Text(''),
                                SizedBox(height: 5),
                                Text(_topSearch["UnitTen"].toString() + "热度",
                                    style: TextStyle(
                                        color: MyColors.grey_99,
                                        fontSize: MyFonts.f_15))
                              ])
                        ])),
                    (_topSearch["thumbnail"] != null &&
                            _topSearch["thumbnail"] != '')
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                                "http://116.62.141.151" +
                                    _topSearch["thumbnail"]
                                        .toString()
                                        .substring(21),
                                width: 80,
                                height: 60))
                        : Container()
                  ])),
              SeparatorWidget()
            ])));
  }

  Widget icon(int idx) {
    if (idx == 0) {
      return Icon(
        Icons.looks_one,
        color: MyColors.red_5c,
        size: 24,
      );
    } else if (idx == 1) {
      return Icon(
        Icons.looks_two,
        color: MyColors.orange_68,
        size: 24,
      );
    } else if (idx == 2) {
      return Icon(
        Icons.looks_3,
        color: MyColors.orange_76,
        size: 24,
      );
    } else {
      return Padding(
          padding: EdgeInsets.only(left: 8, right: 5),
          child: Text((idx + 1).toString(),
              style: TextStyle(
                  color: MyColors.grey_99,
                  fontSize: MyFonts.f_18,
                  fontWeight: FontWeight.bold)));
    }
  }
}
