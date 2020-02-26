import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///Author:chiuhol
///2020-2-24

class TopSearchWidget extends StatefulWidget {
  final List topSearchLst;
  final List topicLst;

  TopSearchWidget({this.topSearchLst, this.topicLst});

  @override
  _TopSearchWidgetState createState() => _TopSearchWidgetState();
}

class _TopSearchWidgetState extends State<TopSearchWidget> {
  int _pageIndex = 1;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
//    _articleLst = [];
//    _pageIndex = 1;
//    loadData_dio_get();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
//    _pageIndex += 1;
//    loadData_dio_get();

    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        color: MyColors.white_fe,
        child: AnimationLimiter(
            child: Column(children: <Widget>[
          Container(
              width: double.infinity,
              height: 45,
              padding: EdgeInsets.only(top: 18,right: 12),
              child: topicListView()),
          SizedBox(height: 8),
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
                  child: widget.topSearchLst.length == 0
                      ? Center(
                          child: Text('暂时还没有热搜的文章',
                              style: TextStyle(
                                  color: MyColors.grey_cb,
                                  fontSize: MyFonts.f_16)))
                      : Container()))
        ])));
  }

  Widget topicListView() {
    return ListView.builder(
        itemBuilder: itemBuilder,
        itemCount: widget.topicLst.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal);
  }

  Widget itemBuilder(BuildContext context, int index) {
    Map _topic = widget.topicLst[index];
    return Padding(
        padding: EdgeInsets.only(left: 12),
        child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (!_topic["isSelected"]) {
                if(mounted){
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
}
