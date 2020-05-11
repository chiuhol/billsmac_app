import 'dart:io';

import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Common/local/LocalStorage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

///Author:chiuhol
///2020-4-29

class TeachMePage extends StatefulWidget {
  @override
  _TeachMePageState createState() => _TeachMePageState();
}

class _TeachMePageState extends State<TeachMePage> {
  List _corpusLst = [];

  TextEditingController _contentController = TextEditingController();
  TextEditingController _responseController = TextEditingController();

  int _pageIndex = 1;

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async {
    _pageIndex = 1;
    _corpusLst = [];
    _getCorpus();
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _pageIndex++;
    _getCorpus();
    _refreshController.loadComplete();
  }

  _addDialog(msg) async {
    String _title = '添加语料';
    bool _status = true;
    if(msg != ""){
      _contentController.text = msg["content"];
      _responseController.text = msg["response"];
      _title = "修改语料";
      _status = false;
    }else{
      _contentController.text = '';
      _responseController.text = '';
    }
    await showDialog(
        context: context,
        barrierDismissible: true,
        child: new SimpleDialog(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Center(
                child: Text(_title,
                    style: TextStyle(
                        color: MyColors.black_33, fontSize: MyFonts.f_16))),
            contentPadding: const EdgeInsets.all(10.0),
            children: <Widget>[
              SeparatorWidget(),
              SizedBox(height: 13.5),
              Column(children: <Widget>[
                Row(children: <Widget>[
                  Text("记账类型：", style: TextStyle(fontSize: MyFonts.f_16)),
                  Expanded(
                      child: TextField(
                          maxLines: 1,
                          controller: _contentController,
                          enabled: _status,
                          cursorColor: MyColors.green_8d,
                          style: TextStyle(
                              color: MyColors.green_8d, fontSize: MyFonts.f_18),
                          decoration: InputDecoration(
                              hintText: '请输入记账类型（例：早餐）',
                              hintStyle: TextStyle(
                                fontSize: MyFonts.f_16,
                                color: MyColors.red_5c,
                              ),
                              border: InputBorder.none)))
                ]),
                Padding(
                    padding: EdgeInsets.only(top: 18),
                    child: Row(children: <Widget>[
                      Text("回复内容：", style: TextStyle(fontSize: MyFonts.f_16)),
                      Expanded(
                          child: TextField(
                              maxLines: 1,
                              controller: _responseController,
                              cursorColor: MyColors.green_8d,
                              style: TextStyle(
                                  color: MyColors.green_8d,
                                  fontSize: MyFonts.f_18),
                              decoration: InputDecoration(
                                  hintText: '请输入回复内容',
                                  hintStyle: TextStyle(
                                    fontSize: MyFonts.f_16,
                                    color: MyColors.red_5c,
                                  ),
                                  border: InputBorder.none)))
                    ]))
              ]),
              SizedBox(height: 13.5),
              SeparatorWidget(),
              Container(
                  height: 45,
                  child: RaisedButton(
                      color: MyColors.white_ff,
                      elevation: 0,
                      splashColor: MyColors.white_ff,
                      child: Text('调教',                        textAlign: TextAlign.center,
                          style: TextStyle(
                              color: MyColors.green_8d,
                              fontSize: MyFonts.f_14)),
                      onPressed: () {
                        if (_contentController.text == '') {
                          CommonUtil.showMyToast("请输入记账类型（例：早餐）");
                          return;
                        }
                        if (_responseController.text == '') {
                          CommonUtil.showMyToast("请输入回复内容");
                          return;
                        }
                        if (_responseController.text.length > 12) {
                          CommonUtil.showMyToast("回复内容长度太长（<12）");
                          return;
                        }
                        Navigator.pop(context);
                        if(msg == ""){
                          _addTeach();
                        }else{
                          _updateTeach(msg);
                        }

                      }))
            ]));
  }

  //获取调教内容
  _getCorpus()async{
    String _userId = await LocalStorage.get("_id").then((result) {
      return result;
    });
    try {
      BaseOptions options = BaseOptions(method: "get",queryParameters: {"q": "", "page": _pageIndex, "per_Page": 10});
      var dio = new Dio(options);
      var response = await dio.get(Address.getCorpus(_userId));
      print(response.data.toString());
      if (response.data["status"] == 200) {
        if (mounted) {
          setState(() {
            _corpusLst.addAll(response.data["data"]["corpus"]);
          });
        }
      }
    } catch (err) {
      CommonUtil.showMyToast("系统开小差了~");
    }
  }

