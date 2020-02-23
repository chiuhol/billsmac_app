import 'dart:convert';
import 'dart:io';

import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Common/manager/HttpManager.dart';
import 'package:billsmac_app/model/ArticleModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'ArticleDetailPage.dart';

///Author:chiuhol
///2020-2-2

class ArticleMainPage extends StatefulWidget {
  @override
  _ArticleMainPageState createState() => _ArticleMainPageState();
}

class _ArticleMainPageState extends State<ArticleMainPage> {
  List<ArticleModel> _articleLst = [];

  List<dynamic> _storiesLst = [];
  List<dynamic> _topStoriesLst = [];
  int _pageIndex = 1;

  final String url = "https://news-at.zhihu.com/api/4/news/latest";

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async {
    _articleLst = [];
    _pageIndex = 1;
    loadData_dio_get();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _pageIndex += 1;
    loadData_dio_get();

    _refreshController.loadComplete();
  }

  @protected
  _getDataLst() {
    _articleLst.add(ArticleModel(1, '理财第一步', '如何快速学会理财？？？', 'https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3861925707,2023347812&fm=26&gp=0.jpg'));
    _articleLst.add(ArticleModel(2, '理财第一步', '如何快速学会理财？？？', 'https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3861925707,2023347812&fm=26&gp=0.jpg'));
    _articleLst.add(ArticleModel(3, '理财第一步', '如何快速学会理财？？？', 'https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3861925707,2023347812&fm=26&gp=0.jpg'));
    _articleLst.add(ArticleModel(4, '理财第一步', '如何快速学会理财？？？', 'https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3861925707,2023347812&fm=26&gp=0.jpg'));
    _articleLst.add(ArticleModel(5, '理财第一步', '如何快速学会理财？？？', 'https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=3861925707,2023347812&fm=26&gp=0.jpg'));
  }

  void loadData_dio_get() async {
    var headers = Map<String, String>();
    headers['loginSource'] = 'IOS';
    headers['useVersion'] = '3.1.0';
    headers['isEncoded'] = '1';
    headers['bundleId'] = 'com.nongfadai.iospro';
    headers['Content-Type'] = 'application/json';

    Dio dio = Dio();
    dio.options.headers.addAll(headers);
    dio.options.baseUrl = "https://news-at.zhihu.com/api/4/news/latest";

    Response response = await dio.get("https://news-at.zhihu.com/api/4/news/latest");

    if (response.statusCode == HttpStatus.ok) {
      var res = response.data;
      if(mounted){
        setState(() {
          _storiesLst = response.data["stories"];
          _topStoriesLst = response.data["top_stories"];
        });
      }
//      print(response.headers);
//      print(response.data);
//      print(res);
      print(_storiesLst);
      print(_topStoriesLst);
    }
  }

  @protected
  _getStoriesLst()async{
    Map<String, dynamic> map = new Map();
    map = {};
    var res;
    res = await HttpManager.netFetch(
        context, Address.getStories(), map, null, null,
        noTip: true);
    if (res != null) {
      if (res.result) {
        setState(() {
          print(res.data);
        });
      } else {
        CommonUtil.showMyToast(res.data);
      }
    } else {
      CommonUtil.showMyToast(BaseCommon.SERVER_ERROR);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    loadData_dio_get();
//    _getStoriesLst();
//    _getDataLst();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          http.Response res = await http.get('http://116.62.141.151/users');
          print(jsonDecode(res.body));
//          print(jsonDecode(res.body)["stories"]);
//          List l = jsonDecode(res.body)["stories"];
//          l.forEach((e){
//            Firestore.instance.collection('/article').document().setData(e);
//          });
        },
      ),
        body: Container(
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
                        return Container(
                            height: 55, child: Center(child: body));
                      }),
                  child: ListView.builder(
                      itemCount: _storiesLst.length, itemBuilder: itemBuilderArticle,shrinkWrap: true)))
        ));
  }

  Widget itemBuilderArticle(BuildContext context, int index) {
    Map _article = _storiesLst[index];

    return AnimationConfiguration.staggeredList(
        position: index,
        duration: const Duration(milliseconds: 375),
        child: SlideAnimation(
            //滑动动画
            verticalOffset: 50.0,
            child: FadeInAnimation(
                //渐隐渐现动画
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: (){
                    CommonUtil.openPage(context, ArticleDetailPage(articleUrl: _article["url"]));
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          border: Border.all(color: MyColors.white_fe)
                      ),
                      margin: EdgeInsets.all(5),
//                    color: Theme.of(context).primaryColor,
                      height: 80,
                      child: Row(children: <Widget>[
                        Image.network('${_article["image"]}',fit: BoxFit.fill,width: 80,height: 80),
//                        CachedNetworkImage(
//                            fadeInDuration: Duration(milliseconds: 0),
//                            fadeOutDuration: Duration(milliseconds: 0),
//                            fit: BoxFit.fill,
//                            width: 80,
//                            height: 80,
//                            imageUrl: "${_article.photoUrl}"),
                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(left: 8),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      SizedBox(height: 8),
                                      Text(
                                        _article["title"] ?? "",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: TextStyle(
                                          color: MyColors.black_33,
                                          fontSize: MyFonts.f_15
                                        )
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        _article["hint"] ?? "",
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                          style: TextStyle(
                                              color: MyColors.grey_aa,
                                              fontSize: MyFonts.f_12
                                          )
                                      )
                                    ])))
                      ]))
                ))));
  }
}
