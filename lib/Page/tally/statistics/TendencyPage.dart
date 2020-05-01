import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Common/local/LocalStorage.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:dio/dio.dart';

class TendencyPage extends StatefulWidget {
  @override
  _TendencyPageState createState() => _TendencyPageState();
}

class _TendencyPageState extends State<TendencyPage> {
  List _yearLst = []; //年份列表
  List _totleByMonthLst = []; //统计列表
  int idx = 0;

  List<Linesales> dataLine = [
    new Linesales(new DateTime(2020, 5, 1), 0),
    new Linesales(new DateTime(2020, 5, 2), 0),
    new Linesales(new DateTime(2020, 5, 3), 0),
    new Linesales(new DateTime(2020, 5, 5), 0),
    new Linesales(new DateTime(2020, 5, 6), 0),
    new Linesales(new DateTime(2020, 5, 7), 0),
    new Linesales(new DateTime(2020, 5, 8), 0),
    new Linesales(new DateTime(2020, 5, 9), 0),
    new Linesales(new DateTime(2020, 5, 10), 0),
    new Linesales(new DateTime(2020, 5, 11), 0),
    new Linesales(new DateTime(2020, 5, 12), 0)
  ];

  bool _incomeStatus = false; //收入状态
  bool _expendStatus = true; //支出状态
  bool _surplusStatus = false; //结余状态

  //获取统计数据
  @protected
  _getMsg(_query) async {
    String _chatroomId = await LocalStorage.get("chatroomId").then((result) {
      return result;
    });
    try {
      BaseOptions options =
          BaseOptions(method: "get", queryParameters: {"q": _query});
      var dio = new Dio(options);
      var response = await dio.get(Address.static(_chatroomId));
      print(response.data.toString());
      if (response.data["status"] == 200) {
        if (mounted) {
          setState(() {
            _totleByMonthLst.addAll(response.data["data"]["totleByMonthLst"]);
            _drawLiners(_totleByMonthLst, "支出");
          });
        }
      }
    } catch (err) {
      print(err.toString());
      CommonUtil.showMyToast("系统开小差了~");
    }
  }

