import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:marquee_flutter/marquee_flutter.dart';

///Author:chiuhol
///2020-5-3

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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
                      height: 0.5,
                      color: CommonUtil.slRandomColor())),
              Padding(
                  padding:
                      EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 30),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("用户统计数据："),
                        Padding(
                            padding: EdgeInsets.only(top: 10, bottom: 10),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  countWidget(Icons.person, "用户总数", 10),
                                  countWidget(Icons.people, "本月新增用户数", 2)
                                ])),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              countWidget(Icons.library_books, "社区文章数", 10),
                              countWidget(Icons.rate_review, "本月新增反馈数", 2)
                            ]),
                        SizedBox(height: 20),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("用户月增长柱状图："),
                              SizedBox(height: 10),
                              Container(
                                  width: 380,
                                  height: 200,
                                  decoration: BoxDecoration(
                                      color: MyColors.white_fe,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: getBar())
                            ]),
                        SizedBox(height: 20),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("用户反馈月增长柱状图："),
                              SizedBox(height: 10),
                              Container(
                                  width: 380,
                                  height: 200,
                                  decoration: BoxDecoration(
                                      color: MyColors.white_fe,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20))),
                                  child: getBar())
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
