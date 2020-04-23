import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///Author:chiuhol
///2020-4-23

class FeedbackManage extends StatefulWidget {
  @override
  _FeedbackManageState createState() => _FeedbackManageState();
}

class _FeedbackManageState extends State<FeedbackManage> {
  bool _isMenuShow = false;

  OverlayEntry _overlayEntry;
  GlobalKey _appMenuKey = GlobalKey();

  OverlayEntry _createOverlayEntry(BuildContext context) {
    RenderBox renderBox = context.findRenderObject();
    var size = renderBox.size;
    renderBox = _appMenuKey.currentContext.findRenderObject();
    var menusize = renderBox.size;
    var menupositon = renderBox.localToGlobal(Offset.zero);
    return OverlayEntry(
        builder: (context) => Positioned(
            top: menupositon.dy + menusize.height,
            width: size.width,
            child: Container(
                margin: EdgeInsets.only(left: 40, right: 20),
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                if (mounted) {
                                  setState(() {
                                    _feedbackLst = [];
                                    _query = "";
                                    _isMenuShow = !_isMenuShow;
                                  });
                                }
                                _showBaiduOverlayMenu(_isMenuShow);
                                _getFeedback();
                              },
                              child: Column(children: <Widget>[
                                Icon(Icons.bookmark, color: MyColors.white),
                                Text('全部',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        inherit: false,
                                        fontSize: 16.0,
                                        color: Colors.white))
                              ])),
                          GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                if (mounted) {
                                  setState(() {
                                    _feedbackLst = [];
                                    _query = "性能建议";
                                    _isMenuShow = !_isMenuShow;
                                  });
                                }
                                _showBaiduOverlayMenu(_isMenuShow);
                                _getFeedback();
                              },
                              child: Column(children: <Widget>[
                                Icon(Icons.bookmark, color: MyColors.white),
                                Text(
                                  '性能建议',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      inherit: false,
                                      fontSize: 16.0,
                                      color: Colors.white),
                                )
                              ])),
                          GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                if (mounted) {
                                  setState(() {
                                    _feedbackLst = [];
                                    _query = "功能建议";
                                    _isMenuShow = !_isMenuShow;
                                  });
                                }
                                _showBaiduOverlayMenu(_isMenuShow);
                                _getFeedback();
                              },
                              child: Column(children: <Widget>[
                                Icon(Icons.bookmark, color: MyColors.white),
                                Text(
                                  '功能建议',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      inherit: false,
                                      fontSize: 16.0,
                                      color: Colors.white),
                                )
                              ])),
                          GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                if (mounted) {
                                  setState(() {
                                    _feedbackLst = [];
                                    _query = "其他";
                                    _isMenuShow = !_isMenuShow;
                                  });
                                }
                                _showBaiduOverlayMenu(_isMenuShow);
                                _getFeedback();
                              },
                              child: Column(children: <Widget>[
                                Icon(Icons.bookmark, color: MyColors.white),
                                Text(
                                  '其他',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      inherit: false,
                                      fontSize: 16.0,
                                      color: Colors.white),
                                )
                              ]))
                        ])))));
  }

  _showBaiduOverlayMenu(isMenuShow) {
    if (isMenuShow) {
      this._overlayEntry = this._createOverlayEntry(context);
      Overlay.of(context).insert(this._overlayEntry);
    } else {
      this._overlayEntry.remove();
    }
  }

  List _feedbackLst = [];

  int _pageIndex = 1;
  String _query = "";
  bool _done = false;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    _pageIndex = 1;
    _feedbackLst = [];
    _getFeedback();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _pageIndex++;
    _getFeedback();
    _refreshController.loadComplete();
  }

  @protected
  _getFeedback() async {
    try {
      BaseOptions options = BaseOptions(
          method: "get",
          queryParameters: {"q": _query, "page": _pageIndex, "per_Page": 10});
      var dio = new Dio(options);
      var response = await dio.get(Address.getAllFeedback());
      print(response.data.toString());
      if (response.data["status"] == 200) {
        if (mounted) {
          setState(() {
            _feedbackLst.addAll(response.data["data"]["feedback"]);
            _done = true;
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

    _getFeedback();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
            physics:
                BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            child: Column(children: <Widget>[
              GestureDetector(
                  key: _appMenuKey,
                  onTap: () {
                    setState(() {
                      _isMenuShow = !_isMenuShow;
                    });
                    _showBaiduOverlayMenu(_isMenuShow);
                  },
                  child: Container(
                      color: MyColors.white,
                      padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                      child: Row(children: <Widget>[
                        Text('分类', style: TextStyle(fontSize: MyFonts.f_16)),
                        Container(width: 4),
                        Icon(
                            _isMenuShow
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                            size: 28)
                      ]))),
              SizedBox(height: 10),
              _done == false?Center(child: Text("加载中......")):
              _feedbackLst.length == 0
                  ? Center(child: Text("暂无反馈信息~"))
                  : Container(
                width: double.infinity,
                height: 500,
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
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: itemBuilder,
                        itemCount: _feedbackLst.length,
                        shrinkWrap: true))
              )
            ])));
  }

  Widget itemBuilder(BuildContext context, int index) {
    Map _feedback = _feedbackLst[index];
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
        Widget>[
      Container(
          color: MyColors.white,
          padding: EdgeInsets.only(left: 18, right: 18),
          child: Column(children: <Widget>[
            Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("类型", style: TextStyle(fontSize: MyFonts.f_16)),
                      Text(_feedback["type"] ?? "暂无内容",
                          style: TextStyle(fontSize: MyFonts.f_16))
                    ])),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("内容",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: MyFonts.f_16)),
                  Text(_feedback["content"] ?? "",
                      style: TextStyle(fontSize: MyFonts.f_16))
                ]),
            Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("联系Ta", style: TextStyle(fontSize: MyFonts.f_16)),
                      Text(_feedback["contactWay"] ?? "",
                          style: TextStyle(fontSize: MyFonts.f_16))
                    ])),
            Padding(
                padding: EdgeInsets.only(bottom: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("反馈时间", style: TextStyle(fontSize: MyFonts.f_16)),
                      Text(
                          _feedback["createdAt"].toString().substring(0, 10) ??
                              "",
                          style: TextStyle(fontSize: MyFonts.f_16))
                    ]))
          ])),
      SizedBox(height: 10)
    ]);
  }
}