  @protected
  _drawLiners(List msg, String type) {
    dataLine = [];
    String totleType = "支出";
    if (type == "支出") {
      totleType = "expendTotleByMonth";
    } else if (type == "收入") {
      totleType = "incomeTotleByMonth";
    } else {
      for (int i = 0; i < msg.length; i++) {
        dataLine.add(new Linesales(
            new DateTime(2020, 5, i),
            int.parse(
                (msg[i]["incomeTotleByMonth"] - msg[i]["expendTotleByMonth"])
                    .toStringAsFixed(0))));
      }
      return;
    }
    for (int i = 0; i < msg.length; i++) {
      dataLine.add(new Linesales(new DateTime(2020, 5, i),
          int.parse(msg[i][totleType].toStringAsFixed(0))));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    DateTime _now = DateTime.now();
    int year = int.parse(_now.toString().substring(0, 4));
    for (int i = 0; i <= 10; i++) {
      _yearLst.add(year - i);
    }
    _getMsg(_now.year);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: MyColors.grey_f9,
      child: SingleChildScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          child: Column(children: <Widget>[
//            Container(
//              width: 380,
//              height: 200,
//              decoration: BoxDecoration(
//                  color: MyColors.white_fe,
//                  borderRadius: BorderRadius.all(Radius.circular(20))),
//              child: getBar(),
//            ),
//            SizedBox(height: 20),
            Padding(
                padding:
                    EdgeInsets.only(left: 10, right: 20, top: 10, bottom: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(children: <Widget>[
                        GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              if (mounted) {
                                setState(() {
                                  idx++;
                                  _totleByMonthLst = [];
                                  dataLine = [];
                                  _getMsg(_yearLst[idx]);
                                });
                              }
                            },
                            child: Icon(Icons.chevron_left, size: 24)),
                        Padding(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: Text(_yearLst[idx].toString() ?? "",
                                style: TextStyle(
                                    color: MyColors.black_1a,
                                    fontSize: MyFonts.f_16))),
                        idx == 0
                            ? Container()
                            : GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  if (mounted) {
                                    setState(() {
                                      idx--;
                                      _totleByMonthLst = [];
                                      dataLine = [];
                                      _getMsg(_yearLst[idx]);
                                    });
                                  }
                                },
                                child: Icon(Icons.chevron_right, size: 24))
                      ]),
                      Row(children: <Widget>[
                        selected("支出", _expendStatus),
                        Padding(
                            padding: EdgeInsets.only(left: 5, right: 5),
                            child: selected("收入", _incomeStatus)),
                        selected("结余", _surplusStatus)
                      ])
                    ])),
            Container(
                width: 380,
                height: 200,
                decoration: BoxDecoration(
                    color: MyColors.white_fe,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                child: getLine()),
            Padding(
                padding: EdgeInsets.only(top: 20),
                child: Container(
                    padding: EdgeInsets.only(right: 15),
                    width: 380,
                    decoration: BoxDecoration(
                        color: MyColors.white_fe,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(top: 10, bottom: 10),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Expanded(
                                        child: Text("时间",
                                            style: TextStyle(
                                                color: MyColors.grey_cb,
                                                fontSize: MyFonts.f_16),
                                            textAlign: TextAlign.end),
                                        flex: 1),
                                    Expanded(
                                      child: Text("收入",
                                          style: TextStyle(
                                              color: MyColors.grey_cb,
                                              fontSize: MyFonts.f_16),
                                          textAlign: TextAlign.end),
                                      flex: 2,
                                    ),
                                    Expanded(
                                        child: Text("支出",
                                            style: TextStyle(
                                                color: MyColors.grey_cb,
                                                fontSize: MyFonts.f_16),
                                            textAlign: TextAlign.end),
                                        flex: 2),
                                    Expanded(
                                        child: Text("结余",
                                            style: TextStyle(
                                                color: MyColors.grey_cb,
                                                fontSize: MyFonts.f_16),
                                            textAlign: TextAlign.end),
                                        flex: 2)
                                  ])),
                          SeparatorWidget(),
                          ListView.builder(
                              itemBuilder: itemBuilder,
                              itemCount: _totleByMonthLst.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics())
                        ])))
          ])),
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
    Map _totle = _totleByMonthLst[index];
    return Column(children: <Widget>[
      Padding(
          padding: EdgeInsets.only(top: 10, bottom: 10),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Expanded(
                    child: Text(_totle["month"] ?? "",
                        style: TextStyle(
                            color: MyColors.black_32, fontSize: MyFonts.f_14),
                        textAlign: TextAlign.end),
                    flex: 1),
                Expanded(
                    child: Text(_totle["incomeTotleByMonth"].toString() ?? "",
                        style: TextStyle(
                            color: MyColors.black_32, fontSize: MyFonts.f_14),
                        textAlign: TextAlign.end),
                    flex: 2),
                Expanded(
                    child: Text(_totle["expendTotleByMonth"].toString() ?? "",
                        style: TextStyle(
                            color: MyColors.black_32, fontSize: MyFonts.f_14),
                        textAlign: TextAlign.end),
                    flex: 2),
                Expanded(
                    child: Text(
                        (_totle["incomeTotleByMonth"] -
                                    _totle["expendTotleByMonth"])
                                .toString() ??
                            "",
                        style: TextStyle(
                            color: MyColors.red_5c, fontSize: MyFonts.f_14),
                        textAlign: TextAlign.end),
                    flex: 2)
              ])),
      SeparatorWidget()
    ]);
  }

  Widget selected(String title, bool status) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (mounted) {
            setState(() {
              if (title == "支出") {
                _incomeStatus = false;
                _surplusStatus = false;
                _expendStatus = !_expendStatus;
                _drawLiners(_totleByMonthLst, "支出");
              } else if (title == "收入") {
                _expendStatus = false;
                _surplusStatus = false;
                _incomeStatus = !_incomeStatus;
                _drawLiners(_totleByMonthLst, "收入");
              } else {
                _incomeStatus = false;
                _expendStatus = false;
                _surplusStatus = !_surplusStatus;
                _drawLiners(_totleByMonthLst, "结余");
              }
            });
          }
        },
        child: Container(
            width: 50,
            height: 25,
            decoration: BoxDecoration(
                color: status == false ? MyColors.blue_e9 : MyColors.orange_68,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Center(
                child: Text(title,
                    style: TextStyle(
                        color: MyColors.white, fontSize: MyFonts.f_12)))));
  }

  Widget getLine() {
    var seriesLine = [
      charts.Series<Linesales, DateTime>(
        data: dataLine,
        domainFn: (Linesales lines, _) => lines.time,
        measureFn: (Linesales lines, _) => lines.sale,
        id: "Lines",
      )
    ];
    //是TimeSeriesChart，而不是LineChart,因为x轴是DataTime类
    Widget line = charts.TimeSeriesChart(seriesLine);
    //line = charts.LineChart(series);
    return line;
  }

  Widget getBar() {
    List<Barsales> dataBar = [
      new Barsales("1", 20),
      new Barsales("2", 50),
      new Barsales("3", 20),
      new Barsales("4", 80),
      new Barsales("5", 120),
      new Barsales("6", 30),
    ];

    var seriesBar = [
      charts.Series(
        data: dataBar,
        domainFn: (Barsales sales, _) => sales.day,
        measureFn: (Barsales sales, _) => sales.sale,
        id: "Sales",
      )
    ];
    return charts.BarChart(seriesBar);
  }
}

class Barsales {
  String day;
  int sale;

  Barsales(this.day, this.sale);
}

class Linesales {
  DateTime time;
  int sale;

  Linesales(this.time, this.sale);
}
