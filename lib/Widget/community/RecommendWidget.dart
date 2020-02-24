import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///Author:chiuhol
///2020-2-24

class RecommendWidget extends StatefulWidget {
  final List recommendLst;

  RecommendWidget({this.recommendLst});

  @override
  _RecommendWidgetState createState() => _RecommendWidgetState();
}

class _RecommendWidgetState extends State<RecommendWidget> {
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
                child: widget.recommendLst.length == 0
                    ? Center(
                        child: Text('暂时还没有推荐的文章',
                            style: TextStyle(
                                color: MyColors.grey_cb,
                                fontSize: MyFonts.f_16)))
                    : Container())));
  }
}
