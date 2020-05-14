import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Common/local/LocalStorage.dart';
import 'package:billsmac_app/Page/community/DetailPage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///Author:chiuhol
///2020-2-24

class FocusWidget extends StatefulWidget {
  @override
  _FocusWidgetState createState() => _FocusWidgetState();
}

class _FocusWidgetState extends State<FocusWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List _articleLst = [];
  
  int _pageIndex = 1;

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

  @protected
  _search() async {
    String _userId = await LocalStorage.get("_id").then((result) {
      return result;
    });
    try {
      BaseOptions options =
          BaseOptions(method: "get", queryParameters: {"q": "following","userId":_userId,"page":_pageIndex,"per_Page":10});
      var dio = new Dio(options);
      var response = await dio.get(Address.getActicles());
      print(response.data.toString());
      if (response.data["status"] == 200) {
        if (mounted) {
          setState(() {
            _articleLst.addAll(response.data["data"]["newArticleLst"]);
          });
        }
      }
    } catch (err) {
      CommonUtil.showMyToast(err.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _search();
  }

  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        color: MyColors.white_fe,
        child: AnimationLimiter(
          child:   SmartRefresher(
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
              child: _articleLst.length == 0
                  ? Center(
                  child: Text('暂时还没有关注的文章',
                      style: TextStyle(
                          color: MyColors.grey_cb,
                          fontSize: MyFonts.f_16)))
                  : ListView.builder(
                physics: BouncingScrollPhysics(),
                  itemBuilder: searchItemBuilder,
                  itemCount: _articleLst.length,
                  shrinkWrap: true))
        ));
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
}
