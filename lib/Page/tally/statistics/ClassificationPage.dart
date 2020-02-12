import 'package:billsmac_app/Common/CommonInsert.dart';
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

  ///初始化 控制器
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //初始化 扇形 数据
    initData();

  }

  @override
  Widget build(BuildContext context) {
    return _buildHeader();
  }

  /// 构建布局（这里还做了其它的尝试，所以布局可以进行优化，比如按钮处使用的Column,这里可以在按钮下方再添加文字啥的，根据各自需求来改变就行）
  Widget _buildHeader() {
    // 卡片的中间显示我们自定义的饼状图
    return new Container(
      color: MyColors.grey_f9,
      height: double.infinity,
      width: double.infinity,
      child: Card(
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
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
                ),
              ],
            ),
            //  自定义的饼状图
            new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                new Container(
                  width: 90.0,
                  height: 90.0,
                  padding: const EdgeInsets.only(bottom: 20.0),
                  /// 使用我们自定义的饼状图 ，并传入相应的参数
                  child: new MyCustomCircle(mData, pieData, currentSelect),
                ),
              ],
            ),
// 右侧按钮
            new Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                new IconButton(
                  icon: new Icon(Icons.arrow_right),
                  color: Colors.green[500],
                  onPressed: _changeData,
                ),
              ],
            ),
//
          ],
        ),
      )
    );
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
    p1.percentage = 0.1932;
    p1.color = Color(0xffff3333);

    pieData = p1;
    mData.add(p1);

    PieData p2 = new PieData();
    p2.name = 'B';
    p2.price = 'b';
    p2.percentage = 0.15;
    p2.color = Color(0xffccccff);
    mData.add(p2);

    PieData p3 = new PieData();
    p3.name = 'C';
    p3.price = 'c';
    p3.percentage = 0.1132;
    p3.color = Color(0xffCD00CD);
    mData.add(p3);

    PieData p4 = new PieData();
    p4.name = 'D';
    p4.price = 'd';
    p4.percentage = 0.0868;
    p4.color = Color(0xffFFA500);
    mData.add(p4);

    PieData p5 = new PieData();
    p5.name = 'E';
    p5.price = 'e';
    p5.percentage = 0.18023;
    p5.color = Color(0xff40E0D0);
    mData.add(p5);

    PieData p6 = new PieData();
    p6.name = 'F';
    p6.price = 'f';
    p6.percentage = 0.12888;
    p6.color =Color(0xffFFFF00);
    mData.add(p6);

    PieData p7 = new PieData();
    p7.name = 'G';
    p7.price = 'g';
    p7.percentage = 0.0888;
    p7.color = Color(0xff00ff66);
    mData.add(p7);

    PieData p8 = new PieData();
    p8.name = 'H';
    p8.price = 'h';
    p8.percentage = 0.06;
    p8.color = Color(0xffD9D9D9);
    mData.add(p8);
  }
}

