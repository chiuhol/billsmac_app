import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///Author:chiuhol
///2020-2-24

class FeedbackHistoryPage extends StatefulWidget {
  @override
  _FeedbackHistoryPageState createState() => _FeedbackHistoryPageState();
}

class _FeedbackHistoryPageState extends State<FeedbackHistoryPage> {
  List _historyLst = [];

  int _pageIndex = 1;

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async {
    _historyLst = [];
    _getLst();
      _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _pageIndex += 1;

    _refreshController.loadComplete();
  }

  @protected
  _getLst(){
    _historyLst.add({"type": "其他", "content": "没什么好说的", "time": "2020-02-24"});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getLst();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
            title: "反馈历史",
            color: MyColors.white_fe,
            isBack: true,
            backIcon: Icon(Icons.keyboard_arrow_left,
                color: MyColors.black_32, size: 28)),
        body: Container(
            color: MyColors.grey_f6,
            width: double.infinity,
            height: double.infinity,
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
                child: _historyLst.length == 0
                    ? Center(
                    child: Text('暂时还没有反馈历史哦~',
                        style: TextStyle(
                            color: MyColors.grey_cb, fontSize: MyFonts.f_15)))
                    : ListView.builder(
                    itemBuilder: itemBuilder,
                    itemCount: _historyLst.length,
                    shrinkWrap: true))));
  }

  Widget itemBuilder(BuildContext context, int index) {
    Map _history = _historyLst[index];
    return Container(
        width: double.infinity,
        color: MyColors.white_fe,
        padding: EdgeInsets.only(left: 12, right: 12, bottom: 12, top: 12),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(_history["type"] ?? "",
                        style: TextStyle(
                            color: MyColors.black_32, fontSize: MyFonts.f_15)),
                    Text(_history["time"] ?? "",
                        style: TextStyle(
                            color: MyColors.black_32, fontSize: MyFonts.f_12))
                  ]),
              SizedBox(height: 8),
              Text(_history["content"] ?? "",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: MyColors.black_32, fontSize: MyFonts.f_15))
            ]));
  }
}
