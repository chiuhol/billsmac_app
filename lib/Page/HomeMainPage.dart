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

class _HomeMainPageState extends State<HomeMainPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  //定义默认状态和点击状态的颜色
  static Color _defaultColor = MyColors.grey_e4;
  static Color _activeColor = MyColors.orange_67;
  static int _currentIndex = 1;

  List<Widget> _children = [
    CommunityMainPage(),
    TallyMainPage(),
    MineMainPage(),
  ];
  List<BottomNavigationBarItem> _list = <BottomNavigationBarItem>[];

  //创建页面控制器
//  var _pageController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

//    _pageController = new PageController(initialPage : 1);
    _list = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
          icon: Icon(IconData(0xe61c, fontFamily: 'MyIcons'),
              size: 24, color: _defaultColor),
          activeIcon: Icon(IconData(0xe648, fontFamily: 'MyIcons'),
              size: 24, color: _activeColor),
          title: Text('社区',
              style: TextStyle(
                  color: _currentIndex != 0 ? _defaultColor : _activeColor))),
      BottomNavigationBarItem(
          icon: Icon(IconData(0xe61b, fontFamily: 'MyIcons'),
              size: 24, color: _defaultColor),
          activeIcon: Icon(IconData(0xe61b, fontFamily: 'MyIcons'),
              size: 24, color: _activeColor),
          title: Text('记账',
              style: TextStyle(
                  color: _currentIndex != 1 ? _defaultColor : _activeColor))),
      BottomNavigationBarItem(
          icon: Icon(IconData(0xe608, fontFamily: 'MyIcons'),
              size: 24, color: _defaultColor),
          activeIcon: Icon(IconData(0xe608, fontFamily: 'MyIcons'),
              size: 24, color: _activeColor),
          title: Text('我的',
              style: TextStyle(
                  color: _currentIndex != 2 ? _defaultColor : _activeColor)))
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _children,
        ),
//        body: PageView(
//          controller: _pageController,
//          children: _children,
//          onPageChanged: (index){
//            _currentIndex = index;
//          },
//        ),
        bottomNavigationBar: BottomNavigationBar(
            backgroundColor: MyColors.white_fe,
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
//              _pageController.animateToPage(index, duration: new Duration(milliseconds: 500),curve:new ElasticOutCurve(4));
            },
            type: BottomNavigationBarType.fixed,
            items: _list));
  }
}
