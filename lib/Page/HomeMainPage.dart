import 'package:billsmac_app/Common/CommonInsert.dart';
import 'package:billsmac_app/Page/mine/MineMainPage.dart';

import 'community/CommunityMainPage.dart';
import 'tally/TallyMainPage.dart';

///@Author:chiuhol
///2019-12-4

class HomeMainPage extends StatefulWidget {
  static final String HOMEMAINPAGE = '/HomeMain_Page';

  @override
  _HomeMainPageState createState() => _HomeMainPageState();
}

class _HomeMainPageState extends State<HomeMainPage> {
  //定义默认状态和点击状态的颜色
  Color _defaultColor = MyColors.grey_e4;
  Color _activeColor = MyColors.orange_67;
  int _currentIndex = 1;

  //定义一个pagecontroller 用于控制指定页面的显示
  final PageController _controller = PageController(
    initialPage: 1,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
            //pageview
            controller: _controller,
            physics: new NeverScrollableScrollPhysics(),
            children: <Widget>[
              //添加需要显示的页面
              CommunityMainPage(),
              TallyMainPage(),
              MineMainPage()
            ]),
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: MyColors.white_fe,
            //添加底部导航栏
            currentIndex: _currentIndex,
            //当下点击的条目
            onTap: (index) {
              //点击事件  在点击到指定的图标  改变currentindex
              _controller.jumpToPage(index);
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                  icon: Icon(IconData(0xe61c, fontFamily: 'MyIcons'),
                      size: 24, color: _defaultColor),
                  activeIcon: Icon(IconData(0xe648, fontFamily: 'MyIcons'),
                      size: 24, color: _activeColor),
                  title: Text('社区',
                      style: TextStyle(
                          color: _currentIndex != 0
                              ? _defaultColor
                              : _activeColor))),
              BottomNavigationBarItem(
                  icon: Icon(IconData(0xe61b, fontFamily: 'MyIcons'),
                      size: 24, color: _defaultColor),
                  activeIcon: Icon(IconData(0xe61b, fontFamily: 'MyIcons'),
                      size: 24, color: _activeColor),
                  title: Text('记账',
                      style: TextStyle(
                          color: _currentIndex != 1
                              ? _defaultColor
                              : _activeColor))),
              BottomNavigationBarItem(
                  icon: Icon(IconData(0xe608, fontFamily: 'MyIcons'),
                      size: 24, color: _defaultColor),
                  activeIcon: Icon(IconData(0xe608, fontFamily: 'MyIcons'),
                      size: 24, color: _activeColor),
                  title: Text('我的',
                      style: TextStyle(
                          color: _currentIndex != 2
                              ? _defaultColor
                              : _activeColor)))
            ]));
  }
}
