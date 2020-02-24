import 'package:billsmac_app/Common/CommonInsert.dart';

import 'FeedbackHistoryPage.dart';
import 'FeedbackPage.dart';

///Author:chiuhol
///2020-2-24

class HelpAndFeedbackMainPage extends StatefulWidget {
  @override
  _HelpAndFeedbackMainPageState createState() =>
      _HelpAndFeedbackMainPageState();
}

class _HelpAndFeedbackMainPageState extends State<HelpAndFeedbackMainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MyAppBar(
            title: "帮助与反馈",
            color: MyColors.white_fe,
            isBack: true,
            rightEvent: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () {
                  CommonUtil.openPage(context, FeedbackHistoryPage());
                },
                child: Text('反馈历史',
                    style: TextStyle(
                        color: MyColors.black_32, fontSize: MyFonts.f_14))),
            backIcon: Icon(Icons.keyboard_arrow_left,
                color: MyColors.black_32, size: 28)),
        body: Container(
            width: double.infinity,
            height: double.infinity,
            color: MyColors.grey_f6,
            child: SingleChildScrollView(
                physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Column(children: <Widget>[
                  builder("我要反馈", () {
                    CommonUtil.openPage(context, FeedbackPage());
                  }),
                  Container(
                      color: MyColors.grey_f9,
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 12, bottom: 12, left: 12),
                      child: Text('常见问题',style: TextStyle(
                          color: MyColors.black_32,
                          fontSize: MyFonts.f_16)))
                ]))));
  }

  Widget builder(String title, Function function) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: function,
        child: Container(
            color: MyColors.white_fe,
            width: double.infinity,
            padding: EdgeInsets.only(top: 12, bottom: 12),
            child: Padding(
                padding: EdgeInsets.only(left: 12, right: 12),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(title,
                          style: TextStyle(
                              color: MyColors.black_32,
                              fontSize: MyFonts.f_16)),
                      Icon(Icons.chevron_right,
                          color: MyColors.grey_cb, size: 24)
                    ]))));
  }
}
