import 'dart:ffi';

import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Common/local/LocalStorage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'MyCustomCircle.dart';
import 'PieData.dart';
import 'dart:ui';

class ClassificationPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new ClassificationPageState();
  }
}

class ClassificationPageState extends State<ClassificationPage> {
  //数据源 下标  表示当前是PieData哪个对象
  int subscript = 0;

  //数据源
  List<PieData> mData;

  //传递值
  PieData pieData;

  //当前选中
  var currentSelect = 0;

  List _yearLst = [];
  int _idx = 0;

  List _expendTotleLst = []; //支出列表
  List _incomeTotleLst = []; //收入列表
  bool status = false; //false为支出，true为收入
  num _expendTotle = 0;
  num _incomeTotle = 0;

  @protected
  _getYearLst() {
    DateTime _now = DateTime.now();
    for (int i = 0; i <= 10; i++) {
      if (i == 0) {
        for (int j = _now.month; j > 0; j--) {
          _yearLst.add((_now.year - i).toString() + "." + j.toString());
        }
      } else {
        for (int j = 12; j > 0; j--) {
          _yearLst.add((_now.year - i).toString() + "." + j.toString());
        }
      }
    }
  }

  ///初始化 控制器
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //初始化 扇形 数据
    initData();

    _getYearLst();
    DateTime _now = DateTime.now();
    _getMsg(_now.year, _now.month);
  }

  @protected
  _getMsg(year, month) async {
    String _chatroomId = await LocalStorage.get("chatroomId").then((result) {
      return result;
    });
    try {
      BaseOptions options = BaseOptions(
          method: "get", queryParameters: {"year": year, "month": month});
      var dio = new Dio(options);
      var response = await dio.get(Address.staticByType(_chatroomId));
      print(response.data.toString());
      if (response.data["status"] == 200) {
        if (mounted) {
          setState(() {
            _expendTotleLst = [];
            _incomeTotleLst = [];
            _expendTotleLst.addAll(response.data["data"]["expendTotleLst"]);
            _incomeTotleLst.addAll(response.data["data"]["incomeTotleLst"]);
            _expendTotle = response.data["data"]["expendTotle"] ?? 0;
            _incomeTotle = response.data["data"]["incomeTotle"] ?? 0;
            if (!status) {
              _initPie(_expendTotleLst);
            } else {
              _initPie(_incomeTotleLst);
            }
          });
        }
      }
    } catch (err) {
      print(err.toString());
      CommonUtil.showMyToast("系统开小差了~");
    }
  }

  @protected
  _initPie(List msg) {
    mData = new List();
    mData = [];
    for (int i = 0; i < msg.length; i++) {
      if (msg[i]["typeStr"] == null || msg[i]["typeStr"] == "") {
        return;
      }
      PieData p1 = new PieData();
      p1.name = msg[i]["typeStr"];
      p1.price = msg[i]["expendTotle"];
      p1.percentage = double.parse(
          CommonUtil.formatNumber(msg[i]["expendTotle"] / _expendTotle, 3));
      p1.color = CommonUtil.slRandomColor();

      pieData = p1;
      mData.add(p1);
    }
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
              Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              if (mounted) {
                                setState(() {
                                  _idx++;
                                  List _lst = _yearLst[_idx].split(".");
                                  _getMsg(_lst[0], _lst[1]);
                                });
                              }
                            },
                            child: Icon(Icons.chevron_left, size: 24)),
                        Text(_yearLst[_idx].toString() ?? "",
                            style: TextStyle(
                                color: MyColors.black_1a,
                                fontSize: MyFonts.f_16)),
                        _idx == 0
                            ? Container()
                            : GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  if (mounted) {
                                    setState(() {
                                      _idx--;
                                      List _lst = _yearLst[_idx].split(".");
                                      _getMsg(_lst[0], _lst[1]);
                                    });
                                  }
                                },
                                child: Icon(Icons.chevron_right, size: 24))
                      ])),
              status == false
                  ? _expendTotleLst.length == 0
                      ? Padding(
                          padding: EdgeInsets.only(top: 240),
                          child: Center(child: Text("一滴水都没有~")))
                      : pieWidget()
                  : _incomeTotleLst.length == 0
                      ? Padding(
                          padding: EdgeInsets.only(top: 240),
                          child: Center(child: Text("一滴水都没有~")))
                      : pieWidget()
            ])));
  }

  Widget pieWidget() {
    return Column(children: <Widget>[
      Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (mounted) {
                setState(() {
                  status = !status;
                });
              }
            },
            child: Icon(Icons.loop, size: 20, color: MyColors.orange_68)),
        Text(status == true ? "总收入：" : "总支出：",
            style: TextStyle(fontSize: MyFonts.f_16, color: MyColors.grey_cb)),
        Text(status == true ? _incomeTotle.toString() : _expendTotle.toString(),
            style: TextStyle(fontSize: MyFonts.f_16, color: MyColors.grey_cb))
      ]),
      (status == true && _incomeTotle == 0 ||
              status == false && _expendTotle == 0)
          ? Padding(
              padding: EdgeInsets.only(top: 240),
              child: Center(child: Text("一滴水都没有~")))
          : Column(
        children: <Widget>[
          Container(width: 480, height: 300, child: _buildHeader()),
          Container(
              width: 380,
              decoration: BoxDecoration(
                  color: MyColors.white_fe,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(children: <Widget>[
                Padding(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("类别/比例",
                              style: TextStyle(
                                  color: MyColors.grey_cb, fontSize: MyFonts.f_16)),
                          Text("金额",
                              style: TextStyle(
                                  color: MyColors.grey_cb, fontSize: MyFonts.f_16))
                        ])),
                Padding(
                    padding:
                    EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 20),
                    child: ListView.builder(
                        itemBuilder: itemBuilder,
                        itemCount: status == true
                            ? _incomeTotleLst.length
                            : _expendTotleLst.length,
                        shrinkWrap: true,physics: NeverScrollableScrollPhysics()))
              ]))
        ]
      )
    ]);
  }

  Widget itemBuilder(BuildContext context, int index) {
    Map _totle;
    if (status) {
      _totle = _incomeTotleLst[index];
    } else {
      _totle = _expendTotleLst[index];
    }
    return Column(children: <Widget>[
      Padding(
          padding: EdgeInsets.only(top: 5, bottom: 5),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                    _totle["typeStr"] +
                        "/" +
                        CommonUtil.formatNumber(
                            _totle["expendTotle"] / _expendTotle, 3),
                    style: TextStyle(
                        color: MyColors.black_32, fontSize: MyFonts.f_16)),
                Text(_totle["expendTotle"].toString() ?? "",
                    style: TextStyle(
                        color: MyColors.black_32, fontSize: MyFonts.f_16))
              ])),
      SeparatorWidget()
    ]);
  }

  /// 构建布局（这里还做了其它的尝试，所以布局可以进行优化，比如按钮处使用的Column,这里可以在按钮下方再添加文字啥的，根据各自需求来改变就行）
  Widget _buildHeader() {
    // 卡片的中间显示我们自定义的饼状图
    return new Container(
        color: MyColors.grey_f9,
        height: double.infinity,
        width: double.infinity,
        child: Card(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            margin: const EdgeInsets.all(20.0),
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 左侧按钮
                  new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        new IconButton(
                          icon: new Icon(Icons.arrow_left),
                          color: Colors.green[500],
                          onPressed: _left,
                        )
                      ]),
                  //  自定义的饼状图
                  new Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        new Container(
                          width: 90.0,
                          height: 90.0,
                          padding: const EdgeInsets.only(bottom: 20.0),

                          /// 使用我们自定义的饼状图 ，并传入相应的参数
                          child:
                              new MyCustomCircle(mData, pieData, currentSelect),
                        )
                      ]),
// 右侧按钮
                  new Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        new IconButton(
                          icon: new Icon(Icons.arrow_right),
                          color: Colors.green[500],
                          onPressed: _changeData,
                        )
                      ])
                ])));
  }

  ///点击按钮时  改变显示的内容
  void _left() {
    setState(() {
      if (subscript > 0) {
        --subscript;
        --currentSelect;
      }
      pieData = mData[subscript];
    });
  }

  ///改变饼状图
  void _changeData() {
    setState(() {
      if (subscript < mData.length) {
        ++subscript;
        ++currentSelect;
      }
      pieData = mData[subscript];
    });
  }

  //初始化数据源
  void initData() {
    mData = new List();
    PieData p1 = new PieData();
    p1.name = 'A';
    p1.price = 'a';
    p1.percentage = 1.0;
    p1.color = CommonUtil.slRandomColor();

    pieData = p1;
    mData.add(p1);
  }
}
