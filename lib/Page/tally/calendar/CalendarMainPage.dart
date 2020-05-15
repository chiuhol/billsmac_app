import 'dart:convert';

import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Common/local/LocalStorage.dart';
import 'package:dio/dio.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:mini_calendar/mini_calendar.dart';

import '../TallyDetailPage.dart';

///Author:chiuhol
///2020-2-9

class CalendarMainPage extends StatefulWidget {
  @override
  _CalendarMainPageState createState() => _CalendarMainPageState();
}

class _CalendarMainPageState extends State<CalendarMainPage>
    with TickerProviderStateMixin {

  String _beginTime = "";//开始时间
  String _endTime = "";//结束时间
  String _beginTime2 = "";//开始时间2
  String _endTime2 = "";//结束时间2
  num _incomeTotle = 0;
  num _expendTotle = 0;
  List _chatContentLst = [];

  @protected
  _getChatContent(beginTime,endTime)async{
    String _chatroomId = await LocalStorage.get("chatroomId").then((result) {
      return result;
    });
    try {
      BaseOptions options =
      BaseOptions(method: "get", queryParameters: {"beginTime": beginTime,"endTime":endTime});
      var dio = new Dio(options);
      var response = await dio.get(Address.staticByTime(_chatroomId));
      print(response.data.toString());
      if (response.data["status"] == 200) {
        if (mounted) {
          setState(() {
            _chatContentLst = response.data["data"]["res"];
            if(_chatContentLst.length!=0){
              for(int i=0;i<_chatContentLst.length;i++){
                if(_chatContentLst[i]["amountType"] == "expend"){
                  _expendTotle+=double.parse(_chatContentLst[i]["amount"]);
                }else{
                  _incomeTotle+=double.parse(_chatContentLst[i]["amount"]);
                }
              }
            }
          });
        }
      }
    } catch (err) {
      CommonUtil.showMyToast("系统开小差了~");
    }
  }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
          title: "日历",
          isBack: true,
          backIcon: Icon(Icons.keyboard_arrow_left,
              color: MyColors.black_32, size: 28),
          color: MyColors.white_fe,
        ),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            color: MyColors.grey_f9,
            child: SingleChildScrollView(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max, children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 20,left: 20,right: 20),
                  child: Text("Tip：选择日期查看时间段流水，可连选~",style: TextStyle(
                      color: MyColors.orange_68,
                      fontSize: MyFonts.f_14
                  ))
                ),
                Container(
                    padding: EdgeInsets.only(left: 20,right: 20,top: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                    child: MonthPageView(
                      padding: EdgeInsets.all(1),
                      scrollDirection: Axis.horizontal,// 水平滑动或者竖直滑动
                      option: MonthOption(
                        maxDay: DateDay.now(),
                        enableContinuous: true,// 单选、连选控制
                        marks: {
//                          DateDay.now().copyWith(day: 1): '111',
//                          DateDay.now().copyWith(day: 5): '222',
//                          DateDay.now().copyWith(day: 13): '333',
//                          DateDay.now().copyWith(day: 19): '444',
//                          DateDay.now().copyWith(day: 26): '444',
                        },
                      ),
                      showWeekHead: true, // 显示星期头部
                      onContinuousSelectListen: (firstDay, endFay) {
                        if(mounted){
                          setState(() {
                            if(firstDay != null){
                              _beginTime2 = firstDay.toString();
                              _beginTime = firstDay.toString().substring(4);
                              if(endFay == null){
                                _getChatContent(firstDay.toString(), firstDay.add(Duration(days: 1)).toString());
                              }else{
                                _endTime2 = endFay.toString();
                                _endTime = endFay.toString().substring(4);
                                endFay.add(Duration(days: 1));
                                _getChatContent(firstDay.toString(), endFay.toString());
                              }
                            }
                          });
                        }
                      },// 连选回调
                      onMonthChange: (month) {
                      },// 月份更改回调
                      onDaySelected: (day, data) {
                        print(day);
                        print(data);
                      },// 日期选中会回调
                      onCreated: (controller){
                      }, // 控制器回调
                    )
                ),
                Container(
                    margin: EdgeInsets.only(left: 20,right: 20,top: 10,bottom: 30),
                    decoration: BoxDecoration(
                        color: MyColors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20))
                    ),
                  child: _chatContentLst.length == 0?Padding(padding: EdgeInsets.only(top: 50,bottom: 50),child: Center(child: Text("一滴水都没有~",style: TextStyle(
                      color: MyColors.grey_99,
                      fontSize: MyFonts.f_16
                  )))):Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 10,bottom: 10,left: 8,right: 8),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(_beginTime+"-"+_endTime,style: TextStyle(
                                  color: MyColors.grey_99,
                                  fontSize: MyFonts.f_14
                              )),
                              Row(
                                  children: <Widget>[
                                    Text("收入："+_incomeTotle.toString(),style: TextStyle(
                                        color: MyColors.grey_99,
                                        fontSize: MyFonts.f_14
                                    )),
                                    Padding(
                                      padding: EdgeInsets.only(left: 8,right: 8),
                                      child: Container(
                                          width: 1,
                                          height: 15,
                                          color: MyColors.grey_99
                                      )
                                    ),
                                    Text("支出："+_expendTotle.toString(),style: TextStyle(
                                        color: MyColors.grey_99,
                                        fontSize: MyFonts.f_14
                                    ))
                                  ]
                              )
                            ])
                      ),
                      SeparatorWidget(),
                      chatContentWidget()
                    ]
                  )
                )
              ])
            )));
  }

  Widget chatContentWidget(){
    return ListView.builder(itemBuilder: itemBuilder,itemCount: _chatContentLst.length,shrinkWrap: true,physics: NeverScrollableScrollPhysics());
  }

  Widget itemBuilder(BuildContext context,int index){
    Map _chatcontent = _chatContentLst[index];
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: (){
//        CommonUtil.openPage(context, TallyDetailPage(detail: _chatcontent))
//            .then((value) {
//          if (value != null && value == "success") {
//            _getChatContent(_beginTime2, _endTime2);
//          }
//        });
      },
      child: Padding(
          padding: EdgeInsets.only(top: 10,bottom: 10,left: 8,right: 8),
          child: Column(children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(_chatcontent["typeStr"]??"",style: TextStyle(
                      color: MyColors.black_1a,
                      fontSize: MyFonts.f_16
                  )),
                  Row(
                      children: <Widget>[
                        Text(_chatcontent["amountType"] == "expend"?"-":"+",style: TextStyle(
                            color: MyColors.black_1a,
                            fontSize: MyFonts.f_16
                        )),
                        Text(_chatcontent["amount"]??"",style: TextStyle(
                            color: MyColors.black_1a,
                            fontSize: MyFonts.f_16
                        ))
                      ]
                  )
                ]
            ),
            SizedBox(height: 8),
            index == _chatContentLst.length-1?Container():SeparatorWidget()
          ])
      )
    );
  }
}
