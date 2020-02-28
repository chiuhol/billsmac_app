import 'dart:convert';
import 'dart:io';

import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Common/local/LocalStorage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:http/http.dart' as http;

import 'SearchMainPage.dart';

///Author:chiuhol
///2020-2-27

class DetailPage extends StatefulWidget {
  final String articleId;

  DetailPage({this.articleId});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String _title = '';
  String _subTitle = '';
  int _focusNum = 0;
  int _commentNum = 0;
  int _browseNum = 0;
  int _goodsNum = 0;

  bool _isGoods = false;
  bool _isFocus = false;

  String _sortType = '默认排序';

  List _commentLst = [];

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    _getArticle();
    _getComments();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _refreshController.loadComplete();
  }

  @protected
  _getArticle() async {
    try {
      http.Response res =
          await http.get(Address.getActiclesById(widget.articleId));
      if (jsonDecode(res.body)["status"] == 200) {
        print(jsonDecode(res.body)["data"]);
        var article = jsonDecode(res.body)["data"]["acticle"];
        setState(() {
          _title = article[0]["title"] ?? "";
          _subTitle = article[0]["subTitle"] ?? "";
          _focusNum = article[0]["focusNum"] ?? 0;
          _commentNum = article[0]["commentNum"] ?? 0;
          _browseNum = article[0]["browseNum"] ?? 0;
          _isFocus = article[0]["following"] ?? false;
          _goodsNum = article[0]["goodsNum"] ?? 0;
          _isGoods = article[0]["isGoods"] ?? false;
        });
      } else {
        CommonUtil.showMyToast(jsonDecode(res.body)["message"]);
      }
    } catch (err) {
      CommonUtil.showMyToast(err);
    }
  }

  @protected
  _getComments() async {
    try {
      http.Response res =
          await http.get(Address.getArticleComment(widget.articleId));
      if (jsonDecode(res.body)["status"] == 200) {
        print(jsonDecode(res.body)["data"]);
        setState(() {
          _commentLst = jsonDecode(res.body)["data"]["comments"];
        });
      } else {
        CommonUtil.showMyToast(jsonDecode(res.body)["message"]);
      }
    } catch (err) {
      CommonUtil.showMyToast(err);
    }
  }

  TextEditingController _commentController = TextEditingController();

  @protected
  _comment() {
    _commentController.clear();
    showModalBottomSheet(
        backgroundColor: MyColors.white_fe,
        context: context,
        builder: (BuildContext context) {
          return Stack(children: <Widget>[
            Container(
                height: 15, width: double.infinity, color: Colors.black54),
            Container(
                child: bottomSheet(_title, _commentController),
                decoration: BoxDecoration(
                    color: MyColors.white_fe,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15))))
          ]);
        }).then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            _saveComment();
          });
        }
      }
    });
  }

  @protected
  _saveComment() async {
    String token = await LocalStorage.get("token").then((result) {
      return result;
    });
    try {
      http.Response res = await http.post(Address.saveComment(widget.articleId),
          body: {
            "communityActicleId": widget.articleId,
            "content": _commentController.text
          },
          headers: {
            HttpHeaders.AUTHORIZATION: "Bearer $token"
          });
      if (jsonDecode(res.body)["status"] == 200) {
        if (mounted) {
          setState(() {
            _commentLst.add({"content": _commentController.text});
            _commentNum++;
          });
        }
      } else {
        CommonUtil.showMyToast(jsonDecode(res.body)["message"]);
      }
    } catch (err) {
      CommonUtil.showMyToast(err.toString());
    }
  }

  @protected
  _update(Map msg, Function function) async {
    String token = await LocalStorage.get("token").then((result) {
      return result;
    });
    try {
      BaseOptions options = BaseOptions(
          method: "patch", headers: {"Authorization": "Bearer $token"});
      var dio = new Dio(options);
      var response = await dio
          .patch(Address.updateArticlesById(widget.articleId), data: msg);
      print(response.data.toString());
      if (response.data["status"] == 200) {
        function();
      }
    } catch (err) {
      print(err.toString());
      CommonUtil.showMyToast(err.toString());
    }
  }

  @protected
  _updateComment(String commentId, Map msg, Function function) async {
    String token = await LocalStorage.get("token").then((result) {
      return result;
    });
    try {
      BaseOptions options = BaseOptions(
          method: "patch", headers: {"Authorization": "Bearer $token"});
      var dio = new Dio(options);
      var response = await dio.patch(
          Address.updateCommentById(widget.articleId, commentId),
          data: msg);
      print(response.data.toString());
      if (response.data["status"] == 200) {
        function();
      }
    } catch (err) {
      print(err.toString());
      CommonUtil.showMyToast(err.toString());
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getArticle();
    _getComments();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
            title: "",
            color: MyColors.white_fe,
            isBack: true,
            backIcon: Icon(Icons.keyboard_arrow_left,
                color: MyColors.grey_80, size: 28),
            rightEvent: rightEven()),
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
                      return Container(height: 55, child: Center(child: body));
                    }),
                    child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                          articleContent(),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Expanded(
                                    child: button('回答问题', _comment, false)),
                                Expanded(
                                    child: button(
                                        _isFocus == false ? '关注问题' : '已关注', () {
                                  _update({"following": !_isFocus}, () {
                                    if (mounted) {
                                      setState(() {
                                        if (_isFocus == false) {
                                          _isFocus = true;
                                          _focusNum++;
                                        } else {
                                          _isFocus = false;
                                          _focusNum--;
                                        }
                                      });
                                    }
                                  });
                                }, _isFocus))
                              ]),
                          Container(
                              color: MyColors.grey_f6,
                              width: double.infinity,
                              height: 12),
                          answersWidget()
                        ]))))));
  }

  Widget rightEven() {
    return Row(children: <Widget>[
      GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            CommonUtil.openPage(context, SearchMainPage());
          },
          child: Icon(IconData(0xe63a, fontFamily: 'MyIcons'),
              size: 20, color: MyColors.grey_80)),
      SizedBox(width: 18),
      GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {},
          child: Icon(Icons.more_horiz, size: 20, color: MyColors.grey_80))
    ]);
  }

  Widget articleContent() {
    return Padding(
        padding: EdgeInsets.only(left: 18, right: 18),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 8, bottom: 12),
                  child: Text(_title,
                      style: TextStyle(
                          color: MyColors.black_1a,
                          fontWeight: FontWeight.bold,
                          fontSize: MyFonts.f_18))),
              Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text(_subTitle,
                      style: TextStyle(
                          color: MyColors.black_44, fontSize: MyFonts.f_16))),
              Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(children: <Widget>[
                          richText(_focusNum, '关注'),
                          Container(
                              margin: EdgeInsets.only(left: 12, right: 12),
                              width: 3,
                              height: 3,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: MyColors.grey_99,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3)))),
                          richText(_commentNum, '评论'),
                          Container(
                              margin: EdgeInsets.only(left: 12, right: 12),
                              width: 3,
                              height: 3,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: MyColors.grey_99,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(3)))),
                          richText(_browseNum, '浏览')
                        ]),
                        GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              _update({"isGoods": !_isGoods}, () {
                                if (mounted) {
                                  setState(() {
                                    if (_isGoods == false) {
                                      _isGoods = true;
                                      _goodsNum++;
                                    } else {
                                      _isGoods = false;
                                      _goodsNum--;
                                    }
                                  });
                                }
                              });
                            },
                            child: Container(
                                padding: EdgeInsets.only(
                                    left: 8, right: 8, top: 5, bottom: 5),
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: MyColors.grey_f6),
                                child: Row(children: <Widget>[
                                  Icon(Icons.thumb_up,
                                      size: 18,
                                      color: _isGoods == false
                                          ? MyColors.grey_80
                                          : MyColors.blue_f6),
                                  SizedBox(width: 5),
                                  Text('好问题',
                                      style: TextStyle(
                                          color: _isGoods == false
                                              ? MyColors.grey_80
                                              : MyColors.blue_f6,
                                          fontSize: MyFonts.f_14)),
                                  SizedBox(width: 5),
                                  Text(_goodsNum.toString(),
                                      style: TextStyle(
                                          color: _isGoods == false
                                              ? MyColors.grey_80
                                              : MyColors.blue_f6,
                                          fontSize: MyFonts.f_14))
                                ])))
                      ]))
            ]));
  }

  Widget richText(int num, String title) {
    return RichText(
        text: TextSpan(
            text: num.toString(),
            style: TextStyle(
                color: MyColors.black_1a,
                fontSize: 16.0,
                fontWeight: FontWeight.bold),
            children: <TextSpan>[
          TextSpan(
              text: title,
              style: TextStyle(color: MyColors.grey_99, fontSize: 16.0))
        ]));
  }

  Widget button(String content, Function _click, bool _status) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _click,
        child: Container(
          padding: EdgeInsets.only(top: 12, bottom: 12),
          decoration: BoxDecoration(
              border: Border.all(color: MyColors.grey_ec, width: 0.5)),
          child: Column(children: <Widget>[
            Icon(
              Icons.rate_review,
              color: _status == false ? MyColors.grey_66 : MyColors.blue_f6,
            ),
            SizedBox(height: 8),
            Text(content,
                style: TextStyle(
                    color:
                        _status == false ? MyColors.grey_66 : MyColors.blue_f6,
                    fontSize: MyFonts.f_16))
          ]),
        ));
  }

  Widget answersWidget() {
    return Column(children: <Widget>[
      Padding(
          padding: EdgeInsets.all(18),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('回答' + " " + _commentNum.toString(),
                    style: TextStyle(
                        color: MyColors.black_1a,
                        fontWeight: FontWeight.bold,
                        fontSize: MyFonts.f_16)),
                GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {},
                    child: Row(children: <Widget>[
                      Text(_sortType,
                          style: TextStyle(
                              color: MyColors.grey_99, fontSize: MyFonts.f_16)),
                      SizedBox(width: 8),
                      Icon(Icons.keyboard_arrow_down,
                          size: 20, color: MyColors.grey_99)
                    ]))
              ])),
      SeparatorWidget(),
      _commentLst.length == 0
          ? Container(
              padding: EdgeInsets.only(top: 18),
              alignment: Alignment.bottomCenter,
              child: Text('该问题暂无回答',
                  style: TextStyle(
                      color: MyColors.grey_cb, fontSize: MyFonts.f_16)))
          : ListView.builder(
              itemBuilder: itemBuilder,
              itemCount: _commentLst.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics())
    ]);
  }

  Widget itemBuilder(BuildContext context, int index) {
    Map _comment = _commentLst[index];
    return Column(children: <Widget>[
      IntrinsicHeight(
          child: Padding(
              padding: EdgeInsets.all(18),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(children: <Widget>[
                      ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                              _comment["userAvatar"] == null
                                  ? "https://hbimg.huabanimg.com/3d08684c78c6bef02339f8be1ba7e1d64f6dcfd828ba-nTzqqR_fw658"
                                  : "http://116.62.141.151" +
                                      _comment["userAvatar"]
                                          .toString()
                                          .substring(21),
                              width: 20,
                              height: 20)),
                      SizedBox(width: 8),
                      _comment["userName"] == null
                          ? Text('匿名用户',
                              style: TextStyle(
                                  color: MyColors.grey_99,
                                  fontSize: MyFonts.f_14))
                          : Text(_comment["userName"],
                              style: TextStyle(
                                  color: MyColors.grey_99,
                                  fontSize: MyFonts.f_14))
                    ]),
                    SizedBox(height: 12),
                    Expanded(
                        child: Text(_comment["content"] ?? "",
                            style: TextStyle(
                                color: MyColors.black_44,
                                fontSize: MyFonts.f_16))),
                    SizedBox(height: 18),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(children: <Widget>[
                            Text(
                                (_comment["agreeNum"] ?? 0).toString() +
                                    " " +
                                    "赞同",
                                style: TextStyle(
                                    color: MyColors.grey_99,
                                    fontSize: MyFonts.f_14)),
                            SizedBox(width: 18),
                            Text(
                                (_comment["likeNum"] ?? 0).toString() +
                                    " " +
                                    "喜欢",
                                style: TextStyle(
                                    color: MyColors.grey_99,
                                    fontSize: MyFonts.f_14))
                          ]),
                          Row(children: <Widget>[
                            GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  _updateComment(_comment["_id"],
                                      {"isAgree": !_comment["isAgree"]}, () {
                                    if (mounted) {
                                      setState(() {
                                        if (!_comment["isAgree"]) {
                                          _comment["isAgree"] = true;
                                          _comment["agreeNum"]++;
                                        } else {
                                          _comment["isAgree"] = false;
                                          _comment["agreeNum"]--;
                                        }
                                      });
                                    }
                                  });
                                },
                                child: Icon(Icons.thumb_up,
                                    size: 18,
                                    color: _comment["isAgree"] == false
                                        ? MyColors.grey_99
                                        : MyColors.blue_f6)),
                            SizedBox(width: 8),
                            GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  _updateComment(_comment["_id"],
                                      {"isLike": !_comment["isLike"]}, () {
                                    if (mounted) {
                                      setState(() {
                                        setState(() {
                                          if (!_comment["isLike"]) {
                                            _comment["isLike"] = true;
                                            _comment["likeNum"]++;
                                          } else {
                                            _comment["isLike"] = false;
                                            _comment["likeNum"]--;
                                          }
                                        });
                                      });
                                    }
                                  });
                                },
                                child: Icon(Icons.favorite,
                                    size: 18,
                                    color: _comment["isLike"] == false
                                        ? MyColors.grey_99
                                        : MyColors.red_34))
                          ])
                        ])
                  ]))),
      Container(width: double.infinity, height: 5, color: MyColors.grey_f6)
    ]);
  }

  Widget bottomSheet(String title, TextEditingController _controller) {
    return Padding(
        padding: EdgeInsets.only(top: 18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
            Widget>[
          Padding(
              padding: EdgeInsets.only(bottom: 18, left: 18, right: 18),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          CommonUtil.closePage(context);
                        },
                        child: Text('取消',
                            style: TextStyle(
                                color: MyColors.red_34,
                                fontSize: MyFonts.f_16))),
                    GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          if (_controller.text == '') {
                            CommonUtil.showMyToast("详细描述你的知识、经验或见解吧~");
                            return;
                          }
                          Navigator.of(context).pop(_controller.text);
                        },
                        child: Text('发布',
                            style: TextStyle(
                                color: MyColors.blue_f6,
                                fontSize: MyFonts.f_16)))
                  ])),
          SeparatorWidget(),
          Padding(
              padding: EdgeInsets.only(top: 8, bottom: 8, left: 18, right: 18),
              child: Text(title,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                      color: MyColors.black_1a,
                      fontSize: MyFonts.f_18,
                      fontWeight: FontWeight.bold))),
          Container(width: double.infinity, height: 8, color: MyColors.grey_f6),
          Padding(
              padding: EdgeInsets.only(left: 18, top: 18, right: 18),
              child: TextField(
                  controller: _controller,
                  maxLines: 10,
                  maxLength: 300,
                  cursorColor: MyColors.orange_68,
                  decoration: InputDecoration(
                    hintText: "详细描述你的知识、经验或见解吧~",
                    hintStyle: TextStyle(
                      fontSize: MyFonts.f_15,
                      color: MyColors.grey_cb,
                    ),
                    border: InputBorder.none,
                  )))
        ]));
  }
}
