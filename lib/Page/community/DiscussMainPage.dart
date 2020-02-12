import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/model/DiscussModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///Author:chiuhol
///2020-2-2

class DiscussMainPage extends StatefulWidget {
  @override
  _DiscussMainPageState createState() => _DiscussMainPageState();
}

class _DiscussMainPageState extends State<DiscussMainPage> {
  List<DiscussModel> _discussLst = [];

  int _pageIndex = 1;

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async {
    _discussLst = [];
    _pageIndex = 1;
    _getData();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _pageIndex += 1;
    _getData();

    _refreshController.loadComplete();
  }

  @protected
  _getData() {
    _discussLst.add(DiscussModel(
        1,
        'https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2893834185,2450752305&fm=26&gp=0.jpg',
        '这双鞋好看吗',
        123,
        12));
    _discussLst.add(DiscussModel(
        2,
        'https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2893834185,2450752305&fm=26&gp=0.jpg',
        '这双鞋好看吗',
        33,
        132));
    _discussLst.add(DiscussModel(
        3,
        'https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2893834185,2450752305&fm=26&gp=0.jpg',
        '这双鞋好看吗',
        42,
        42));
    _discussLst.add(DiscussModel(
        4,
        'https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=2893834185,2450752305&fm=26&gp=0.jpg',
        '这双鞋好看吗',
        12,
        2));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimationLimiter(
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
                      return Container(
                          height: 55, child: Center(child: body));
                    }),
                child: GridView.builder(
                    itemCount: _discussLst.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //横轴元素个数
                        crossAxisCount: 2,
                        //纵轴间距
                        mainAxisSpacing: 10.0,
                        //横轴间距
                        crossAxisSpacing: 10.0,
                        //子组件宽高长度比例
                        childAspectRatio: 1.0),
                    itemBuilder: itemBuilderDiscuss))));
  }

  Widget itemBuilderDiscuss(BuildContext context, int index) {
    DiscussModel _discuss = _discussLst[index];
    return AnimationConfiguration.staggeredGrid(
        columnCount: _discussLst.length,
        position: index,
        duration: const Duration(milliseconds: 375),
        child: SlideAnimation(
            verticalOffset: 50.0,
            child: FadeInAnimation(
                child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {},
                    child: Container(
                        decoration: BoxDecoration(
                          color: MyColors.white_fe,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                          Image.network("${_discuss.thumbnail}",
                              height: 120, width: 200, fit: BoxFit.cover),
                          Padding(
                              padding:
                                  EdgeInsets.only(top: 18, left: 8, right: 8),
                              child: Text(_discuss.mainTitle,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: MyColors.black_32,
                                      fontSize: MyFonts.f_15,
                                      fontWeight: FontWeight.bold))),
                          Padding(
                              padding:
                                  EdgeInsets.only(top: 18, left: 8, right: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () {},
                                        child: Row(children: <Widget>[
                                          Icon(
                                              IconData(0xe687,
                                                  fontFamily: 'MyIcons'),
                                              size: 18,
                                              color: MyColors.grey_cb),
                                          SizedBox(width: 8),
                                          Text(_discuss.discuss.toString(),
                                              style: TextStyle(
                                                  color: MyColors.black_32,
                                                  fontSize: MyFonts.f_12))
                                        ])),
                                    SizedBox(width: 20),
                                    GestureDetector(
                                        behavior: HitTestBehavior.translucent,
                                        onTap: () {},
                                        child: Row(children: <Widget>[
                                          Icon(
                                              IconData(0xe60c,
                                                  fontFamily: 'MyIcons'),
                                              size: 18,
                                              color: MyColors.grey_cb),
                                          SizedBox(width: 8),
                                          Text(_discuss.like.toString(),
                                              style: TextStyle(
                                                  color: MyColors.black_32,
                                                  fontSize: MyFonts.f_12))
                                        ]))
                                  ]))
                        ]))))));
  }
}
