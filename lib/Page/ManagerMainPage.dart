import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Common/local/LocalStorage.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'LoginPage.dart';
import 'management/CommunityManage.dart';
import 'management/FeedbackManage.dart';
import 'management/ManagerManage.dart';
import 'management/SystemManage.dart';
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

  String _title = '后台管理';
  String _account = "";
  String _jobNum = "";

  @protected
  _getMsg() async {
    String account = await LocalStorage.get("account").then((result) {
      return result;
    });
    String jobNum = await LocalStorage.get("jobNum").then((result) {
      return result;
    });
    if (mounted) {
      setState(() {
        _account = account;
        _jobNum = jobNum;
      });
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
    Widget drawer = Drawer(
      //侧边栏按钮Drawer
      child: new ListView(
        physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(),
        children: <Widget>[
          new UserAccountsDrawerHeader(
            accountName: Row(children: <Widget>[Text("工号："), Text(_jobNum)]),
            accountEmail: Row(children: <Widget>[Text("账号："), Text(_account)]),
//          设置人物头像
            currentAccountPicture: new CircleAvatar(
              backgroundImage: new NetworkImage(
                  'https://ss0.bdstatic.com/70cFvHSh_Q1YnxGkpoWK1HF6hhy/it/u=3305298991,2024211813&fm=26&gp=0.jpg'),
            ),
            decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.all(Radius.circular(5.0))),
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
              title: new Text('退出登录'),
              trailing: new Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).pop();
                CommonUtil.openPage(context, LoginPage());
              }),
          new Divider()
        ],
      ),
    );

    Widget page() {
      if (_idx == 1) {
        return UsersPage();
      } else if (_idx == 2) {
        return CommunityManage();
      } else if (_idx == 3) {
        return ManagerManage();
      } else if (_idx == 4) {
        return FeedbackManage();
      } else if (_idx == 5) {
        return SystemManage();
      } else {
        return Center(child: Text('欢迎您'));
      }
    }

    return Scaffold(
      appBar: new AppBar(
          title: new Text("每日记账-$_title"),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 18),
                child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      if (mounted) {
                        setState(() {
                          _idx = 0;
                          _title = '后台管理';
                        });
                      }
                    },
                    child: Icon(Icons.home)))
          ],
          backgroundColor: Colors.redAccent,
          centerTitle: true),
      //头部的标题AppBar
      drawer: drawer,
      //侧边栏按钮Drawer
      body: page(),
      floatingActionButton: SpeedDial(
          marginRight: 25,
          //右边距
          marginBottom: 50,
          //下边距
          animatedIcon: AnimatedIcons.menu_close,
          //带动画的按钮
          animatedIconTheme: IconThemeData(size: 22.0),
          visible: true,
          //是否显示按钮
          closeManually: false,
          //是否在点击子按钮后关闭展开项
          curve: Curves.bounceIn,
          //展开动画曲线
          overlayColor: Colors.black,
          //遮罩层颜色
          overlayOpacity: 0.5,
          //遮罩层透明度
          onOpen: () => print('OPENING DIAL'),
          //展开回调
          onClose: () => print('DIAL CLOSED'),
          //关闭回调
          tooltip: '便捷管理',
          //长按提示文字
          heroTag: 'speed-dial-hero-tag',
          //hero标记
          backgroundColor: Colors.lightGreen,
          //按钮背景色
          foregroundColor: Colors.white,
          //按钮前景色/文字色
          elevation: 8.0,
          //阴影
          shape: CircleBorder(),
          //shape修饰
          children: [
            //子按钮
            SpeedDialChild(
                child: Icon(Icons.people),
                backgroundColor: Colors.red,
                label: '用户管理',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () {
                  if (mounted) {
                    setState(() {
                      _title = "用户管理";
                      _idx = 1;
                    });
                  }
                }),
            SpeedDialChild(
              child: Icon(Icons.comment),
              backgroundColor: Colors.orange,
              label: '社区管理',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                if (mounted) {
                  setState(() {
                    _title = "社区管理";
                    _idx = 2;
                  });
                }
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.person_outline),
              backgroundColor: Colors.green,
              label: '管理员管理',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () {
                if (mounted) {
                  setState(() {
                    _title = "管理员管理";
                    _idx = 3;
                  });
                }
              },
            ),
            SpeedDialChild(
                child: Icon(Icons.library_books),
                backgroundColor: Colors.purple,
                label: '处理反馈',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () {
                  if (mounted) {
                    setState(() {
                      _title = "处理反馈";
                      _idx = 4;
                    });
                  }
                }),
            SpeedDialChild(
                child: Icon(Icons.android),
                backgroundColor: Colors.blueAccent,
                label: '系统信息',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () {
                  if (mounted) {
                    setState(() {
                      _title = "系统信息";
                      _idx = 5;
                    });
                  }
                })
          ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
