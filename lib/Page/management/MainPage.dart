import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:dio/dio.dart';
import 'package:marquee_flutter/marquee_flutter.dart';

///Author:chiuhol
///2020-5-3

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  num _userSum = 0; //用户总数
  num _userByMonthSum = 0; //当月增长用户数
  num _articleSum = 0; //社区文章总数
  num _feedbackByMonthSum = 0; //月用户反馈数
  List<Barsales> _userByMonthSumLst = []; //每月用户增长数
  List<Barsales2> _feedbackByMonthSumLst = []; //每月反馈增长数

  @protected
  _getMsg() async {
    try {
      BaseOptions options = BaseOptions(method: "get");
      var dio = new Dio(options);
      var response = await dio.get(Address.getUserStatic());
      print(response.data.toString());
      if (response.data["status"] == 200) {
        if (mounted) {
          setState(() {
            _userSum = response.data["data"]["userSum"] ?? 0;
            _userByMonthSum = response.data["data"]["userSumByMonth"] ?? 0;
            _articleSum = response.data["data"]["articlesSum"] ?? 0;
            _feedbackByMonthSum =
                response.data["data"]["feedbackSumByMonth"] ?? 0;
            List _lst = response.data["data"]["monthSumLst"];
            List _lst2 = response.data["data"]["feedbackMonthSumLst"];
            _lst = CommonUtil.reversePeople(_lst);
            _lst2 = CommonUtil.reversePeople(_lst2);
            for (int i = 0; i < _lst.length; i++) {
              _userByMonthSumLst.add(
                  new Barsales(_lst[i]["month"].toString(), _lst[i]["sum"]));
            }
            for (int j = 0; j < _lst2.length; j++) {
              _feedbackByMonthSumLst.add(
                  new Barsales2(_lst2[j]["month"].toString(), _lst2[j]["sum"]));
            }
          });
        }
      }
    } catch (err) {
      print(err.toString());
      CommonUtil.showMyToast("系统开小差了~");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getMsg();
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
              Row(children: <Widget>[
                SizedBox(width: 5),
                Icon(Icons.volume_up, size: 30, color: MyColors.orange_68),
                SizedBox(width: 10),
                Expanded(
                    child: Container(
                        width: double.infinity,
                        height: 30,
                        child: MarqueeWidget(
                          text: "每日记账后台管理，欢迎您！",
                          textStyle: TextStyle(
                              color: CommonUtil.slRandomColor(),
                              fontSize: MyFonts.f_22,
                              fontWeight: FontWeight.bold),
                          scrollAxis: Axis.horizontal,
                        )))
              ]),
              Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Container(
                      width: double.infinity,
                      height: 0.2,
                      color: CommonUtil.slRandomColor())),
              Padding(
                  padding:
                      EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 30),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("系统统计数据："),
                        Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  countWidget(Icons.person, "用户总数", _userSum),
                                  countWidget(
                                      Icons.people, "本月新增用户数", _userByMonthSum)
                                ])),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              countWidget(
                                  Icons.library_books, "社区文章数", _articleSum),
                              countWidget(Icons.rate_review, "本月新增反馈数",
                                  _feedbackByMonthSum)
                            ]),
                        SizedBox(height: 20),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("用户月增长柱状图（数量/月份）："),
                              SizedBox(height: 10),
                              Container(
                                  width: 380,
                                  height: 200,
                                  decoration: BoxDecoration(
                                      color: MyColors.white_fe,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: getUserBar())
                            ]),
                        SizedBox(height: 20),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("用户反馈月增长柱状图（数量/月份）："),
                              SizedBox(height: 10),
                              Container(
                                  width: 380,
                                  height: 200,
                                  decoration: BoxDecoration(
                                      color: MyColors.white_fe,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: getFeedbackBar())
                            ])
                      ]))
            ])));
  }

  Widget countWidget(IconData icon, String title, num sum) {
    return Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: MyColors.white_fe,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Row(children: <Widget>[
          Icon(icon, size: 40, color: CommonUtil.slRandomColor()),
          Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(children: <Widget>[
                Text("$title：", style: TextStyle(fontSize: MyFonts.f_12)),
                SizedBox(height: 10),
                Text(sum.toString(),
                    style: TextStyle(
                        fontSize: MyFonts.f_25,
                        fontWeight: FontWeight.bold,
                        color: CommonUtil.slRandomColor()))
              ]))
        ]));
  }

  Widget getUserBar() {
    var seriesBar = [
      charts.Series(
        data: _userByMonthSumLst,
        domainFn: (Barsales sales, _) => sales.month,
        measureFn: (Barsales sales, _) => sales.sum,
        id: "User",
      )
    ];
    return charts.BarChart(seriesBar);
  }

  Widget getFeedbackBar() {
    var seriesBar = [
      charts.Series(
        data: _feedbackByMonthSumLst,
        domainFn: (Barsales2 sales, _) => sales.month,
        measureFn: (Barsales2 sales, _) => sales.sum,
        id: "Feedback",
      )
    ];
    return charts.BarChart(seriesBar);
  }
}

class Barsales {
  String month;
  int sum;

  Barsales(this.month, this.sum);
}

class Barsales2 {
  String month;
  int sum;

  Barsales2(this.month, this.sum);
}
