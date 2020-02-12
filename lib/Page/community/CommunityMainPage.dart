import 'dart:async';

import 'package:billsmac_app/Common/CommonInsert.dart';

import 'ArticleMainPage.dart';
import 'DiscussMainPage.dart';

///Author:chiuhol
///2020-2-2

class CommunityMainPage extends StatefulWidget {
  @override
  _CommunityMainPageState createState() => _CommunityMainPageState();
}

class _CommunityMainPageState extends State<CommunityMainPage> {
  final List<Tab> tabs = <Tab>[
    new Tab(
      text: '文章',
    ),
    new Tab(
      text: '讨论',
    ),
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return new DefaultTabController(
        //length表示一个有几个标签栏
        length: tabs.length,
        //返回一个包含了appBar和body内容区域的脚手架
        child: new Scaffold(
            appBar: new PreferredSize(
                child: AppBar(
                  backgroundColor: Colors.white,
                  //标签栏位置存于appBar的底部，tabs是一个widget数组，就是每个标签栏的内容
                  bottom: new TabBar(
                    tabs: tabs,
                    //这表示当标签栏内容超过屏幕宽度时是否滚动，因为我们有8个标签栏所以这里设置是
                    isScrollable: true,
                    indicatorColor: MyColors.orange_68,
                    indicatorSize: TabBarIndicatorSize.label,
                    //标签颜色
                    labelColor: MyColors.orange_68,
                    //未被选中的标签的颜色
                    unselectedLabelColor: Colors.grey,
                    unselectedLabelStyle: TextStyle(fontSize: 16),
                    labelStyle: new TextStyle(fontSize: 18.0),
                  ),
                ),
                preferredSize: Size.fromHeight(50)),
            //根据tab内容，我在每个标签对应的视图里放了一个简单的文本，内容就是对应的标签名称。
            body: new TabBarView(children: <Widget>[
              ArticleMainPage(),
              DiscussMainPage(),
            ])));
  }
}
