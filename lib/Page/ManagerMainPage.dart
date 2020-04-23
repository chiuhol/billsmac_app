import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'management/UsersPage.dart';

///Author:chiuhol
///2020-4-17

class ManagerMainPage extends StatefulWidget {
  static final String MANAGERMAINPAGE = '/ManagerMain_Page';

  @override
  _ManagerMainPageState createState() => _ManagerMainPageState();
}

class _ManagerMainPageState extends State<ManagerMainPage> {
  int _idx = 0;

  @override
  Widget build(BuildContext context) {
    Widget drawer = Drawer(
      //侧边栏按钮Drawer
      child: new ListView(
        physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(),
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: new Text('XXXXX'),
            accountEmail: new Text('XXXXXXXXXXX'),
//          设置人物头像
            currentAccountPicture: new CircleAvatar(
              backgroundImage: new NetworkImage(
                  'http://n.sinaimg.cn/translate/20170726/Zjd3-fyiiahz2863063.jpg'),
            ),
            decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.all(Radius.circular(5.0))
            ),
            onDetailsPressed: (){
//              ToastUtil.show(context, "tap");
            },
          ),
          new ListTile(
              title: new Text('个人中心'),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/LifecyclePage');
              }),
          new Divider(),
          new ListTile(
              title: new Text('Route 学习'),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();/*隐藏drawer*/
                Navigator.pushNamed(context, '/RoutePage');
              }),
          new Divider(),
          new ListTile(
              title: new Text('数据存储 学习'),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/DataPage');
              }),
          new Divider(),
          new ListTile(
              title: new Text('退出登录'),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushNamed(context, '/GesturePage');
              }),
          new Divider()
        ],
      ),
    );

    Widget page(){
      if(_idx == 1){
        return UsersPage();
      }else if(_idx == 2){
        return UsersPage();
      }else if(_idx == 3){
        return Container( child: Text('3'),);
      }else{
        return Center(
          child: Text(
            '欢迎您'
          )
        );
      }
    }

    return Scaffold(
      appBar: new AppBar(
          title: new Text("每日记账-后台管理"),
          backgroundColor: Colors.redAccent,
          centerTitle: true), //头部的标题AppBar
      drawer: drawer, //侧边栏按钮Drawer
      body: page(),
      floatingActionButton: SpeedDial(
        marginRight: 25,//右边距
        marginBottom: 50,//下边距
        animatedIcon: AnimatedIcons.menu_close,//带动画的按钮
        animatedIconTheme: IconThemeData(size: 22.0),
        visible: true,//是否显示按钮
        closeManually: false,//是否在点击子按钮后关闭展开项
        curve: Curves.bounceIn,//展开动画曲线
        overlayColor: Colors.black,//遮罩层颜色
        overlayOpacity: 0.5,//遮罩层透明度
        onOpen: () => print('OPENING DIAL'),//展开回调
        onClose: () => print('DIAL CLOSED'),//关闭回调
        tooltip: '便捷管理',//长按提示文字
        heroTag: 'speed-dial-hero-tag',//hero标记
        backgroundColor: Colors.lightGreen,//按钮背景色
        foregroundColor: Colors.white,//按钮前景色/文字色
        elevation: 8.0,//阴影
        shape: CircleBorder(),//shape修饰
        children: [//子按钮
          SpeedDialChild(
              child: Icon(Icons.accessibility),
              backgroundColor: Colors.red,
              label: '用户管理',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: (){
                if(mounted){
                  setState(() {
                    _idx = 1;
                  });
                }
              }
          ),
          SpeedDialChild(
            child: Icon(Icons.brush),
            backgroundColor: Colors.orange,
            label: '社区管理',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: (){
              if(mounted){
                setState(() {
                  _idx = 2;
                });
              }
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.keyboard_voice),
            backgroundColor: Colors.green,
            label: '管理员管理',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: (){
              if(mounted){
                setState(() {
                  _idx = 3;
                });
              }
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.keyboard_voice),
            backgroundColor: Colors.green,
            label: '处理反馈',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: (){
//              onButtonClick(3);
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.keyboard_voice),
            backgroundColor: Colors.green,
            label: '系统信息',
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: (){
//              onButtonClick(3);
            },
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