  //添加调教内容
  _addTeach()async{
    String _userId = await LocalStorage.get("_id").then((result) {
      return result;
    });
    try {
      BaseOptions options = BaseOptions(method: "post");
      var dio = new Dio(options);
      var response = await dio.post(Address.addCorpus(_userId), data: {
        "content": _contentController.text,
        "response": _responseController.text
      });
      print(response.data.toString());
      if (response.data["status"] == 200) {
        if (mounted) {
          setState(() {
            _corpusLst.add(response.data["data"]["corpus"]);
          });
        }
      }
    } catch (err) {
      CommonUtil.showMyToast("系统开小差了~");
    }
  }

  //修改调教内容
  _updateTeach(msg)async{
    String _userId = await LocalStorage.get("_id").then((result) {
      return result;
    });
    String _token = await LocalStorage.get("token").then((result) {
      return result;
    });
    try {
      BaseOptions options = BaseOptions(method: "patch",
          headers: {HttpHeaders.AUTHORIZATION: "Bearer $_token"});
      var dio = new Dio(options);
      var response = await dio.patch(Address.updateCorpus(_userId,msg["_id"]), data: {
        "response": _responseController.text
      });
      print(response.data.toString());
      if (response.data["status"] == 200) {
        if (mounted) {
          setState(() {
            for(int i=0;i<_corpusLst.length;i++){
              if(_corpusLst[i]["_id"] == msg["_id"]){
                _corpusLst[i]["response"] = _responseController.text;
              }
            }
          });
        }
        CommonUtil.showMyToast("修改成功");
      }
    } catch (err) {
      CommonUtil.showMyToast("系统开小差了~");
    }
  }

  //规则
  _ruleDialog(){
    showCupertinoDialog(
        context: context,
        builder: (_) => CupertinoAlertDialog(
          title: Text("语料规则",style: TextStyle(color: MyColors.black_1a,fontWeight: FontWeight.normal,fontSize: MyFonts.f_16)),
            content: Text('添加的语料将随机出现在聊天内容中',style: TextStyle(color: MyColors.black_1a,fontWeight: FontWeight.normal,fontSize: MyFonts.f_14)),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text(
                  '确定',
                  style: TextStyle(color: MyColors.red_43),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ]));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getCorpus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
            title: "我的语料",
            color: MyColors.white,
            isBack: true,
            rightEvent: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _ruleDialog,
              child: Text("语料规则",style: TextStyle(color: MyColors.black_1a,fontSize: MyFonts.f_14))
            ),
            backIcon: Icon(Icons.keyboard_arrow_left,
                color: MyColors.black_1a, size: 28)),
      body: Column(
          children: <Widget>[
            Expanded(
                child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics()),
                  child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(top: 20,bottom: 20),
                          child: Text("谢谢你教会我的所有事",style: TextStyle(
                              color: MyColors.orange_68,fontSize: MyFonts.f_16
                          ))
                        ),
                        Container(
                          width: double.infinity,
                          height: 600,
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
                              child: ListView.builder(itemBuilder: itemBuilder,itemCount: _corpusLst.length,shrinkWrap: true,physics: NeverScrollableScrollPhysics()))
                        )
                      ]
                  )
                )
            ),
            Padding(
              padding: EdgeInsets.only(left: 20,right: 20,bottom: 20),
              child: Container(
                  height: 45.0,
                  margin: EdgeInsets.only(top: 40.0),
                  decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.all(Radius.circular(45)),
                      gradient: LinearGradient(
                        colors: [
                          MyColors.orange_b8,
                          MyColors.orange_ab
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      )),
                  child: new SizedBox.expand(
                      child: new RaisedButton(
                        onPressed: (){
                          _addDialog("");
                        },
                        color: Colors.transparent,
                        elevation: 0,
                        // 正常时阴影隐藏
                        highlightElevation: 0,
                        child: new Text('立即调教',
                            style: TextStyle(
                                fontSize: 16.0, color: MyColors.white_fe)),
                        shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(45.0)),
                      )))
            )
          ]
      )
    );
  }

  Widget itemBuilder(BuildContext context, int index){
    Map _corpus = _corpusLst[index];
    return Column(
      children: <Widget>[
        Container(
            color: MyColors.white,
            padding: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(_corpus["content"]??"",style: TextStyle(color: MyColors.black_1a,fontSize: MyFonts.f_16)),
                            Padding(padding: EdgeInsets.only(top: 18),child: Text(_corpus["response"]??"",style: TextStyle(color: MyColors.black_1a,fontSize: MyFonts.f_16)))
                          ]
                      )
                  ),
                  GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: (){
                        _addDialog(_corpus);
                      },
                      child: Text(
                          "修改",
                          style: TextStyle(fontSize: MyFonts.f_14,color: MyColors.green_8d)
                      )
                  )
                ]
            )
        ),
        SeparatorWidget()
      ]
    );
  }
}
